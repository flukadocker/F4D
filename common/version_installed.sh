#!/bin/bash

# set gnuplot default terminal to x11
echo "set term x11" > /home/fluka/.gnuplot

cat /etc/profile.d/disclaimer
echo ""

echo ""
cat /etc/motd
echo ""

fluka_installed=$(grep "version" $FLUPRO/Version.tag | awk -F":" '{print $2}' | awk '{print $1}')
fluka_installed_short=$(echo  $fluka_installed |awk -F"." '{print $1 "." $2}')
fluka_current=$(echo  $FLUVER)
flair_installed=$(apt list --installed flair | grep flair | awk '{print $2}')

echo "Fluka version: $fluka_installed, flair version: $flair_installed"

if [ ! -f /usr/local/fluka/flukahp ]; then
  echo ""
  echo "ERROR:"
  echo "    Fluka executable is missing!"
  echo "    Try running the installation script again."
  echo "    If this doesn't solve it, go to the website below and"
  echo "    download the latest version."
fi

if [ ! "${fluka_installed}" == "${fluka_current}" ]; then
  if [ ! "${fluka_current}" == "Custom" ]; then
    echo ""
    echo "WARNING:"
    echo "    The installed version of Fluka is not the latest"
    echo "    released version. To update Fluka, please remove the"
    echo "    fluka*.tar.gz files from your Docker folder and"
    echo "    rerun the installation script."
  fi
fi

echo ""
echo "More information at www.fluka.org and flukadocker.github.io/F4D"
echo ""
