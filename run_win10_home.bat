@ECHO OFF

SET folder="docker_work"

docker run -it --rm --name fluka --net=host -e DISPLAY=192.168.99.1:0.0 -v fluka_home:/home/fluka -v /c/Users/docker/%folder%:/%folder% f4d_fluka bash
