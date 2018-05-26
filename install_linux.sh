#!/bin/bash

chmod 755 ./common/version_current.sh
./common/version_current.sh

fluka_version=$(< ./common/flukar)
fluka_version_short=$(< ./common/fluka)

flair_version=$(< ./common/flair)

update=$(< ./common/update)

docker build -f ./common/flair.dockerfile --build-arg flair_version=$flair_version -t f4d_flair .

if [ ! $? -eq 0 ]; then
    echo "ERROR: Failed to install flair. Check your internet connection and/or try again later."
    docker rm $('docker ps -ql')
    docker image prune -f
    exit 1
fi

docker image prune -f

fluka_package=fluka$fluka_version_short-linux-gfor64bitAA.tar.gz

if [ "$update" == "1" ]; then
    if [ -e ${fluka_package} ]; then
        echo "Deleting old Fluka package"
        rm -rf ${fluka_package}
    fi
    echo "0" > ./common/update
fi

if [ ! -e ${fluka_package} ]; then
   echo "Downloading Fluka"
   echo "Please specify your Fluka user identification ['fuid', i.e. fuid-1234]"
   echo -n "fuid: "
   read fuid

   docker run --name fluka_download -it f4d_flair wget --user=$fuid --ask-password  https://www.fluka.org/packages/${fluka_package}
   docker cp fluka_download:${fluka_package} .
   docker rm fluka_download
fi

if [ ! -e ${fluka_package} ]; then
  echo "Error downloading Fluka package [${fluka_package}]"
  exit 1
fi

docker build --no-cache -f ./common/fluka.dockerfile --build-arg fluka_package=$fluka_package --build-arg UID=$UID -t f4d_fluka .

if [ ! $? -eq 0 ]; then
    echo "ERROR: Failed to install Fluka. See the troubleshooting part of the user guide."
    docker rm $('docker ps -ql')
    docker image prune -f
    exit 1
fi

docker image prune -f
