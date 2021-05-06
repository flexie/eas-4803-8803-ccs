using JUDI, PyPlot, Images, JOLI, IterativeSolvers, LinearAlgebra, Printf, Statistics

# Velocity model

# number of gridpoints
n = (201, 101)

# Grid spacing
d = (10.0, 10.0)

# Origin
o = (0., 0.)

# Velocity [km/s]
v = ones(Float32,n) .+ 0.5f0
v[:,20:50] .= 2.5f0
v[:,51:71] .= 3f0
v[:,71:end] .= 3.5f0

# Slowness squared [s^2/km^2]
m = (1f0 ./ v).^2
m0 = convert(Array{Float32,2},imfilter(m, Kernel.gaussian(4)))
m0[:,1:19] = m[:,1:19]
dm = vec(m - m0)


figure();
subplot(1,3,1)
imshow(reshape(m,n)');title("m")
subplot(1,3,2)
imshow(reshape(m0,n)');title("m0")
subplot(1,3,3)
imshow(reshape(dm,n)',cmap="Greys");title("dm")


model0 = Model(n, d, o, m0; nb = 80)
model = Model(n, d, o, m; nb = 80)

# source geometry
nsrc = 8
xsrc = convertToCell(range(900f0, stop=1100f0, length=nsrc))
ysrc = convertToCell(range(0f0, stop=0f0, length=nsrc))
zsrc = convertToCell(range(6f0, stop=6f0, length=nsrc))

timeS = 1000f0
dtS = 1f0

srcGeometry = Geometry(xsrc,ysrc,zsrc; dt=dtS, t=timeS)

# Receievers reflection
nrec = 100
xrec = range(d[1], stop=(n[1]-1)*d[1], length=nrec)
yrec = 0f0
zrec = range(10f0, stop=10f0, length=nrec)

timeR = 1000f0
dtR = 1f0

recGeometry = Geometry(xrec,yrec,zrec;dt=dtR,t=timeR, nsrc=nsrc)

f0 = 0.02f0  # 20 Hz wavelet
wavelet = ricker_wavelet(timeS, dtS, f0)
q = judiVector(srcGeometry, wavelet)

# Set up info structure for linear operators
ntComp = get_computational_nt(srcGeometry, recGeometry, model)
info = Info(prod(n), nsrc, ntComp)

F = judiModeling(info, model, srcGeometry, recGeometry)
F0 = judiModeling(info, model0, srcGeometry, recGeometry)

J = judiJacobian(F0,q)

dlin = J*dm
dobs = F*q
dobs0 = F0*q

## RTM

rtm1 = J'*dlin

## RTM w/ isic

J.options.isic = true
rtm2 = J'*dlin

figure();
subplot(1,2,1)
imshow(reshape(rtm1.data,n)',vmin=-0.01*norm(rtm1.data,Inf),vmax=0.01*norm(rtm1.data,Inf),cmap="Greys");title("vanilla RTM")
subplot(1,2,2)
imshow(reshape(rtm2.data,n)',vmin=-0.01*norm(rtm2.data,Inf),vmax=0.01*norm(rtm2.data,Inf),cmap="Greys");title("RTM w/ isic")

# Preconditioner
Tm = judiTopmute(model0.n, 19, 2)  # Mute water column
S = judiDepthScaling(model0)
Mr = S*Tm

## vanilla LSQR

x1 = 0f0 .* model0.m

lsqr!(x1,J*Mr,dlin;maxiter=2,atol=0f0,verbose=true)

figure();imshow(reshape(Mr*x1,n)',cmap="Greys",vmin=-0.05*norm(Mr*x1,Inf),vmax=0.05*norm(Mr*x1,Inf))

### Sparsity promoting

# Soft thresholding functions and Curvelet transform
soft_thresholding(x::Array{Float64}, lambda) = sign.(x) .* max.(abs.(x) .- convert(Float64, lambda), 0.0)
soft_thresholding(x::Array{Float32}, lambda) = sign.(x) .* max.(abs.(x) .- convert(Float32, lambda), 0f0)

n = model0.n
C0 = joCurvelet2D(n[1], 2*n[2]; zero_finest = false, DDT = Float32, RDT = Float64)

function C_fwd(im, C, n)
	im = hcat(reshape(im, n), reshape(im, n)[:, end:-1:1])
	coeffs = C*vec(im)
	return coeffs
end

function C_adj(coeffs, C, n)
	im = reshape(C'*coeffs, n[1], 2*n[2])
	return vec(im[:, 1:n[2]] .+ im[:, end:-1:n[2]+1])
end

C = joLinearFunctionFwd_T(size(C0, 1), n[1]*n[2],
                          x -> C_fwd(x, C0, n),
                          b -> C_adj(b, C0, n),
                          Float32,Float64, name="Cmirrorext")


src_list = Set(collect(1:nsrc))
batchsize = 2
lambda = 0f0

x3 = 0f0 .* model0.m
z = deepcopy(x3)

niter = 8

# Main loop
for j = 1:niter
    # Select batch and set up left-hand preconditioner
    length(src_list) < batchsize && (global src_list = Set(collect(1:nsrc)))
    i = [pop!(src_list) for b=1:batchsize]
    println("LS-RTM Iteration: $(j), imaging sources $(i)")
    flush(Base.stdout)

    residual = J[i]*Mr*x3-dlin[i]
    phi = 0.5 * norm(residual)^2
    g = Mr'*J[i]'*residual

    # Step size and update variable
    t = Float32.(2*phi/norm(g)^2)

    # Update variables and save snapshot
    global z -= t*g
    C_z = C*z
    (j==1) && (global lambda = quantile(abs.(C_z), .95))   # estimate thresholding parameter in 1st iteration
    global x3 = adjoint(C)*soft_thresholding(C_z, lambda)

    @printf("At iteration %d function value is %2.2e and step length is %2.2e \n", j, phi, t)
    @printf("Lambda is %2.2e \n", lambda)
end

figure();imshow(reshape(Mr*x3,n)',cmap="Greys",vmin=-0.05*norm(Mr*x3,Inf),vmax=0.05*norm(Mr*x3,Inf))