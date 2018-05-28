@ECHO OFF & SETLOCAL ENABLEDELAYEDEXPANSION

docker create --name fluka_info -t horvathd84/f4d_baseimage bash
docker start fluka_info
docker exec fluka_info mkdir /common
docker cp ./common/version_current.sh fluka_info:/
docker cp ./common/fluka fluka_info:/common/
docker cp ./common/flukar fluka_info:/common/
docker cp ./common/flair fluka_info:/common/
docker exec fluka_info chmod 755 /version_current.sh
docker exec fluka_info /version_current.sh
docker cp fluka_info:/common/update ./common/
docker cp fluka_info:/common/fluka ./common/
docker cp fluka_info:/common/flukar ./common/
docker cp fluka_info:/common/flair ./common/
docker stop fluka_info
docker rm fluka_info

SET /P fluka_version=< .\common\flukar
SET /P fluka_version_short=< .\common\fluka

SET /P flair_version=< .\common\flair

SET /P update=< .\common\update

docker build -f .\common\flair.dockerfile --build-arg flair_version=%flair_version% -t f4d_flair .

IF NOT %errorlevel% == 0 (
    ECHO ERROR: Failed to install flair. Check your internet connection and/or try again later.
    FOR /F "tokens=*" %%a in ('docker ps -ql') do SET contid=%%a
    docker rm !contid!
    docker image prune -f
    EXIT /B 1
)

docker image prune -f

SET fluka_package=fluka%fluka_version_short%-linux-gfor64bitAA.tar.gz

IF "%update%" == "1" (
    IF EXIST %fluka_package% (
        ECHO Deleting old Fluka package
        DEL %fluka_package%
    )
    ECHO 0 > .\common\update
)

IF NOT EXIST %fluka_package% (
    ECHO Downloading Fluka
    ECHO Please specify your Fluka user identification ['fuid', i.e. fuid-1234]
    SET /P fuid="fuid: "

    docker run --name fluka_download -it f4d_flair wget --user=!fuid! --ask-password  https://www.fluka.org/packages/%fluka_package%
    docker cp fluka_download:%fluka_package% .
    docker rm fluka_download
)

IF NOT EXIST %fluka_package% (
    ECHO Error downloading Fluka package [%fluka_package%]
    EXIT /B 1
)

docker build --no-cache -f .\common\fluka.dockerfile --build-arg fluka_package=%fluka_package% -t f4d_fluka .

IF NOT %errorlevel% == 0 (
    ECHO ERROR: Failed to install Fluka. See the troubleshooting part of the user guide.
    FOR /F "tokens=*" %%a in ('docker ps -ql') do SET contid=%%a
    docker rm !contid!
    docker image prune -f
    EXIT /B 1
)

docker image prune -f