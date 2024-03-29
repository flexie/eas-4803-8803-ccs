# Class project
Instructions for the final project

You can find the course project folder on canvas files. In the folder, there are two notebooks - Monitor.ipynb and experiment_test.ipynb, which you will essentially work on for this project. Please download the zip file and follow the instructions below:
1) To run seismic imaging notebook, Monitor.ipynb, you need to run docker v2.0 which runs Julia. This notebook requires you to create 10 leakage and 10 no-leakage seismic test images which you will need to feed to neural classifier notebook below.

2) To run neural network classifier notebook experiment_test.ipynb, you don't need the docker (so you can close it) but a python environment. To get the python environment, you need to run environment.yml file. As always, put everything in a folder. Go to the terminal, provide the path of the GCS-CAM folder and do
````
> conda env create -f environment.yml
> source activate gcs-cam
> python -m ipykernel install --user --name gcs-cam --display-name "Python (gcs-cam)"
> cd ..
> jupyter notebook
````
3) Now open the second notebook and choose gcs-cam environment as the kernel. This can be done by clicking on the Kernel menu and then click on change kernel option and choose gcs-cam.

The questions and other instructions are provided in the notebook but feel free to let us know if you have any additional questions. Good luck!
(Due: April 25, 2023 (Tue), 3:30 PM)

<!--
Towards the end of the term, the students will be asked to conduct a small 2D numerical experiment that is representative of a typical geological carbon storage project. To avoid the tedious installation process, we suggest you run the experiments within a docker image (ziyiyin97/ccs-env:v4.6). As part of this project, the students will run numerical simulations to model the injection of CO~2~ in the Compass model, a proxy Earth model representative for an area in the North Sea that is considered as a potential site for geological carbon storage. During this project, students will convert the simulated time-varying CO~2~ saturations to time-varying velocity models of the Earth based on rock physics modeling. These models will be used to simulate synthetic time-lapse seismic data. This simulated data will be used to test our seismic monitoring methodology. This project is an extension to [Exercise 7](Assignments/Exercise7.md). Please follow the instructions there.

### Known Windows issues solutions

**If you get an error message about Windows version**

You probably either have Windows Home edition or a version older than Windows 10.
Download this version of [Docker](https://github.com/docker/toolbox/releases/download/v19.03.1/DockerToolbox-19.03.1.exe) and install it.


**Accessing the notebook**

IP forward with docker on Wondows does not work and the address `http://127.0.0.1:8888/...` will probably not be reachable. To reach it run the following command in the docker terminal:

```
docker-machine ip
```

Tis will give you the IP address of your docker that you can now use for accessing the notebook by replacing `127.0.0.1` in the address above by the output of the `docker-machine` command.

**Token page**

If you are redirected to a page that ask you to input the token or to set a password, you probably have another docker container running. Run the command `docker container ls` to check if there is any container running. This should look like:

![png](./img/doc-cont.png)

You can see in the `PORTS` column that a container is already using the port 8888. Delete all container using that port via `docker container rm -f CONTAINER ID` and restart the docker image:

```
docker run -p 8888:8888 -v /path/to/files:/app/judi/data ddjj1118/judi_eas_project:v4.0
```

You should now be able to access the notebooks at `http://machine-ip:8888/...`

<!--
## Data and scripts

The data required please download from the following link with exactly same passwords as before

https://www.dropbox.com/s/4vvmxju4bsfrwrm/GulfOfSuez178.segy?dl=0

The projects are wrapped up in a docker image so that all the required dependencies are already installed. You will need to have docker installed. Once done run the following command:

```
docker run -p 8888:8888 -v /path/to/files:/app/judi/data ddjj1118/judi_eas_project:v4.0
```

where `/path/to/files` is the absolute location of the project data on your own machine. Running this command will produce an output that looks like

```
    
    Copy/paste this URL into your browser when you connect for the first time,
    to login with a token:
           http://af637030c092:8888/?token=8f6c664eb945f9c6b7cd72669fef04a6dc70c08194cb87e9
        or http://127.0.0.1:8888/?token=8f6c664eb945f9c6b7cd72669fef04a6dc70c08194cb87e9
```

Copy paste the URL in your browser and replace `(af637030c092 or 127.0.0.1)` by `localhost`.
You will then be directed to a jupyter folder that contains the notebooks for the projects.


### Known Windows issues solutions

**If you get an error message about Windows version**

You probably either have Windows Home edition or a version older than Windows 10.
Download this version of [Docker](https://github.com/docker/toolbox/releases/download/v19.03.1/DockerToolbox-19.03.1.exe) and install it.


**Accessing the notebook**

IP forward with docker on Wondows does not work and the address `http://127.0.0.1:8888/...` will probably not be reachable. To reach it run the following command in the docker terminal:

```
docker-machine ip
```

Tis will give you the IP address of your docker that you can now use for accessing the notebook by replacing `127.0.0.1` in the address above by the output of the `docker-machine` command.

**Token page**

If you are redirected to a page that ask you to input the token or to set a password, you probably have another docker container running. Run the command `docker container ls` to check if there is any container running. This should look like:

![png](./img/doc-cont.png)

You can see in the `PORTS` column that a container is already using the port 8888. Delete all container using that port via `docker container rm -f CONTAINER ID` and restart the docker image:

```
docker run -p 8888:8888 -v /path/to/files:/app/judi/data ddjj1118/judi_eas_project:v4.0
```

You should now be able to access the notebooks at `http://machine-ip:8888/...`



## Projects

As part of Lab 8, we are asking the students to work on a project in four groups. The projects are on the use of compressive sensing in seismic data acquisition and processing, and we are asking the students to make a comparison between different interpolation and acquisition techniques, namely

- missing trace interpolation via sparsity promoting techniques

- missing trace interpolation via rank minimization techniques

- acquisition with simultaneous randomly amplitude weighted sources or phase encoded sources for 'land’

Details on these different acquisition schemes will be discussed in class and during Lab 8. The goal of the project is to extend the 2D examples on common-receiver gathers to processing of a complete seismic line (for many receivers). This leads to a large problem with an unknown vector for which we need to invert with about 1 billion variables. As you do not have access to necessary resources you will need to solve the problem for each shot record or frequency slice independently and put the results back together afterward.

Scientifically, the acquisition and interpolation projects will focus on

- defining and testing the sampling matrix that models seismic acquisition. Kronecker products will be used to extend the 2D implementations of the sampling operators for common-receiver gathers to seismic lines that can be represented as a 3D volume. Plots have to be made of the sampling artifacts in the source-receiver-time domain and in the midpoint-offset-time domain. Also a study should be made of the size of the artifacts in relation to the degree of subsampling. We also would like to see plots of rows of the sampling matrix.

- selection of the appropriate sparsifying transform using curvelets and our Kronecker product. We would like to see a plot of a couple of columns of the synthesis matrix.

- in case of rank minimization techniques, selecting an appropriate rank plays a crucial role. Extract low and high frequency slices from a given seismic line. Look into the decay of singular values in each case and select rank accordingly.

- recovery of the fully-sampled sequential shot data by sparse inversion or matrix completion using SPGl1. The quality of the recovery should be measured via the signal-to-noise ratio ${SNR}=-20log_{10}(\frac{|{f}-\hat{{f}}|_2}{|{f}|_2})$ with f the original data and $\hat{{f}}$ the recovered data. Plots should also be made of the convergence as a function of the number of iterations. We also would like to see a plot of the residue as a function of the one-norm (sparsity case) or nuclear norm (matrix completion case) of the solution. In case of rank minimization, for a fixed sub-sampling ratio, plot SNR as a function of rank.

Each group is asked to give a short seminar on their project in class for 20 minutes with 15 to 17 minutes for the presentation itself and the remaining time for questions. The students are asked to divide the topics of the seminar into two or three parts presented by two or three different students in the team. During the question period each of the students will be asked to answer questions. The seminar will be graded using the following seminar evaluation form.

Please refer to the main page of the course for the date of the projection presentation in class.

Papers that are relevant for the projects are:

	Gilles Hennenfent and Felix J. Herrmann. Simply denoise: wavefield reconstruction via jittered undersampling, Geophysics, vol. 73, p. V19-V28, 2008. In the paper, the authors explain how to use jitter sampling to optimize the recovery from random missing shots.

	Felix J. Herrmann Yogi Erlangga and Tim T. Y. Lin. Compressive simultaneous full-waveform simulation. Geophysics, vol. 74, p. A35, (2009). In this paper, the authors apply compressive sensing to speedup wavefield simulations by using randomly weighted simultaneous sources.

	Felix J. Herrmann. Randomized sampling and sparsity: getting more information from fewer samples. Geophysics 75, WB173 (2010); doi:10.1190/1.350614. In this paper, the basics of compressive sensing are explained for a geophysics audience followed by discussion of different sampling schemes. You can skip the case studies.

	Felix J. Herrmann, Michael P. Friedlander, Ozgur Yilmaz. Fighting the curse of dimensionality: compressive sensing in exploration seismology. In this paper, the authors give an overview of the application of compressive sensing to exploration seismology.

	Haneet Wason and Felix J. Herrmann. Only dither: efficient simultaneous marine acquisition. EAGE expanded abstract. 2012. In this expanded abstract, the authors describe the application of compressive sensing to simultaneous marine acquisition.

	Haneet Wason, Felix J. Herrmann. Time-jittered ocean bottom seismic acquisition. SEG expanded abstract. 2013. In this abstract, the author describe the application of time-jittered marine acquisition scheme.

	Aleksandr Y. Aravkin, Rajiv Kumar, Hassan Mansour, Ben Recht, Felix J. Herrmann. A robust SVD-free approach to matrix completion, with applications to interpolation of large scale data. arXiv submission. In this paper, the author explain how to use rank-minimization techniques to recover random missing shots.

	Rajiv Kumar, Aleksandr Y. Aravkin, Ernie Esser, Hassan Mansour and Felix J. Herrmann. SVD-free low-rank matrix factorization : wavefield reconstruction via jittered subsampling and reciprocity. EAGE expanded abstract. 2014. In this expanded abstract, author explain the use of jittered sampling to optimize rank minimization based missing trace interpolation techniques. -->