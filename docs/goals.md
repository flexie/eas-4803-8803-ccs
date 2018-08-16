# General introduction

### Basic seismic data processing

- Give a description of a surface-seismic experiment
- Describe the basic steps of the post-stack seismic data flow and why they are important
- Explain why we need seismic exploration
- Name seismic transducers and setup for land and marine acquition
- Describe different seismic gathers
- What are the assumptions underlying NMO
- What is the role of the “fold” of the acquisition and why is it important
- Describe the mathematical relation between midpoint/offset and source-receiver coordinates
- Why is the sampling rate different for common-shot and common midpoint gathers
- Describe the principle of velocity estimation with NMO
- What does migration try to accomplish
- Give a geometric description of the process of zero-offset migration.
- Describe the different terms in the Rayleigh II integral 
- Decribe the extrapolation “work flow”
- Flowshart for shot extrapolation in the f-k domain
- What is the expression for the wavefield extrapolation operator in the ``f-k`` domain. 
- What change do you need to make to do inverse extrapolation
- Describe in pictures forward wavefield extrapolation for a shot record with two events
- Describe recursive inverse wavefield extrapolation of a shot record with a single reflection event by a number of plots
- What is the main assumption on the behavior of the velocity in f-k based recursive extrapolation and what happens to the extrapolation operator compared to the lateral invariant case
- Name the five steps of prestack migration
- What are the underlying assumptions regarding the use of a particular migration scheme in relation to the complexity of the subsurface.
- Draw a schematic of the “impulse” response of the migration operator and the linearized scattering operator.
- Describe the different steps of pre-stack shot migration
- What is the difference between pre- and post-stack migration?
- What is the effect of summing the images of the different shot gathers
- In what situation is pre-stack time migration a viable option and when not
- What migration scheme would you use in case of complex velocities and complex structure

### Wavefield extrapolation, pre-stack migration, and velocity analysis

- Wavefield extrapolation via Rayleigh II
- Wavefield extrapolation via the f-k domain
- $V(z)$ migration
- Shot record migration
- Recursive extrapolation in varying media
- Pre-stack shot migration
- One-way wave-equation migration
- Reverse-time migration
- Velocity-model estimation
   - Traveltime tomography
   - migration-velocity analysis
- What are the two prevailing methods to estimate the velocity model and what information do they need
- Describe the main principles of travel-time tomography
- Describe the main principles of migration velocity analyses
- What are the differences between these two methods of velocity model estimation

### Filtering

- Describe the principle and assumptions behind f-k filtering
- Write down the Radon transform in the physical and Fourier domain
- Describe Radon filtering sequence of operations to remove multiples
- Describe what the process of seismic deconvolution tries to accomplish

***


# Seismic data acquisition

- Give the Nyquist sampling critrion for the sampling of spatio-temporal wavefields
- Describe aliasing in 1-D and 2- D (``f-k`` domain).
- What is an airgun
- What is the ghost?
- What is the effect of the ghost on the amplitude spectrum?
- Describe azimuth and name at least three disadvantages of near azimuth acquisition.
- What does a rose diagram plot?
- Mention two different configurations to improve azimuthal coverage. Include sketches of the arrays and sources.
- Describe rich azimuth acquisition and include drawing.
- What is the main driver behind WAZ acquisition?
- Name at least four improvemens related to wide-azimuth acquisition?
- What is fold and why is it important?
- What are the main challenges in marine acquisition?
- What are the challenges of 3D acquisition?
- Name some recent developments.
- Describe coil sampling
- Give the main reasons why large offsets are required?

***

# From processing to inversion

- Describe what the forward and inverse models signify.
- What property do unitaty matrices have?
- What type of solution method should be used when the data synthetic data does not fit observed data exactly?
- Describe how one arrives at the least-squares solution ``m_{LS}=(A^TA)^{-1})A^Td``?
- In what situation, is the least-squares solution used? Is the matrix to be inverted tall, square, or fat?
- Describe the minmum norm solution and when is its use appropriate?
- Describe in words what the expression ``min_x|x|_2 subject to Ax=b`` expresses.
- Explain the difference between processing (applying the adjoint) and inversion
- How are convolution and correlation related related to linear operations
- Describe the 'dot test’ and what does it accomplish
- Mention and describe at least three forward-adjoint pairs relevant to exploration seismology
- Write stacking, zero padding, and sampling as a matrix
- Proof that matrices that represent convolution and correlation are adjoints.
- What kind of matrix is the convolution in the Fourier domain.
- Sketch a column of the Parabolic Radon 'reverse’ transform (``L^H``).
- Explain why it is important to 'invert the 'reverse’ Radon transform’ for multiple removal?
- What is the underlying assumption of minimizing the energy (``\ell_2``-norm) on the model parameters?
- What does high-resolution try to accomplish and what is the underlying assumption on the model and the data?

*** 

# Compressive sensing

- How is sampling related to a linear system.
- When is the linear system underdetermined.
- How do the concepts of over- and underdetermined systems relate to sampling?
- Give the key ideas of Compressive Sensing.
- Give two examples of transforms that exploit the signal's structure by sparsity.
- Which interferences/artifacts are worse. Coherent aliases due to periodic sampling or incoherent noise due to randomized samping and why?
- Give at least two examples of randomized sampling and describe the impact on the sampling artifacts compared to conventional deterministic acquisition.
- Give an example of measurement (M) and sampling (R) matrices with low and hight coherence
- Which of the following acquisition scenarios creates favorable recovery conditions?
- Explain the role of sparsifying transforms and sparsity-promoting recovery.
- Describe what happens with the recovery SNR as (i) the subsampling ratio decreases, (ii) the sparsity-level increases, (iii) the noiselevel increases, and (iv) the decay rate of the sorted transform-domain coefficients increases.
- List a number of pitfalls/challenges related to applying compressive sensing to seismic acquisition in the field.

***

# Linearized inversion 

- Describe three factors that influence the amplitudes of seismic waves
- Describe when the linearized refflection coefficients is a good approximation
- Give two different expressions for the linearized reflection coefficient in the acoustic case
- Mention “non-ray” amplitude effects
- Describe linearized inversion. What are the two key factors expressing the relationship between the amplitudes of the reflection events and the acoustic medium properties. Introduce the corresponding matrices.
- What are the boundary conditions for the elastic wave equation at an interface?
- Describe the different reflection and transmission coefficients for the elastic case.
- Describe the linear convolutional model for the seismic reflection response. What are the underlying assupmtions of this model?
- What does the background velocity model describe and what properties should it have?
- List the different reflection and transmission coefficients for an interface between two elastic layers. What are these coefficients a function of and w.r.t. to which medium properties can these expressions be linearized? For non-zero and pre-critical angles, what are the orders in deltall 1 for these different reflection and transmission coefficients?
- Describe the “work flow” of AVP inversion.
- Describe how the amplitudes of the plane-wave decomposition (via the linear Radon transform) are related to contrasts in the density, compressional, and shear wavespeeds.
- Describe the damped least-squares procedure to estimate the medium perturbations/contrasts. Is the system under or over determined? Why is damping needed?
- Describe issues with the spectral gap.

***

# RTM & FWI

- Describe in words what the adjoint state method corresponds to physically
- What is the geophysical interpretation of the gradient?
- Describe the equations for the computation of the gradient. What is their physical meaning?
- Draw the impulse response of a the linear Born scattering operator and its adjoint for a constant velocity model.
- What is the relationship between least-squares migration and Gauss-Newton?
- How is the action of the Jacobian evaluated? How many PDE solves does it take?
- List at least two difference between linearized inversion (least-squares migration and full-waveform inversion).
- Describe for what purpose full-waveform inversion is used in the context of migration and why.
- Describe a method to make imaging and inversion more efficient
- Describe a cross-well experiment
- Describe a surface-seismic experiment
- How does the sensitivity of these two methods compare?
- What sort of waves does full-waveform inversion rely on and why.
- List at least two requirements of full-waveform inversion on the acquisition.
- What does non-uniquness in full-waveform inversion refer to?
- List at least one strategy people use to avoid getting stuck in a local minimum? What does this imply w.r.t. the wavelength and the propagation distance.
