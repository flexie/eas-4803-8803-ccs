
# Homework 4 : Seismic imaging

In this exercise, we conduct a small 2D seismic imaging experiment on a 4-layer model example with [JUDI](https://github.com/slimgroup/JUDI.jl). We suggest you use a Docker image to run the experiment so that software packages are properly installed. To use the docker image, first install docker. Then, in the terminal, do 

```bash
docker run -p 8888:8888 ziyiyin97/ccs-env:v4.4
```

Running this command will produce an output that looks like

```
    
    Copy/paste this URL into your browser when you connect for the first time,
    to login with a token:
           http://af637030c092:8888/?token=8f6c664eb945f9c6b7cd72669fef04a6dc70c08194cb87e9
        or http://127.0.0.1:8888/?token=8f6c664eb945f9c6b7cd72669fef04a6dc70c08194cb87e9
```

Copy paste the URL in your browser and replace `(af637030c092 or 127.0.0.1)` by `localhost`.
You will then be directed to a jupyter folder that contains the notebooks for the projects.

Then, we can create a new julia script and run the experiment in it. A couple of things before we go into the details:

### 1. Try to give your interpretation to every figure you plot. What is each event in the figure?      
### 2. Plotting is hard. When you make plots, make sure you use the correct labels and units so that images are in meters, data is in seconds. Also make sure you clip the image by `vmin` and `vmax` keywords in `imshow` function so that you see all the events in the image.      
### 3. To plot seismic data and images (e.g. RTM), we always put `vmin = -vmax` so that $0$ is at the center in your colorscale. Generally, we use `cmap="seismic"` to plot seismic data, `cmap="Greys"` to plot seismic images.

## Let's start!

First we load the packages as usual.

```julia
## First do using Pkg; Pkg.add(xxx) in case any package is not installed yet
using JUDI, PyPlot, Images, JOLI, IterativeSolvers, LinearAlgebra, Printf, Statistics
```

Here, we set up a $4$-layer model. The velocities in each layer are $1.5/2.5/3/3.5$ km/s. We often call the first layer as the water layer/column in marine acquisition and assume to know its depth.

```julia
# number of gridpoints
n = (201, 101)

# Grid spacing
d = (10f0, 10f0) # in [m]

# Origin
o = (0f0, 0f0) # in [m]

# Extent
extent = (o[1], o[1]+(n[1]-1)*d[1], o[2]+(n[2]-1)*d[2], o[2])   # in [m]

# Velocity [km/s]
v = ones(Float32,n) .+ 0.5f0
v[:,20:50] .= 2.5f0
v[:,51:71] .= 3f0
v[:,71:end] .= 3.5f0
```

Wave-equation simulations in JUDI are parameterized by squared slowness $\mathbf{m}$. For migration, we make up a background model $\mathbf{m}_0$ as a smoothed version of the ground truth one. To make things simple, we assume to use the exact water layer in the background model. The squared slowness perturbation $\delta\mathbf{m}$, as the difference of $\mathbf{m}$ and $\mathbf{m}_0$, only contains the sharp reflectors.

```julia
# Slowness squared [s^2/km^2]
m = (1f0 ./ v).^2
m0 = deepcopy(m)
m0[:,20:end] = convert(Array{Float32,2},imfilter(m[:,20:end], Kernel.gaussian(5)))  # smooth the true velocity to get m0
dm = vec(m - m0)

figure(figsize=(20,12));
subplot(1,3,1)
imshow(reshape(m,n)', extent=extent, interpolation="none", cmap="jet");title("m")
xlabel("X [m]"); ylabel("Z [m]");
subplot(1,3,2)
imshow(reshape(m0,n)', extent=extent, interpolation="none", cmap="jet");title("m0")
xlabel("X [m]"); ylabel("Z [m]");
subplot(1,3,3)
imshow(reshape(dm,n)', extent=extent, interpolation="none",cmap="Greys");title("dm")
xlabel("X [m]"); ylabel("Z [m]");
```

The goal of seismic imaging/migration is to acquire this $\delta\mathbf{m}$ from seismic data. To run a seismic imaging experiment on the aforementioned model, let's start by generating the seismic data.

```julia
model0 = Model(n, d, o, m0; nb = 80)
model = Model(n, d, o, m; nb = 80)
```

Here, $\mathbf{m}$ and $\mathbf{m}_0$ are stored in ``model`` structure in JUDI, with metadata (e.g. number of grid points, dimension, spacing etc). We then set up the source geometry and receiver geometry as below. Notice that the numerical simulations here are in 2D, so $y$-direction is always $0$.

```julia
nsrc = 8 # num of sources
xsrc = range(900f0, stop=1100f0, length=nsrc) # in [m]
ysrc = range(0f0, stop=0f0, length=nsrc) # in [m]
zsrc = range(6f0, stop=6f0, length=nsrc) # in [m]

timeS = 1000f0 # source injection time [ms]
dtS = 1f0 # time sampling [ms]
ntS = Int(timeS/dtS) + 1    # number of time samples

srcGeometry = Geometry(convertToCell(xsrc),convertToCell(ysrc),convertToCell(zsrc); dt=dtS, t=timeS)

nrec = 100 # num of receivers
xrec = range(d[1], stop=(n[1]-1)*d[1], length=nrec) # in [m]
yrec = 0f0  # in [m]
zrec = range(10f0, stop=10f0, length=nrec)  # in [m]

timeR = 1000f0 # recording time [ms]
dtR = 1f0 # time sampling [ms]
ntR = Int(timeR/dtR) + 1    # number of time samples

recGeometry = Geometry(xrec,yrec,zrec;dt=dtR,t=timeR, nsrc=nsrc)
```

Set up the source with Ricker wavelet

```julia
f0 = 0.015f0  # 15 Hz wavelet
wavelet = ricker_wavelet(timeS, dtS, f0)
q = judiVector(srcGeometry, wavelet)    # source
```

Set up computational time step

```julia
# Set up info structure for linear operators
ntComp = get_computational_nt(srcGeometry, recGeometry, model)
info = Info(prod(n), nsrc, ntComp)
```

Set up forward modeling operators in ground truth velocity, background velocity, and migration operator --- these are linear operators!!

```julia
F = judiModeling(info, model, srcGeometry, recGeometry; options=Options(isic=true)) # forward modeling w/ true model
F0 = judiModeling(info, model0, srcGeometry, recGeometry; options=Options(isic=true)) # forward modeling w/ background model
J = judiJacobian(F0,q) # demigration operator (adjoint of J is migration)
```

### *Task: please plot the sources/receivers overlaying on the true velocity model. Use `scatter` to plot scatter points in an image. Where are the sources and receivers?*

## Generate data

Generate data in ground truth velocity and background velocity

```julia
dobs = F*q
dobs0 = F0*q
```

### *Task: plot a single shot record of ``dobs`` and ``dobs0``. Choose the same source. What do you see in the shot record? If there are a couple of events, try to match them up with the corresponding reflectors.*

```julia
# hint: seismic data is as a judiVector
# you can access its value by, e.g.

figure(figsize=(20,12));imshow(dobs.data[1],extent=(1, nrec, (ntR-1)*dtR, 0f0), vmin=-0.02*norm(dobs.data[1],Inf),cmap="seismic",vmax=0.02*norm(dobs.data[1],Inf),aspect="auto")
xlabel("receiver no.");ylabel("[ms]");

# This plots the shot record in correct velocity generated by the 1st source
```

You can also generate a linearized shot record by

```julia
dlin = J*dm
```

### *Task: plot a shot record from ``dlin`` and ``dobs-dobs0``. What do you see? Why do you observe this theoretically (think about math)?*

## Reverse time migration (RTM)

From now on, we will only focusing on imaging the linearized data for simplicity. First, we can try reverse time migration by

```julia
rtm = J'*dlin
```

### *Task: compare RTM results w/ the correct squared slowness perturbation ``dm``, what do you see and what is your interpretation on the result?*

```julia
# hint: rtm is not a matrix, but a PhysicalParameters (a data structure). Do rtm.data to access the value. Again take care of vmin, vmax, aspect of plotting.
```

## Least-squares reverse time migration (LS-RTM)

Seismic imaging researchers are not always satisfied with RTM. Seismic imaging basically solves the optimization problem

$\min_{\mathbf{\delta m}} \|\mathbf{J}\mathbf{\delta m} - \mathbf{\delta d}\|_2^2$

where RTM is only taking a full gradient of the objective w.r.t. $\delta \mathbf{m}$. To get better images, we can minimize the objective by LSQR and apply a right preconditioner

```julia

# Right Preconditioner
Tm = judiTopmute(model0.n, 19, 2)  # Mute water column
S = judiDepthScaling(model0)
Mr = S*Tm

## vanilla LSQR

x1 = 0f0 .* model0.m

lsqr!(x1,J*Mr,dlin;maxiter=2,atol=0f0,verbose=true)
```

The final solution is given by ``Mr*x1`` (``Mr`` is a right preconditioner so we are actually solving $\min_{\mathbf{x}}\|\mathbf{J}\mathbf{M}_r\mathbf{x}- \mathbf{\delta d}\|_2^2$)

### *Task: compare LS-RTM result with the previous RTM result, what do you see?*

## Sparsity-promoting least-squares reverse time migration (SPLS-RTM)

The start-of-the-art imaging technique is to do LS-RTM while promoting sparsity of solution in Curvelet domain, see [Witte et al](https://slim.gatech.edu/content/compressive-least-squares-migration-fly-fourier-transforms). This can be achieved by linearized Bregman iterations, as shown below

```julia
# Soft thresholding functions and Curvelet transform
soft_thresholding(x::Array{Float64}, lambda) = sign.(x) .* max.(abs.(x) .- convert(Float64, lambda), 0.0)
soft_thresholding(x::Array{Float32}, lambda) = sign.(x) .* max.(abs.(x) .- convert(Float32, lambda), 0f0)

C = joCurvelet2D(n[1], n[2]; zero_finest = false, DDT = Float32, RDT = Float64)

src_list = Set(collect(1:nsrc))
batchsize = 2
lambda = 0f0

x2 = 0f0 .* model0.m
z = deepcopy(x2)

niter = 8

# Main loop
for j = 1:niter
    # Select batch and set up left-hand preconditioner
    length(src_list) < batchsize && (global src_list = Set(collect(1:nsrc)))
    i = [pop!(src_list) for b=1:batchsize]
    println("LS-RTM Iteration: $(j), imaging sources $(i)")

    residual = J[i]*Mr*x2-dlin[i]
    phi = 0.5 * norm(residual)^2
    g = Mr'*J[i]'*residual

    # Step size and update variable
    t = Float32.(2*phi/norm(g)^2)

    # Update variables and save snapshot
    global z -= t*g
    C_z = C*z
    (j==1) && (global lambda = quantile(abs.(C_z), .6))   # estimate thresholding parameter in 1st iteration
    global x2 = adjoint(C)*soft_thresholding(C_z, lambda)

    @printf("At iteration %d function value is %2.2e and step length is %2.2e \n", j, phi, t)
    @printf("Lambda is %2.2e \n", lambda)
end
```

The solution is given by ``Mr*x2``.

### *Task: try to explain what every line in the for-loop does, i.e. what is it calculating. You can also refer to Algorithm 2 in this [paper](https://slim.gatech.edu/Publications/Public/Journals/Geophysics/2019/witte2018cls/witte2018cls.pdf) for more details/explanations. If you have any question, let Francis know : )*

### *Task: Juxtapose 4 images: the true ``dm``, the RTM result, the LS-RTM result from LSQR, the sparsity-promoting LS-RTM from Linearized Bregman. What do you see? Remember, our goal is to get an image that is similar to the true ``dm``.*

### *Task: The seismic images (except for the true ``dm``) above are focusing mainly in the central region. Why? (Hint: check source/receiver locations) How can we get a full illumination of the image? Make experiments to verify.*

### *Task: change acquisition to be transmission -- e.g. put sources as a vertical line on the left, receivers on the right. Show what RTM image looks like. Describe your observations and try to interpret the result. Is it the same as you got from the reflection geometry?*