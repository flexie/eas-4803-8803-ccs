# Exercise 6: From processing to inversion II

Contents:

- Kronecker
- NMO-Stack-deconvolution
- Inverting the Radon transform

# Kronecker

Given a matrix X, we often want to apply operations along both dimensions. For example, if each column is a trace we can do a temporal fourier transform of each trace as follows


```julia
using JOLI, GenSPGL, PyPlot, FFTW, LinearAlgebra
```


```julia
# dummy matrix
n1 = 10
n2 = 5
X = joComplex.(randn(n1,n2))
# fft along first dimension
F1 = joDFT(n1; DDT=joComplex)
Y  = F1*X
```




    10×5 Array{Complex{Float64},2}:
       1.41557+0.0im        -1.60638+0.0im       …   0.430018+0.0im      
      0.672767+0.450352im  -0.938118+0.759956im       -0.1883-0.991497im 
      0.406392+0.205739im  -0.302384+0.247512im      0.631065-1.30804im  
     -0.618123-0.848047im  -0.121208+0.443261im     -0.646604-1.17498im  
     -0.787335-0.450483im  0.0533324-0.395285im     -0.760621+0.0204424im
      0.294818+0.0im       -0.429069+0.0im       …  -0.250248+0.0im      
     -0.787335+0.450483im  0.0533324+0.395285im     -0.760621-0.0204424im
     -0.618123+0.848047im  -0.121208-0.443261im     -0.646604+1.17498im  
      0.406392-0.205739im  -0.302384-0.247512im      0.631065+1.30804im  
      0.672767-0.450352im  -0.938118-0.759956im       -0.1883+0.991497im 



We can do an fft along the second dimension as follows


```julia
F2 = joDFT(n2; DDT=joComplex)
Y  = transpose(F2*copy(transpose(X)));
```

Finally, we can combine both in one step as follows


```julia
Y = transpose(F2*copy(transpose(F1*X)));
```

We can do the equivalent operation on the vectorized version of X via the Kronecker product. The formula is :
    
$ \mathrm{vec}(AXB) = (B^T\otimes A)\mathrm{vec}(X) $.

where $\mathrm{vec}$ vectorizes a matrix $X(:)$.

Use joKron to construct a 2D fft operator that works on a vectorized version of X, X(:).
Show that the result is the same as when using the operators F1 and F2 separately.


```julia
# 2D FFT operator
F12 = joKron(F2,F1);

# compare: F12*X(:) should be the same as Y(:)
norm(F12*X[:] - Y[:])

```




    0.0



# NMO-Stack-deconvolution
We revisit the NMO and stack operations we saw a few weeks before, but we will use it `backwards`. Remember the conventional flow was Data -> NMO corrected data -> stack -> image We will now traverse this chain in the reverse order, each time using the adjoint of the operations.

The reflectivity (image) can be represented by a convolution of a spike train with a wavelet, as we saw last week. We will build this chain of operations reflectivity -> convolved reflectivity -> NMO corrected data -> data, step-by-step.

First, define a time and offset axis.




```julia
# time and offset grid
t = Float64.(0:.004:1);  nt = length(t);
h =  Float64.(0.0:10.0:1000.0); nh = length(h);
```

We make a reflectivity series with 3 spikes and define a wavelet.




```julia
# reflectivity
r = zeros(nt,1);
r[51] = 1
r[101] = -.5
r[151] = .75

# wavelet
w = (1 .-2*1e3*(t .-.1).^2).*exp.(-1e3 .*(t .-.1).^2)
```




    251-element Array{Float64,1}:
     -0.0008625986654872107
     -0.0017333620023927386
     -0.003359640068423334 
     -0.00627815407118934  
     -0.011305429764281264 
     -0.019606375823452423 
     -0.032722754572662376 
     -0.05251269265727092  
     -0.08094144772594736  
     -0.11966839901351634  
     -0.16940707917321376  
     -0.22910148611303477  
     -0.29505929933463465  
      ⋮                    
     -8.75952886e-316      
     -9.2021e-319          
     -0.0                  
     -0.0                  
     -0.0                  
     -0.0                  
     -0.0                  
     -0.0                  
     -0.0                  
     -0.0                  
     -0.0                  
     -0.0                  



The convolution is done by using the FFT SPOT operators, just like in the last exercise.


```julia
# convolution operator
C = joDFT(nt)'*joDiag(fft(w))*joDFT(nt);
```

Next, we need to extend the the reflectivity to be a function of time and offset. We are trying to undo the stack operation to create NMO corrected data. Let's first look at the stack. Given a matrix, we can stack the columns by multiplying with a vector of all ones:


```julia
# test matrix
X =[1 2; 3 4; 5 6]
Y = X*[1;1]
```




    3-element Array{Int64,1}:
      3
      7
     11



- Construct a JOLI operator that stacks a vectorized input matrix of size nt x nh along the columns. Use joDirac to define an identity operator.
- Apply the operators C and S to the vector r to get something that resembles NMO-corrected data. You can reshape the vector into a matrix by using reshape. Plot the result.

The next step is to construct an NMO operator. Please follow the function `nmo` in [Exercise2](https://flexie.github.io/-EAS4803-8803/Assignments/Exercise6/) and define the operator for a constant velocity of 2000 m/s. Don't forget to take care of the shape of input and output (they should both be vectors in proper lengths). Apply it to the result of the previous exercise and plot the result.

Now, define a combined operator that predicts data given a spike train.

- Check that your combined operator satisfies the dottest
- Make data for the spike train r and add some noise.
- Invert the operator with both lsqr and spgl1 (see previous exercise).


# Inverting the Radon transform

In the previous exercise we saw that the Radon transform is not unitary. This means that its adjoint is not its inverse. Here, we will set up a JOLI operator for the Radon transform and invert it using lsqr and spgl1. If the computation takes too long you can use a coarser sampling of the q axis.

- read the data parab.segy
- Set up a parabolic radon transform JOLI operator , R=joRadon(....; DDT=joFloat)
- Plot the data in the Radon domain, and go back to the orininal data using the adjoint. Compare to the original data. - - What do you notice?
- You want to obtain data in the Radon domain b for which the predicted data in the t,h domain is close to the original data. How would you do this?.
- Setup a damped least-squares system and invert with lsqr. Try different damping parameters and explain what you see. Hint: us lsqr(..., damp=) for a damped least square.
- Use the original system and invert with spgl1(A,b,0,tolerance).
- Describe a possible application of this technique in seismic processing


Do not forget to turn your data into Float64
