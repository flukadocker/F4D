# Fluka for Docker

Original scripts by V. Boccone, A. Fontana, D. Horváth

These scripts allow to install and run Fluka (provided by www.fluka.org) and Flair2 inside a Docker container in any OS where Docker can be installed. The idea is derived by the scripts developed and maintained by V. Boccone at [https://github.com/drbokko/fedora_27-fluka](https://github.com/drbokko/fedora_27-fluka).

They are designed to be used only on single user machines, they are not suitable for multiple people working in parallel on a machine (i.e. clusters).

This version of Fluka for Docker is based on F4D Docker base image based on Ubuntu 20.04 LTS instead of Fedora 30. The base image on Docker Hub is still based on Fedora 30, so please refer to github.com/vicha-w/F4D_baseimage in order to build the base image.

# Creating your personal Fluka User ID

In order to be able to download and use Fluka, you must register on the Fluka website [fluka.org](https://www.fluka.org/fluka.php?id=secured_intro). With the registration you will get your personal Fluka User ID (fuid-XXXX) and password. Later, you will have to provide these during the installation.

> If you already registered on the website, and have your Fluka User ID, you can skip this step.

# Installing Docker

You can install Docker in the host OS by following the instructions on the Docker website: these are available for the most common Linux flavours, Windows 10, and macOS.

## macOS

- Install Docker for Mac here: https://docs.docker.com/desktop/mac/install/

  > On macOS and Linux machines the use of the native official FLUKA release is highly encouraged.

- Install the latest XQuartz X server, and enable the ```Allow connections from network clients``` in the preferences.

## Linux

- Install Docker from your package manager (`apt`, `dnf`, or `pacman`). If you do not believe in Terminal, you will have to start using it now unfortunately.
  
  On Ubuntu:
  ```bash
  sudo apt install docker
  ```
- Once docker is installed, you need to add your user to the docker group.   
  ```bash
  sudo usermod -aG docker $USER
  ```
  In this way, all docker commands can be issued as $USER.

## Windows 10 

- Install Docker for Windows here: https://docs.docker.com/desktop/windows/install/
- Install Public Domain Release version of Xming: [http://www.straightrunning.com/XmingNotes/](http://www.straightrunning.com/XmingNotes/)
- Allow Docker and Xming through the firewall.


## Testing Docker installation

To check if the installation of Docker was successful, run the following command: ```docker run --rm hello-world```

If everything is correct, you should see following message:
```
Hello from Docker!
This message shows that your installation appears to be working correctly.

To generate this message, Docker took the following steps:
 1. The Docker client contacted the Docker daemon.
 2. The Docker daemon pulled the "hello-world" image from the Docker Hub.
    (amd64)
 3. The Docker daemon created a new container from that image which runs the
    executable that produces the output you are currently reading.
 4. The Docker daemon streamed that output to the Docker client, which sent it
    to your terminal.

To try something more ambitious, you can run an Ubuntu container with:
 $ docker run -it ubuntu bash

Share images, automate workflows, and more with a free Docker ID:
 https://hub.docker.com/

For more examples and ideas, visit:
 https://docs.docker.com/engine/userguide/
```

# Generating your personal docker image with Fluka

The scripts for the generation of a basic Fluka-compatible image are open source.

## Getting the scripts

### Download

You can download the latest version of the scripts from the links on the top of this page, or directly from the github repository: [https://github.com/vicha-w/F4D/archive/refs/heads/master.zip](https://github.com/vicha-w/F4D/archive/refs/heads/master.zip)

### Git clone (recommended)

You can alternatively checkout the full repository with the scripts from the github repository:
```bash
git clone https://github.com/vicha-w/F4D.git
```
In both cases the download directory is your choice. This method allows you to update the installation code once it is updated here, by simply pulling from this repository. To pull the latest changes using git, go to the same directory and simply run `git pull`.

## Making the docker directory

### macOS, Linux, and Windows 10

The downloaded scripts can be placed anywhere in your home directory. On Windows, you need to put the downloaded scripts in a directory where you have write access. A good choice is your own user directory `C:\Users\<YOUR USER NAME>`.

## Running the installation script

> **Before installing with the instructions below, make sure that you have an Ubuntu-based F4D Docker image! If you haven't done so, you can build one by following instructions on [github.com/vicha-w/F4D_baseimage](https://github.com/vicha-w/F4D_baseimage)**

You can check for Ubuntu-based F4D Docker image via Docker Desktop app or with Terminal or Command Prompt with the following command:

```bash
docker images
```

This repository contains two install scripts: `install_linux.sh` and `install_win.bat`. Both scripts will generate your personal Fluka image.

- macOS, Linux: execute `install_linux.sh` in Terminal.
- Windows 10: execute `install_win.bat` in Command Prompt.

## The installation process

Both install scripts will prompt for your Fluka credentials (fuid-XXXX and password), download the latest public Fluka release and install it in a Fedora based Docker container.

If you are not familiar with UNIX-like password prompt on Terminal, you might notice that there are no characters appearing on the screen when you type in your password. This is a typical behaviour in UNIX-like shell.

The installation might require a bit of time - from 1 to 10 minutes - depending on the speed of your internet connection.

The typical output of these steps in all systems is as follows:
```
Using default tag: latest
latest: Pulling from flukadocker/f4d_baseimage
Digest: sha256:a3817003a314970e2049f6490617097e9c1b8a577ae516601567f2683514cb73
Status: Image is up to date for flukadocker/f4d_baseimage:latest
Total reclaimed space: 0B
162358d0674281e5c4adb1032c83730ccba335ff1f5c53952eabdeb83b47eabb
fluka_info
Checking Fluka and flair versions
Check complete
fluka_info
fluka_info
Sending build context to Docker daemon  27.14kB
Step 1/3 : FROM flukadocker/f4d_baseimage
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
fuid: fuid-1234
Password for user 'fuid-1234':
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
- download the necessary base image from the docker hub to the local docker image repository;
- download and install Flair;
- download Fluka from [fluka.org](http://fluka.org) using your *fuid* and *password*;
- perform the necessary Fluka installation steps;
- create a *fluka* default user in the image.

## Custom packages

It is possible to install additional Ubuntu packages. Uncomment and edit the appropriate lines in ```./common/flair.dockerfile```. Multiple packages can be listed, the package names should be separated with ```SPACE```.

After editing the dockerfile, run the installation script again to create the image with the custom packages.

# Your first Fluka container

## Creating a container

### macOS, Linux

It is possible to get a shell terminal to container and to pass trough the X11 connection along with some local folder.

- Execute from a terminal ```./run_linux.sh```: this script will start the Docker container with Fluka and Flair installed.

  > Note: Depending on your Xserver configuration you might need to run `xhost +` on the host OS to enable the X11 forwarding.

### Windows 10

- Use XLaunch to start Xming selecting the "No Access Control" checkbox, while keeping the others as is.
- Change directory to where you have installed the Docker scripts (e.g. ```C:\Users\<YOUR USER NAME>```) and execute the script ```run_win10_professional.bat```: this script will start the Docker container with Fluka and Flair installed.
- Allow sharing the ```C:\``` drive, if Docker asks.

## Using a container

Once in the docker container shell you could use the shell as if you would on a normal linux system.

The container automatically starts in the ```/docker_work``` folder. This folder is shared folder between the host OS and the Docker container. On the host OS it's located in the user-defined directory (e.g. `C:\Users\<YOUR USER NAME>`) as a subfolder.

You can try, for example, to run Fluka by:
```
[flukauser@linuxkit-025000000001 docker_work]$ mkdir test
[flukauser@linuxkit-025000000001 docker_work]$ cd test
[flukauser@linuxkit-025000000001 test]$ cp $FLUPRO/example.inp .
[flukauser@linuxkit-025000000001 test]$ $FLUPRO/flutil/rfluka -N0 -M1 example
$TARGET_MACHINE = Linux
$FLUPRO = /usr/local/fluka

Initial seed copied from /usr/local/fluka
Running fluka in /docker_work/test/fluka_25

======================= Running FLUKA for cycle # 1 =======================

Removing links
Removing temporary files
Saving output and random number seed
Saving additional files generated
     Moving fort.47 to /docker_work/test/example001_fort.47
     Moving fort.48 to /docker_work/test/example001_fort.48
     Moving fort.49 to /docker_work/test/example001_fort.49
     Moving fort.50 to /docker_work/test/example001_fort.50
     Moving fort.51 to /docker_work/test/example001_fort.51
End of FLUKA run
```

or also running Flair with the command ```flair```.

Always work in the ```/docker_work``` directory. While the home folder ```~``` is saved between sessions, it is not shared with the host OS.

### Limitation of parallel jobs

On Windows by default Docker is configured to have limited CPU cores and memory available to the containers. Only run one simulation job at a time. Parallel jobs might cause errors or hang the container.

## Stopping a container

Use the ```exit``` command in the container's shell to stop it. Upon exiting from the container shell, Docker will take care of stopping the container automatically.

# Updating the Fluka docker image

If a new version of Fluka or Flair released, you can update your Fluka docker image by running the installation script again. It will automatically download and install the updated versions.

## Errors during update

In case of an error during the update you can try the following troubleshooting steps:

1. Check your internet connection, and see if [fluka.org](http://fluka.org) can be loaded.

3. Delete the ```fluka*.tar.gz``` file in the scripts folder.

3. Except the `docker_work` directory, delete everthing from your Docker directory and redownload the latest scripts.
