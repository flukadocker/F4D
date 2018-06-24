#!/bin/bash

echo ""
echo "Fluka for Docker"
echo ""
cat /etc/profile.d/disclaimer
echo ""

echo ""
cat /etc/motd
echo ""

fluka_installed=$(grep "version" $FLUPRO/Version.tag | awk -F":" '{print $2}' | awk '{print $1}')
fluka_installed_short=$(echo  $fluka_installed |awk -F"." '{print $1 "." $2}')
fluka_current=$(echo  $FLUVER)
flair_installed=$(dnf list installed flair | grep flair | awk '{print $2}')

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
  echo ""
  echo "WARNING:"
  echo "    The installed version of Fluka is older than the latest"
  echo "    released version. To update Fluka, please remove the"
  echo "    fluka${fluka_installed_short}-linux-gfor64bitAA.tar.gz"
  echo "    from your Docker folder and rerun the installation script."
fi

echo ""
echo "More information at www.fluka.org and https://github.com/flukadocker/F4D"
echo ""
