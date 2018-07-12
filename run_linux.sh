#!/bin/bash

folder="docker_work"
fluka_status=$(docker inspect -f {{.State.Running}} fluka 2> /dev/null)

#Check if the script is run on Linux or MacOS
unameout="$(uname -s)"
case "${unameout}" in
    # Linux
    Linux*)
        dsply=$DISPLAY
        ;;
    # MacOS
    Darwin*)
        dsply="docker.for.mac.localhost:0.0"
        ;; 
    # Unknown default to Linux
    *)
        echo "WARNING: Unknown host operating system."
        dsply=$DISPLAY
        ;;
esac
echo ${machine}

if [ ! -e ./${folder} ]; then
  echo "Creating working directory"
  mkdir ${folder}
fi

if [ "$fluka_status" == "true" ]; then
    echo ""
    echo "Fluka container is already running, attaching..."
    echo ""
    docker attach fluka
elif [ "$fluka_status" == "false" ]; then
    echo ""
    echo "ECHO Fluka container already exists, restarting..."
    echo ""
    docker rm fluka
    docker run -it --rm --name fluka --net=host -e DISPLAY=$dsply -v /tmp/.X11-unix:/tmp/.X11-unix:rw -v fluka_home:/home/fluka -v $PWD/${folder}:/${folder} f4d_fluka bash
else
    echo ""
    echo "Starting Fluka container..."
    echo ""
    docker run -it --rm --name fluka --net=host -e DISPLAY=$dsply -v /tmp/.X11-unix:/tmp/.X11-unix:rw -v fluka_home:/home/fluka -v $PWD/${folder}:/${folder} f4d_fluka bash
fi
