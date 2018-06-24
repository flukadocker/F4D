@ECHO OFF & SETLOCAL ENABLEEXTENSIONS ENABLEDELAYEDEXPANSION

SET pth=%cd::=%
SET pth=%pth:\=/%
SET drv=%pth:~0,1%
SET pth=%pth:~2%

SET folder="docker_work"
SET fluka_status="false"

IF NOT EXIST %folder% (
    ECHO Creating working directory
    mkdir %folder%
)

call :tolower drv

FOR /F %%a in ('docker inspect -f {{.State.Running}} fluka 2^> nul') do SET fluka_status=%%a

IF "%fluka_status%" == "true" (
    ECHO.
    ECHO Fluka container is already running, attaching...
    ECHO.
    docker attach fluka
) ELSE (
    docker run -it --rm --name fluka --net=host -e DISPLAY=10.0.75.1:0.0 -v fluka_home:/home/fluka -v /%drv%/%pth%/%folder%:/%folder% f4d_fluka bash
)

goto :EOF

:tolower
for %%L IN (a b c d e f g h i j k l m n o p q r s t u v w x y z) DO SET %1=!%1:%%L=%%L!
goto :EOF
