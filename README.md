# F4D (Fluka for Docker)

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
e568d8b2223ec4ca82c1e61582aed6771459c70eb9dc9ffc033633cac40b5ccc
fluka_info
Checking Fluka and flair versions
Check complete
fluka_info
fluka_info
Sending build context to Docker daemon  27.14kB
Step 1/3 : FROM horvathd84/f4d_baseimage
 ---> fc6165c8dab5
Step 2/3 : ARG flair_version
 ---> Using cache
 ---> b012fd72139d
Step 3/3 : RUN rpm -ivh http://www.fluka.org/flair/flair-$flair_version.noarch.rpm              http://www.fluka.org/flair/flair-geoviewer-$flair_version.x86_64.rpm
 ---> Using cache
 ---> 93b6e62b0919
Successfully built 93b6e62b0919
Successfully tagged f4d_flair:latest
SECURITY WARNING: You are building a Docker image from Windows against a non-Windows Docker host. All files and directories added to build context will have '-rwxr-xr-x' permissions. It is recommended to double check and reset permissions for sensitive files and directories.
Total reclaimed space: 0B
Downloading Fluka
Please specify your Fluka user identification ['fuid', i.e. fuid-1234]
fuid: fuid-2130
Password for user 'fuid-2130':
--2018-05-29 12:46:36--  https://www.fluka.org/packages/fluka2011.2x-linux-gfor64bitAA.tar.gz
Resolving www.fluka.org (www.fluka.org)... 193.205.78.76
Connecting to www.fluka.org (www.fluka.org)|193.205.78.76|:443... connected.
HTTP request sent, awaiting response... 401 Authorization Required
Authentication selected: Basic realm="FLUKA download interface"
Connecting to www.fluka.org (www.fluka.org)|193.205.78.76|:443... connected.
HTTP request sent, awaiting response... 200 OK
Length: 163830357 (156M) [application/x-gzip]
Saving to: 'fluka2011.2x-linux-gfor64bitAA.tar.gz'

fluka2011.2x-linux-gfor64bitA 100%[=================================================>] 156.24M  11.2MB/s    in 14s

2018-05-29 12:46:50 (11.2 MB/s) - 'fluka2011.2x-linux-gfor64bitAA.tar.gz' saved [163830357/163830357]

fluka_download
Sending build context to Docker daemon  163.9MB
Step 1/15 : FROM f4d_flair
 ---> 93b6e62b0919
Step 2/15 : ARG fluka_package
 ---> Running in 2b88267f641b
Removing intermediate container 2b88267f641b
 ---> 633192137d37
Step 3/15 : COPY $fluka_package /tmp
 ---> b2de7080e206
Step 4/15 : COPY ./common/motd /etc
 ---> 32be6a2bbec5
Step 5/15 : COPY ./common/disclaimer /etc/profile.d/
 ---> f3dd46f6dd46
Step 6/15 : COPY ./common/version_installed.sh /etc/profile.d/
 ---> 49d282032929
Step 7/15 : ENV FLUFOR=gfortran
 ---> Running in 8df9cb1a6da4
Removing intermediate container 8df9cb1a6da4
 ---> 284fca91527e
Step 8/15 : ENV FLUPRO=/usr/local/fluka
 ---> Running in 7b5393f6c2a8
Removing intermediate container 7b5393f6c2a8
 ---> f21a43d77a79
Step 9/15 : ARG UID=1000
 ---> Running in 08fdea43b2f8
Removing intermediate container 08fdea43b2f8
 ---> b312d549e7f4
Step 10/15 : RUN useradd -u $UID -c 'Fluka User' -m -d /home/fluka -s /bin/bash fluka &&     mkdir -p /usr/local/fluka &&     tar -zxf /tmp/fluka*.tar.gz -C /usr/local/fluka &&     cd /usr/local/fluka; make &&     chown -R fluka:fluka /usr/local/fluka &&     rm -rf /tmp/fluka*.tar.gz &&     cp /usr/local/fluka/flukahp / &&     rm -rf /flukahp &&     mkdir /docker_work &&     chown -R fluka:fluka /docker_work &&     chmod 755 /etc/profile.d/version_installed.sh
 ---> Running in c394895bbb38
FLUPRO=/usr/local/fluka flutil/lfluka -o flukahp -m fluka
$FLUPRO = /usr/local/fluka
 now linking

[...]

make[1]: Leaving directory '/usr/local/fluka/flutil'
Removing intermediate container c394895bbb38
 ---> 797826837370
Step 11/15 : USER fluka
 ---> Running in 4796c2315cf5
Removing intermediate container 4796c2315cf5
 ---> 4cb1eb805d7e
Step 12/15 : ENV LOGNAME=fluka
 ---> Running in 102b7e677866
Removing intermediate container 102b7e677866
 ---> 2e2ba10fc127
Step 13/15 : ENV USER=fluka
 ---> Running in 8f91456e3f14
Removing intermediate container 8f91456e3f14
 ---> bf8919daeaca
Step 14/15 : ENV HOME /home/fluka
 ---> Running in 20e44804698f
 ---> fc91c2157995
Removing intermediate container 3cf9d8170c8d
Step 15/15 : WORKDIR /home/fluka
 ---> 633a20008533
Removing intermediate container 6b745fbb02b7
Successfully built 633a20008533
```

During this phase the script will:
- download Fluka from [fluka.org](http://fluka.org) using your *fuid* and *password*;
- download the necessary base image from the docker hub to the local docker image repository;
- perform the necessary Fluka installation steps;
- create a *fluka* default user in the image.


## Your first Fluka container 

### Creating a container

### OS X Linux
It is possible to get a shell terminal to container and to pass trough the X11 connection along with some local folder. 

Execute from a terminal ```./run_linux.sh```: this script will start the Docker container with FLUKA and FLAIR installed.

### Windows 10 Pro, Enterprise, and Education

Change directory to where you have installed the Docker scripts (e.g. C:\Docker) and execute the script ```run_win10_home.bat```: this script will start the Docker container with FLUKA and FLAIR installed.

### Windows 10 Home (and possibly older Windows versions)

Start as Administrator a Docker Quickstart Terminal and execute from the directory /c/Users/docker
```run_win10_professional.bat```: this script will start the Docker container with FLUKA and FLAIR installed and ready to be used.

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

A shared folder between the host OS and the Docker container is defined as \docker_work 
and mounted in the subdirectory \docker_work in the user-defined directory (e.g. C:\docker or C:\Users\docker).

You can try, for example, to run Fluka by:
```
[flukauser@linuxkit-025000000001 ~]$ cd /docker_work
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

