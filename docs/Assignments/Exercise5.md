# Assignment 4: From processing to inversion I

# Contents
 - Linear systems
 - JOLI
 - Deconvolotion

## Linear systems
A matrix is represented in Julia as follows


```julia
A = [1 2;3 -1]
```




    2×2 Array{Int64,2}:
     1   2
     3  -1



The transpose of a matrix is obtained via

A'


```julia
A'
```




    2×2 LinearAlgebra.Adjoint{Int64,Array{Int64,2}}:
     1   3
     2  -1



In a similar manner, we can define a column vector as follows


```julia
x = [2; 2]
```




    2-element Array{Int64,1}:
     2
     2



 - Describe two ways to define a row vector.

Now, consider the matrices




```julia
A1 = [1/sqrt(2) 2/3 sqrt(2)/6;0 1/3 -2*sqrt(2)/3;-1/sqrt(2) 2/3 sqrt(2)/6];
A2 = [0 2 2;2 1 -3;1 0 -2];
A3 = [3 1;1 0;2 1];
A4 = [2 4 3; 1 3 1];
```

# Tasks

 - Look at A1'*A1, what kind of matrix is A1? What does this mean?
 - Look at A2*[1;2;3] and A2*[3;1;4], what can you say about the matrix A2?
 - What do you call a linear system defined by matrix A3?
 - What do you call a linear system defined by matrix A4?

If a matrix is invertible, we can explicitly find the inverse with inv

 - find a solution of A1*x = [6;-3;0], is there only one solution? Do you really need inv here?
 - find a solution of A2*x = [4;0;-1], is there only one solution? What characterizes the solution you found?
 - find a solution of A3*x = [5;2;5], is there only one solution? What characterizes the solution you found?
 - find a solution of A4*x = [10;5], is there only one solution? What characterizes the solution you found?


# JOLI

https://github.com/slimgroup/JOLI.jl

The JOLI toolbox gives a way to represent matrices implicitly. A nice example is the Fourier transform. In julia, the Fourier transform of a vector is given by fft(x). We can explicitly construct a matrix representing the Fourier transform as follows


```julia
using FFTW
# dimension
N  = 10
F1 = zeros(Complex{Float64}, N,N)
for k = 1:N
    # construct k-th unit vector
    ek = zeros(N,1)
    ek[k] = 1

    # make column of matrix
    F1[:, k]= fft(ek)
end

```

 - Look at the matrix, what do you notice?
 - Verify that it gives the same result as fft by trying on a vector

We can also define the FFT using JOLI:


```julia
using JOLI
```


```julia
F2  = joDFT(N)
```




```julia
varinfo(r"F1"), varinfo(r"F2")
```




    (| name |      size | summary                         |
    |:---- | ---------:|:------------------------------- |
    | F1   | 1.602 KiB | 10×10 Array{Complex{Float64},2} |
    , | name |      size | summary                                    |
    |:---- | ---------:|:------------------------------------------ |
    | F2   | 566 bytes | joLinearFunction{Float64,Complex{Float64}} |
    )



And this is only a small example! The reason why we want to have such operations behave like matrices is that we can use (some) standard algorithms that where written to work with matrices to work with large scale operations. As an example we use a Gaussian matrix:


```julia
N  = 10000;
# NxN Gaussian matrix
G1 = ones(N, N);
```


```julia
# NxN Gaussian JOLI operator (will represent a different matrix than G1 becuase it is gerenated randomly)
G2 = joOnes(N);
```


```julia
varinfo(r"G1"),varinfo(r"G2")
```




    (| name |        size | summary                      |
    |:---- | -----------:|:---------------------------- |
    | G1   | 762.939 MiB | 10000×10000 Array{Float64,2} |
    , | name |      size | summary                   |
    |:---- | ---------:|:------------------------- |
    | G2   | 246 bytes | joMatrix{Float64,Float64} |
    )



# Deconvolution
We some signal $f(t)$ which is a convolution of some unkown signal $g(t)$ and a known filter $w(t)$. Given $f$ and $w$ we would like to retreive $g$.

For the example we use:

 


```julia
# time axis
t = 0:.001:2';
N = length(t);

# true signal g has approx k spikes with random amplitudes
k = 20;
g = zeros(N);
g[rand(1:N, k)] = randn(k);

# filter
w = (1 .-2*1e3*(t .-.2).^2).*exp.(-1e3*(t .-.2).^2);

# plot
using PyPlot
figure();
plot(t,g);
xlabel("t [s]");ylabel("g(t)");

figure();
plot(t,w);
xlabel("t [s]");ylabel("w(t)");
```

    ┌ Info: Recompiling stale cache file /home/yzhang3198/.julia/compiled/v1.2/PyPlot/oatAj.ji for PyPlot [d330b81b-6aea-500a-939a-2ce795aea3ee]
    └ @ Base loading.jl:1240



![png](../img/E5_output_24_1.png)



![png](../img/E5_output_24_2.png)


First, we consider the `forward` problem of convolving a signal, using JOLI.

### Task: Perform the convolution using the usual julia commands fft, ifft and element-wise multiplication. Name your result f1. Hint: what is convolution in frequency domain?*.

We can also create a JOLI operator to do the same. We can construct an operator to do the multiplication with the filter using joDiag.

```julia
# JOLI operator to perform convolution.
C = joDFT(N)'*joDiag(wf)*joDFT(N);
f2 = C*g;

figure();
plot(t,f1)
plot(t,f2)
plot(t,g);
xlabel("t [s]");ylabel("f(t)");legend(["normal","JOLI", "g"]);
```

### Task
 - Compare the results of both.
 - Compare f to g, what do you notice?
 - Assuming that your convolution operator is called C: Do you think C has a null-space? If so, describe it. (Hint: look at the filter).

Now, construct the signal f using your JOLI operator and add some noise.

```julia
f = C*g + 1e-3*randn(N);
```

### Task
Use the adjoint of C as an approximation to the inverse, i.e. approximate the adjoint of C to the observation f. what does this correspond to and what does the reconstruction look like?

### Task
Follow the script below, use lsqr to invert for g. (you might need to increase the number of iterations.)
Look at the signal that is predicted by your reconstruction, do you see a difference with the true signal?

```julia
#import Pkg;
#Pkg.add("IterativeSolvers")
# true signal

using IterativeSolvers
gt = lsqr(C, f, damp=1e0)
```

lsqr will give us a solution that has a small two-norm and explains the data. Alternatively, we can use another solver that will give us a spiky solution and explains the data. This solver is spgl1. Try inversion via spgl1.

https://github.com/slimgroup/GenSPGL.jl

```julia
using GenSPGL
# Pkg.add(url="https://github.com/slimgroup/GenSPGL.jl")
using LinearAlgebra
# Solve
opts = spgOptions(optTol = 1e-10,
                  verbosity = 1)

#gtt, r, grads, info = spgl1(C, vec(f), tau = 0., sigma = norm(f - C*gt));
```

### Task
 - Is this solution closer to the true one?
 - Look at the predicted signal for this solution, do you see a difference with the true signal? Can we really say that this is a better solution? 

## 2D compressive sensing

In the following experiment, we extend the 1D compressive sensing to 2D---i.e., we aim to recover a sparse image (rather than a vector). Let's first set up the ground truth vector $g$.

```julia
n = (64, 64);
nn = prod(n);
k = 200;
g = zeros(n);
idx1 = rand(1:n[1], k);
idx2 = rand(1:n[1], k);
for i = 1:k
    g[idx1[i],idx2[i]] = randn();
end
```

### Task: plot $g$ by `imshow` function with colorbars. Is $g$ sparse? How many non-zero entries are in $g$?

Then, let's make a forward operator $A$ by JOLI. Following what we did in 1D, we hit the ground truth vector by the matrix $A$ and add some noise to get the observation $y$. Notice that the operator $A$ works on vectorized image.

```julia
using Random
subsamp = 0.25f0 # 25% subsampling ratio
A = joRestriction(nn, sort(randperm(nn)[1:Int(round(subsamp*nn))]))*joRomberg(n[1],n[2])
y = A * vec(g) + 1f-3*randn(size(A,1));
```

### Task: do LSQR and SPGL1. Plot the results. Compare with each other. What do you see?
### Task: compute the norm of the residuals from the results by LSQR and SPGL1. Which one is larger? Any conclusion from these experiments?