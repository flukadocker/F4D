#!/bin/bash

echo "Checking Github, Fluka and flair versions"

github_installed=$(cat ./common/github)
github_current=$(git ls-remote https://github.com/flukadocker/F4D.git | grep HEAD | awk '{ print $1 }')

if [ "${github_installed}" == "1" ]; then
  echo "Newer installer was detected at the previous run"
  echo -n "Is the installer up to date? [y/N]: "
  read gitanswer

  if [ "${gitanswer}" == "y" ]; then
    echo "Continuing installation"
    github_installed="0"
  else
    echo "Stopping installation"
    echo "Update every file and rerun the installer"
    exit 1
  fi
fi

if [ "${github_installed}" == "0" ]; then
  github_installed=$github_current
  echo $github_current > ./common/github
elif [ ! "${github_installed}" == "${github_current}" ];  then
  echo "STOP: Newer installer available"
  echo "Download from https://github.com/flukadocker/F4D"
  echo "Update every file and rerun the installer"
  echo "1" > ./common/github
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

if [ ! "${fluka_installed}" == "${fluka_current}" ]; then
  echo "1" > ./common/update
else
  echo "0" > ./common/update
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
