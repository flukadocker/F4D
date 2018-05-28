#!/bin/bash

folder="docker_work"

if [ ! -e ./${folder} ]; then
  echo "Creating working directory"
  mkdir ${folder}
fi

docker run -it --rm --name fluka --net=host -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix:rw -v fluka_home:/home/fluka -v $PWD/${folder}:/${folder} f4d_fluka bash
