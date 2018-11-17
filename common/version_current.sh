#!/bin/bash

echo "Checking Installer, Fluka and flair versions"

installer_installed=$(cat ./common/version.tag)

wget_return=$(wget -q https://github.com/flukadocker/F4D/raw/master/common/version.tag)
if [ $? -eq 0 ]; then
  installer_current=$(cat version.tag)
  rm -rf version.tag
else
  echo "WARNING: Can't find current Installer version"
  installer_current=$installer_installed
fi

if [ ! "${installer_installed}" == "${installer_current}" ]; then
  exit 1
fi

fluka_installed=$(cat ./common/flukar)

wget_return=$(wget -q http://www.fluka.org/Version.tag)
if [ $? -eq 0 ]; then
  fluka_current=$(grep "version" Version.tag | awk -F":" '{print $2}' | awk '{print $1}')
  rm -rf Version.tag
else
  echo "WARNING: Can't find current Fluka version"
  fluka_current=$fluka_installed
fi

fluka_current_short=$(echo  $fluka_current |awk -F"." '{print $1 "." $2}')

echo $fluka_current > ./common/flukar
echo $fluka_current_short > ./common/fluka

flair_installed=$(cat ./common/flair)

wget_return=$(wget -q http://www.fluka.org/flair/version.tag)
if [ $? -eq 0 ]; then
  flair_current=$(grep "flair*" version.tag | awk '{print $1}' | tail -c +7 | head -c -5)
  rm -rf version.tag
else
  echo "WARNING: Can't find current flair version"
  flair_current=$flair_installed
fi

echo $flair_current > ./common/flair

echo "Check complete"
