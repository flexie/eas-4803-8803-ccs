

<!-- # Installation

The assignments require [Julia](https://julialang.org) and Python 3 to be installed (Python 2 will not work).

For Windows, I recommend to use docker as [Devito](https://www.devitoproject.org) does not support Windows.

## Julia

To install julia follow

[https://julialang.org/downloads/](https://julialang.org/downloads/)

And install Julia 1.5

## Python

The recommended installation is via conda to have a stable environment.

[https://conda.io/miniconda.html](https://conda.io/miniconda.html)


## Packages

For the assignments, you will need a few python and julia packages. Please follow these instructions to install all of the packages in the order described here.

First, install Devito using `pip` (or `pip3`), or see the [Devito's GitHub page](https://github.com/devitocodes/devito) for installation with Conda and further information. The current release of [JUDI](https://github.com/slimgroup/JUDI.jl) requires Python 3 and the current Devito version. Run all of the following commands from the (bash) terminal command line (not in the Julia REPL):

```bash
pip install --user git+https://github.com/devitocodes/devito.git
```

Then install matplotlib by

```bash
pip install matplotlib
```

If these commands don't work, please replace `pip` by `pip3` and try it again.

For reading and writing seismic SEG-Y data, JUDI uses the [SegyIO](https://github.com/slimgroup/SegyIO.jl) package and matrix-free linear operators are based the [Julia Operator LIbrary](https://github.com/slimgroup/JOLI.jl/tree/master/src) (JOLI), we can install these 2 packages via:

```bash
julia -e 'using Pkg; Pkg.add(url="https://github.com/slimgroup/SegyIO.jl.git")'
julia -e 'using Pkg; Pkg.add(url="https://github.com/slimgroup/JOLI.jl.git")'
```

Once Devito, SegyIO and JOLI are installed, you can install [JUDI](https://github.com/slimgroup/JUDI.jl) with Julia's `Pkg.add`.

```bash
julia -e 'using Pkg; Pkg.add(url="https://github.com/slimgroup/JUDI.jl")'
```

Once you have JUDI installed, you need to point Julia's PyCall package to the Python version for which we previously installed Devito. To do this, copy-paste the following commands into the (bash) terminal:

```bash
export PYTHON=$(which python)
julia -e 'using Pkg; Pkg.build("PyCall")'
```

Again, try `which python3` if `which python` does not work.

You can verify your installation by running:

```bash
julia -e 'using Pkg; using JUDI; example=joinpath(dirname(pathof(JUDI)),"..","examples/scripts/modeling_basic_2D.jl");include(example);'
```

This command should finish without errors.

-->

# Homework

In this course, we will have a couple of coding assignments based on [Julia](https://julialang.org/downloads/), a fast, dynamic, reproducible composable and general open source programming language. You are encouraged to install [Julia](https://julialang.org/downloads/) on your system following the script to run some basic coding experiments to explore its usage and applications in scientific computing community.

In particular, you will run numerical experiments for CO$_2$ dynamics simulation and also seismic wave-based simulations with academically developed softwares. To help you run these software, we highly recommend you use Docker, a platform which builds a virtual machine/container for you with the docker image, which is set-up by us and equipped with pre-installed softwares. The docker image is quite necessary for you to run the software without the tedious installation process, and to provide you with an environment on which the software runs out of the box.

## Docker

First install docker for your system following the instruction here,

[https://www.docker.com/products/docker-desktop](https://www.docker.com/products/docker-desktop)

Instead of having to install Python, Julia, Devito, JUDI, FwiFlow and all the dependencies (these are the softwares that you will use for the numerical simulation) by yourself, you simply download the docker image and run it in a container. All you need to do is install docker, click the docker icon/app, open the terminal/command line ([powershell](https://www.howtogeek.com/662611/9-ways-to-open-powershell-in-windows-10/) in windows, also see [this](https://docs.microsoft.com/en-us/powershell/scripting/overview?view=powershell-7.2)) on your system, and run:

```
docker run -p 8888:8888 ziyiyin97/ccs-env:v4.2 
```

This will download the image and launch a jupyter notebook that you can access from your internet browser. The command will display a link, which looks something like this:

```
Copy/paste this URL into your browser when you connect for the first time,
    to login with a token:
        http://0e27b13128d4:8888/?token=84a95cf4319e8e68534f20c7c6474d9875f13c70270f35f4&token=84a95cf4319e8e68534f20c7c6474d9875f13c70270f35f4
```

Copy-paste this link and replace the address `0e27b13128d4:8888` with `localhost:8888` (the link is created inside the docker container, which doesn't know that you mapped this port to your localhost w/ port no. 8888). Then, you can create a notebook there by clicking new -> notebook -> julia 1.7.1, and run the julia code in the jupyter notebook. Remember, the jupyter notebooks on the docker container don't stay there forever. Therefore, if you are half way on the homework and want to close the jupyter notebook, please remember to save the notebook to your local machine. If you do not want to save the notebook every time when you close the notebook, you can actually connect a folder on your machine to the docker container by

```
docker run -v /path/on/your/machine:/notebooks -p 8888:8888 ziyiyin97/ccs-env:v4.2 
```

where `/path/on/your/machine` is an absolute path on your own local machine. For example, if I want to connect the folder called `testdocker` on the desktop of my laptop, I can do

```
docker run -v /Users/francisyin/Desktop/testdocker:/notebooks -p 8888:8888 ziyiyin97/ccs-env:v4.2 
```

and then you will find the files in this folder will show up in the notebooks. Whatever you do on the docker container will also be saved in the local `testdocker` folder.

Instead of a notebook, you can also launch an interactive session with a terminal by running:

```
docker run -it ziyiyin97/ccs-env:v4.2 /bin/bash
```

This will give you access to a terminal, in which you can start Julia/Python, run a couple of lines of code interactively. However, figures from PyPlot (the plotting package) sometimes do not render well from interactive julia sessions. Therefore, jupyter notebooks on docker are recommended for you to do the assignments.

### Window Users

If you are using windows, you might need to enable hardware virtualization in their BIOS. You are suggested to look at [here](https://www.virtualmetric.com/blog/how-to-enable-hardware-virtualization) and [here](https://bce.berkeley.edu/enabling-virtualization-in-your-pc-bios.html). If you have any question, please reach out to us ASAP.


## Some Useful Material

Learn command line from [Software Carpentry](https://software-carpentry.org/)    
Learn [jupyter notebook](https://jupyter.org/)    
Learn [Julia](https://julialang.org/learning/)    

## In-class Exercise

During the lectures you will work on the following exercises

1. Thickness of reservoir. [Exercise 1](exercise/exercise1.md) (Jan 20, 2022)

1. Capacity coefficient. [Exercise 2](exercise/exercise2.md) (Jan 27, 2022)

## Homework Assignments

During the course you will work on the following homework assignments

1. Intro to rock physics. [Assignment 1](Assignments/homework1.md). Submit your homework as a PDF report. (Due: 3:30 PM Jan 25, 2022)

2. Fluid flow simulation. [Intro to julia](Assignments/introduction_to_julia.md) and [Assignment 2](Assignments/Homework2.md). Submit both jupyter notebook and a PDF file. (Due: 3:30 PM Feb 10, 2022)

3. Wavefield extrapolation and migration. [Assignment 3](Assignments/Exercise3.md) (Due: 3:30 PM March 29, 2022)

<!--
4. Seismic imaging with sparsity-promoting least-squares migration. [Assignment 4](Assignments/Exercise7.md) (Due: 3:30 PM April 4, 2022)

1. A first look at seismic data. [Intro to julia](Assignments/introduction_to_julia.md) [Exercise 1](Assignments/Exercise1.md) [[Solution]](https://www.slim.eos.ubc.ca/Teaching/EOSC454/exercise1_sol.html)

2. NMO correction and velocity analysis [Exercise 2](Assignments/Exercise2.md)

3. Wavefield extrapolation and migration. [Exercise 3](Assignments/Exercise3.md)

4. Fourier, Radon and filtering.[Exercise 4](Assignments/Exercise4.md)

5. From processing to inversion I.[Exercise 5](Assignments/Exercise5.md)

6. From processing to inversion II. [Exercise 6](Assignments/Exercise6.md)

7. Full Waveform inversion. [Exercise 7](Assignments/Exercise7.md)

These exercises will introduce you to the [Julia programming language](https://julialang.org), [Devito](https://www.devitoproject.org)-a Domain-specific Language (DSL) for automatic code generation for highly optimized finite differences, and [Judi](https://github.com/slimgroup/JUDI.jl)-a framework for large-scale seismic modeling and inversion and designed to enable rapid translations of algorithms to fast and efficient code that scales to industry-size problems.

-->

## Hand in

Please turn in your assignments as pdf files. The assignments should be send to [Ziyi (Francis) Yin](mailto:ziyi.yin@gatech.edu). Late hand-ins are not accepted. If you have difficulty on the homework and want to ask for extension, please email Dr. Felix Herrmann and cc TA in advance (at least 2 days before the deadline).

## Feedback

We will give you feedback on the marking of the exercises.
