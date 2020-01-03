# Installation

The assignments require [Julia](https://julialang.org) and Python to be installed.

For Windows, I recommend to use docker as [Devito](https://www.devitoproject.org) does not support Windows.

## Julia
To install julia follow

https://julialang.org/downloads/

And install Julia 0.7 or earlier

DO NOT INSTALL JULIA 1.0

## Python

The recommended installation is via conda to have a stable environment.

https://conda.io/miniconda.html


## Packages


For devito:

```
git clone -b v3.2.0 https://github.com/opesci/devito.git
cd devito
conda env create -f environment.yml
source activate devito
pip install -e .
```

This will create your devito environment. Remeber to always call `source activate devito` at every new session.

For JUDI, start julia and run
```
Pkg.add("JUDI")
```

all the dependencies should install.

## Docker

First install docker for your system

https://www.docker.com/products/docker-desktop

Instead of having to install Python, Julia, Devito, JUDI and all the dependencies by yourself, you simply download the docker image and run it in a container. All you need to do is install docker and run:

```
docker run -p 8888:8888 philippwitte/judi:v1.0.0
```

This will download the image and launch a jupyter notebook that you can access from your internet browser. The command will display a link, which looks something like this:

```
Copy/paste this URL into your browser when you connect for the first time,
    to login with a token:
        http://0e27b13128d4:8888/?token=84a95cf4319e8e68534f20c7c6474d9875f13c70270f35f4&token=84a95cf4319e8e68534f20c7c6474d9875f13c70270f35f4
```

Copy-paste this link and replace the address `0e27b13128d4:8888` with `localhost:8888` (the link is created inside the docker container, which doesn't know that you mapped this port to your localhost w/ port no. 8888). Instead of a notebook, you can also launch an interactive session with a terminal by running:

```
docker run -it philippwitte/judi:v1.0.0 /bin/bash
```

This will give you access to a terminal, in which you can start Julia/Python, run things interactively or modify code.

## Exercises

During the course you will work on the following exercises

<!--
1. A first look at seismic data. [Intro to julia](Assignments/introduction_to_julia.md) [Exercise 1](Assignments/Exercise1.md) [[Solution]](https://www.slim.eos.ubc.ca/Teaching/EOSC454/exercise1_sol.html)

2. NMO correction and velocity analysis [Exercise 2](Assignments/Exercise2.md)

3. Wavefield extrapolation and migration. [Exercise 3](Assignments/Exercise3.md)

4. Fourier, Radon and filtering.[Exercise 4](Assignments/Exercise4.md)

5. From processing to inversion I.[Exercise 5](Assignments/Exercise5.md)

6. From processing to inversion II. [Exercise 6](Assignments/Exercise6.md)

7. Full Waveform inversion. [Exercise 7](Assignments/Exercise7.md)

These exercises will introduce you to the [Julia programming language](https://julialang.org), [Devito](https://www.devitoproject.org)-a Domain-specific Language (DSL) for automatic code generation for highly optimized finite differences, and [Judi](https://github.com/slimgroup/JUDI.jl)-a framework for large-scale seismic modeling and inversion and designed to enable rapid translations of algorithms to fast and efficient code that scales to industry-size problems.

-->

### Hand in

Please turn in your assignments as pdf files. The assignments should be send to [Felix J. Herrmann](mailto:felix.herrmann@gatech.edu). Late hand ins are not accepted.

Unless stated otherwise the labs are due one week after the lab.

### Feedback

We will give you feedback on the marking of the exercises.
