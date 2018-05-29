# F4D
Fluka for Docker

V. Boccone, A. Fontana, D. Horvath

# Installing Docker 
You can install Docker in the host OS by following the instructions 
on the Docker website: these are available for the most common Linux 
flavours, Windows 10 (Home and Professional Editions) and MacOS.

### OS X, Linux, Windows 10 Pro, Enterprise, and Education

Install Docker Community Edition:
https://www.docker.com/community-edition

### Windows 10 Home (and possibly older Windows versions)

Install Docker Toolbox: https://www.docker.com/products/docker-toolbox

Windows 10 Home does not enable hyper-V, which is required for Docker Community Edition. 
Docker Toolbox provides a workaround. This is not optimal for performance, but it allows 
to run FLUKA also on Windows 10 Home.

## Post installation steps for both Windows 10 versions

- Allow Docker through the firewall
- Start Xming (http://www.straightrunning.com/XmingNotes/) without access control

### Additional info for Linux
Once docker is installed you need to add your user to the docker group.   
```
sudo usermod -aG docker $USER
```

In this way, all docker commands can be issued as $USER.

# Generating your personal docker image with Fluka
The scripts for the generation of a basic Fluka-compatible image are open source.

### Download
You can download the latest version of the scripts from the github repository:   
[https://github.com/flukadocker/F4D/archive/master.zip](https://github.com/flukadocker/F4D/archive/master.zip)

### Checkout
You can alternatively checkout the full repository with the scripts from the github repository:   
```
git clone https://github.com/flukadocker/F4D.git
```
In both cases the download directory is your choice.

### Building the image

### OS X, Linux

You can generate your personal Fluka image by running in a terminal the ```install_linux.sh``` script in the root of the repository.
Note: in order to generate you personal Fluka image you need to provide an active fuid and password).
The installation might require a bit of time - from 1 to 10 minutes - depending on the speed of your internet connection.

### Windows 10 Pro, Enterprise, and Education

Execute in a Windows prompt terminal or by double-clicking on it the scripr```install_win.bat```
This script will prompt for your FLUKA credentials (fuid-xxxx and password), download the latest public FLUKA release and 
install it in a Fedora 27 based Docker container.

### Windows 10 Home (and possibly older Windows versions)

Start as Administrator a Docker Quickstart Terminal and close it when it is ready: this activates Docker in Windows 10 
Home Edition.

Create the directory C:\Users\docker (mandatory!) and execute ```install_win.bat```
This script will prompt for your FLUKA credentials (fuid-xxxx and password), download the latest public FLUKA release 
and install it in a Fedora 27 based Docker container.

The typical output of these steps in all systems is as follows:
```

```

During this phase the script will:
- download Fluka from [fluka.org](http://fluka.org) using your *fuid* and *password*;
- download the necessary base image from the docker hub to the local docker image repository;
- perform the necessary Fluka installation steps;
- create a *flukauser* default user in the image.


## Your first Fluka container 

### Creating a container

### OS X Linux
It is possible to get a shell terminal to container and to pass trough the X11 connection along with some local folder. 

Execute from a terminal ```./run_fluka_container.sh```: this script will start the Docker container with FLUKA and FLAIR installed.

### Windows 10 Pro, Enterprise, and Education

Change directory to where you have installed the Docker scripts (e.g. C:\Docker) and execute from a powershell prompt ```.\run_fluka_container_on_windows10.ps1```: this script will start the Docker container with FLUKA and FLAIR installed.

### Windows 10 Home (and possibly older Windows versions)

Start as Administrator a Docker Quickstart Terminal and execute from the directory /c/Users/docker
```./run_fluka_container_on_windows10_home.sh```: this script will start the Docker container with FLUKA and FLAIR installed and ready to be used.

Some info about the Docker options used in these scripts:
- the ```-i``` and ```-t``` options are required to get an interactive shell;
- the ```-v $(pwd):/shared_path``` option create a shared pass through folder between the real system *pwd* and the folder ```/shared_folder``` in the container; 
- the ```$(pwd)``` could be substituted by your home folder, or whatever folder you want to share with the container;
- the ```--rm``` option will destroy the contained upon exit. All the local modification ();
- the ```--name fluka``` will assing the name fluka to the running container.
Each container instance is identified by an unique CONTAINER ID code and an unique name. 
If no name is specified during the container creation docker will generate a random name;
- the ```--net=host --env="DISPLAY" --volume="$HOME/.Xauthority:/root/.Xauthority:rw"``` are for X11 forwarding.

Note: Depending on your Xserver configuration you might need to run:
```
xhost + 
```
to enable the running the X11 forwarding.

### Using the container
Once in the docker container shell you could use the shell as if you would on a normal linux system.
You can try, for example, to run Fluka by:
```
[flukauser@linuxkit-025000000001 ~]$ mkdir test
[flukauser@linuxkit-025000000001 ~]$ cd test
[flukauser@linuxkit-025000000001 test]$ cp -r /opt/fluka/example.inp .
[flukauser@linuxkit-025000000001 test]$ $FLUPRO/flutil/rfluka -N0 -M1 example
$TARGET_MACHINE = Linux
$FLUPRO = /opt/fluka

Initial seed copied from /opt/fluka
Running fluka in /home/flukauser/test/fluka_25

======================= Running FLUKA for cycle # 1 =======================

Removing links
Removing temporary files
Saving output and random number seed
Saving additional files generated
     Moving fort.47 to /home/flukauser/test/example001_fort.47
     Moving fort.48 to /home/flukauser/test/example001_fort.48
     Moving fort.49 to /home/flukauser/test/example001_fort.49
     Moving fort.50 to /home/flukauser/test/example001_fort.50
     Moving fort.51 to /home/flukauser/test/example001_fort.51
End of FLUKA run
```

or also running Flair.

### Working with containers
Working with containers might not be so easy if are not used to the Command Line Interface in Linux. [Digital Ocean provides a nice primer [link here]](https://www.digitalocean.com/community/tutorials/working-with-docker-containers) 

Each container instance is identified by an unique CONTAINER ID code and an unique name. 
If no name is specified during the container creation docker will generate a random name.

If you are working in an interactive container you can terminate the shell by typing exit.
If no ```--rm``` option was specified at the container instantiation the status container will not be lost and will besaved on the system.

The list of the instantiated container (and their status) can be obtained by the following command:
```
docker ps -a
```

An *Exited* container can be restarted with:
```
docker start <CONTAINER ID> or <CONTAINER NAME>
```

An *Running* but detached container can be reattached by:
```
docker attach <CONTAINER ID> or <CONTAINER NAME>
```

