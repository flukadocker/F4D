#!/bin/bash

# set gnuplot default terminal to x11
echo "set term x11" > /home/fluka/.gnuplot

cat /etc/motd

fluka_installed=$(grep "version" $FLUPRO/Version.tag | awk -F":" '{print $2}' | awk '{print $1}')
flair_installed=$(dnf list installed flair | grep flair | awk '{print $2}')

echo "Fluka version: $fluka_installed, flair version: $flair_installed"
echo "More information at www.fluka.org and https://github.com/flukadocker/F4D"

cat /etc/profile.d/disclaimer
