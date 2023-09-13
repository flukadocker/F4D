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

docker cp fluka_info:/common/fluka ./common/
docker cp fluka_info:/common/flukar ./common/
docker cp fluka_info:/common/flair ./common/
docker stop fluka_info
docker rm fluka_info

fluka_version=$(< ./common/flukar)
fluka_version_short=$(< ./common/fluka)

flair_version=$(< ./common/flair)
flair_version=${flair_version}py3
docker build -f ./common/flair.dockerfile --build-arg flair_version=$flair_version -t f4d_flair .

if [ ! $? -eq 0 ]; then
    echo "ERROR: Failed to install flair. Check your internet connection and/or see the troubleshooting part of the user guide."
    docker rm $(docker ps -ql)
    docker image prune -f
    exit 1
fi

docker image prune -f

if [ -z "$1" ]; then
    fluka_package=fluka$fluka_version_short-docker.tar.gz
    fluka_package_respin=fluka$fluka_version-docker.tar.gz
    fluka_data=fluka$fluka_version_short-data.tar.gz

    if [ ! -e ${fluka_package_respin} ]; then
        if [ -e ${fluka_package} ]; then
            echo "Deleting old Fluka package"
            rm -rf ${fluka_package}
        fi

        echo "Downloading Fluka"
        echo "Please specify your Fluka user identification ['fuid', i.e. fuid-1234]"
        echo -n "fuid: "
        read fuid

        docker run --name fluka_download -it f4d_flair wget --user=$fuid --ask-password  https://www.fluka.org/packages/${fluka_package}
        docker cp fluka_download:${fluka_package} .
        docker rm fluka_download
    fi

    if [ ! -e ${fluka_data} ]; then
        echo "Downloading Fluka data"
        echo "Please specify your Fluka user identification ['fuid', i.e. fuid-1234]"
        echo -n "fuid: "
        read fuid


        docker run --name fluka_download -it f4d_flair wget --user=$fuid --ask-password  https://www.fluka.org/packages/${fluka_data}
        docker cp fluka_download:${fluka_data} .
        docker rm fluka_download
    fi

    if [ -e ${fluka_package} ]; then
        echo "Renaming Fluka package"
        mv ${fluka_package} ${fluka_package_respin}
    fi

    if [ ! -e ${fluka_package_respin} ]; then
        echo "ERROR: Failed to download Fluka package [${fluka_package}]"
        exit 1
    fi

else
    echo "Using custom package [${1}]"
    fluka_package_respin=$1

    if [ ! -e ${fluka_package_respin} ]; then
        echo "ERROR: Custom package doesn't exists [${fluka_package_respin}]"
        exit 1
    fi

    fluka_version="Custom"
fi

docker build --no-cache -f ./common/fluka.dockerfile --build-arg fluka_package=$fluka_package_respin --build-arg fluka_data=$fluka_data --build-arg fluka_version=$fluka_version --build-arg UID=$UID -t f4d_fluka .

if [ ! $? -eq 0 ]; then
    echo "ERROR: Failed to install Fluka. See the troubleshooting part of the user guide."
    docker rm $(docker ps -ql)
    docker image prune -f
    exit 1
fi

docker image prune -f
docker image prune -f
