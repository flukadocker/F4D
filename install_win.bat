@ECHO OFF & SETLOCAL ENABLEDELAYEDEXPANSION

REM docker pull flukadocker/f4d_baseimage

docker inspect f4d_base_ubuntu_focal
IF NOT %errorlevel% == 0 (
    ECHO Docker image f4d_base_ubuntu_focal does not exist yet.
    ECHO In the future flukadocker/f4d_baseimage Docker image
    ECHO may be based on Ubuntu 20.04 LTS,
    ECHO but for now please build Docker image with a Dockerfile at
    ECHO github.com/vicha-w/F4D_baseimage
    ECHO This Docker image will be built based on Ubuntu 20.04 LTS
    ECHO instead of Fedora 30.
    ECHO Use the following commands:
    ECHO git clone https://github.com/vicha-w/F4D_baseimage.git
    ECHO docker build -f F4D_baseimage/Dockerfile -t f4d_base_ubuntu_focal .
    EXIT /B 1
)

docker create --name fluka_info -t f4d_base_ubuntu_focal bash
docker start fluka_info
docker exec fluka_info mkdir /common
docker cp ./common/version_current.sh fluka_info:/
docker cp ./common/fluka fluka_info:/common/
docker cp ./common/flukar fluka_info:/common/
docker cp ./common/flair fluka_info:/common/
docker cp ./common/version.tag fluka_info:/common/
docker exec fluka_info chmod 755 /version_current.sh
docker exec -it fluka_info /version_current.sh

IF NOT %errorlevel% == 0 (
    ECHO ERROR: Newer versions of the install and/or run scripts are available. Update them to continue.
    docker stop fluka_info
    docker rm fluka_info
    EXIT /B 1
)

docker cp fluka_info:/common/fluka ./common/
docker cp fluka_info:/common/flukar ./common/
docker cp fluka_info:/common/flair ./common/
docker stop fluka_info
docker rm fluka_info

SET /P fluka_version=< .\common\flukar
SET /P fluka_version_short=< .\common\fluka

SET /P flair_version=< .\common\flair

ECHO Will install FLUKA v!fluka_version_short!, FLAIR v!flair_version!

docker build --progress=plain -f .\common\flair.dockerfile --build-arg flair_version=%flair_version% -t f4d_flair .

IF NOT %errorlevel% == 0 (
    ECHO ERROR: Failed to install flair. Check your internet connection and/or see the troubleshooting part of the user guide.
    FOR /F "tokens=*" %%a in ('docker ps -ql') do SET contid=%%a
    docker rm !contid!
    docker image prune -f
    EXIT /B 1
)

docker image prune -f

IF "%~1" == "" (
    SET fluka_package=fluka!fluka_version_short!-linux-gfor64bitAA.tar.gz
    SET fluka_data=fluka!fluka_version_short!-data.tar.gz
    SET fluka_package_respin=fluka!fluka_version!-linux-gfor64bitAA.tar.gz

    ECHO Installing FLUKA into a container with the following variables:
    ECHO fluka_package = !fluka_package!
    ECHO fluka_data = !fluka_data!
    ECHO fluka_package_respin = !fluka_package_respin!

    IF NOT EXIST !fluka_package_respin! (
        IF EXIST !fluka_package! (
            ECHO Deleting old Fluka package
            DEL !fluka_package!
        )

        ECHO Downloading Fluka
        ECHO Please specify your Fluka user identification ['fuid', i.e. fuid-1234]
        SET /P fuid="fuid: "

        docker run --name fluka_download -it f4d_flair wget --user=!fuid! --ask-password  https://www.fluka.org/packages/!fluka_package! --secure-protocol=TLSv1 --ciphers="DEFAULT@SECLEVEL=1"
        docker cp fluka_download:!fluka_package! .
        docker rm fluka_download

        
    )

    IF NOT EXIST !fluka_data! (

        ECHO Downloading Fluka data
        ECHO Please specify your Fluka user identification ['fuid', i.e. fuid-1234]
        SET /P fuid="fuid: "

        docker run --name fluka_download -it f4d_flair wget --user=!fuid! --ask-password  https://www.fluka.org/packages/!fluka_data! --secure-protocol=TLSv1 --ciphers="DEFAULT@SECLEVEL=1"
        docker cp fluka_download:!fluka_data! .
        docker rm fluka_download

        
    )

IF EXIST !fluka_package! (
        ECHO Renaming Fluka package
        REN !fluka_package! !fluka_package_respin!
    )

    IF NOT EXIST !fluka_package_respin! (
        ECHO ERROR: Failed to download Fluka package [!fluka_package!]
        EXIT /B 1
    )
) ELSE (
    ECHO Using custom package [%~1]
    SET fluka_package_respin=%~1

    IF NOT EXIST !fluka_package_respin! (
        ECHO ERROR: Custom package doesn't exists [!fluka_package_respin!]
        EXIT /B 1
    )

    SET fluka_version="Custom"
)

docker build --no-cache -f .\common\fluka.dockerfile --progress=plain --build-arg fluka_package=%fluka_package_respin% --build-arg fluka_data=%fluka_data% --build-arg fluka_version=%fluka_version% -t f4d_fluka .

IF NOT %errorlevel% == 0 (
    ECHO ERROR: Failed to install Fluka. See the troubleshooting part of the user guide.
    FOR /F "tokens=*" %%a in ('docker ps -ql') do SET contid=%%a
    docker rm !contid!
    docker image prune -f
    EXIT /B 1
)

docker image prune -f
docker image prune -f
