@ECHO OFF

SET folder="docker_work"
SET fluka_status="false"

FOR /F %%a in ('docker inspect -f {{.State.Running}} fluka 2^> nul') do SET fluka_status=%%a

IF "%fluka_status%" == "true" (
    ECHO.
    ECHO Fluka container is already running, attaching...
    ECHO.
    docker attach fluka
) ELSE IF "%fluka_status%" == "false" (
    ECHO.
    ECHO Fluka container already exists, restarting...
    ECHO.
    docker rm fluka
    docker run -it --rm --name fluka --net=host -e DISPLAY=192.168.99.1:0.0 -v fluka_home:/home/fluka -v /c/Users/docker/%folder%:/%folder% f4d_fluka bash
) ELSE (
    ECHO.
    ECHO Starting Fluka container...
    ECHO.
    docker run -it --rm --name fluka --net=host -e DISPLAY=192.168.99.1:0.0 -v fluka_home:/home/fluka -v /c/Users/docker/%folder%:/%folder% f4d_fluka bash
)
