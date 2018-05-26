@ECHO OFF & SETLOCAL ENABLEEXTENSIONS ENABLEDELAYEDEXPANSION

SET pth=%cd::=%
SET pth=%pth:\=/%
SET drv=%pth:~0,1%
SET pth=%pth:~2%

SET folder="docker_work"

IF NOT EXIST %folder% (
    ECHO Creating working directory
    mkdir %folder%
)

call :tolower drv

docker run -it --rm --name fluka --net=host -e DISPLAY=10.0.75.1:0.0 -v fluka_home:/home/fluka -v /%drv%/%pth%/%folder%:/%folder% f4d_fluka bash

goto :EOF

:tolower
for %%L IN (a b c d e f g h i j k l m n o p q r s t u v w x y z) DO SET %1=!%1:%%L=%%L!
goto :EOF
