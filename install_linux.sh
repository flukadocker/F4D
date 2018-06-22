#!/bin/bash

docker pull flukadocker/f4d_baseimage

docker create --name fluka_info -t flukadocker/f4d_baseimage bash
docker start fluka_info
docker exec fluka_info mkdir /common
docker cp ./common/version_current.sh fluka_info:/
docker cp ./common/fluka fluka_info:/common/
docker cp ./common/flukar fluka_info:/common/
docker cp ./common/flair fluka_info:/common/
docker cp ./common/version.tag fluka_info:/common/
docker exec fluka_info chmod 755 /version_current.sh
docker exec -it fluka_info /version_current.sh

if [ ! $? -eq 0 ]; then
    echo "ERROR: Newer versions of the install and/or run scripts are available. Update them to continue."
    docker stop fluka_info
    docker rm fluka_info
    exit 1
fi

docker cp fluka_info:/common/update ./common/
docker cp fluka_info:/common/fluka ./common/
docker cp fluka_info:/common/flukar ./common/
docker cp fluka_info:/common/flair ./common/
docker stop fluka_info
docker rm fluka_info

fluka_version=$(< ./common/flukar)
fluka_version_short=$(< ./common/fluka)

flair_version=$(< ./common/flair)

update=$(< ./common/update)

docker build -f ./common/flair.dockerfile --build-arg flair_version=$flair_version -t f4d_flair .

if [ ! $? -eq 0 ]; then
    echo "ERROR: Failed to install flair. Check your internet connection and/or see the troubleshooting part of the user guide."
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
  echo "ERROR: Failed to download Fluka package [${fluka_package}]"
  exit 1
fi

docker build --no-cache -f ./common/fluka.dockerfile --build-arg fluka_package=$fluka_package --build-arg fluka_version=$fluka_version --build-arg UID=$UID -t f4d_fluka .

if [ ! $? -eq 0 ]; then
    echo "ERROR: Failed to install Fluka. See the troubleshooting part of the user guide."
    docker rm $('docker ps -ql')
    docker image prune -f
    exit 1
fi

docker image prune -f
docker image prune -f
