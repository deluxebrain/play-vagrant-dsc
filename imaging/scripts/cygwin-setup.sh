#!/bin/sh

echo "Provisioning cygwin packages"

# apt-cyg
echo "Installing apt-cyg"
lynx -source rawgit.com/transcode-open/apt-cyg/master/apt-cyg > apt-cyg
install apt-cyg /bin

# apt-cyg packages
apt-cyg install wget
apt-cyg install openssh
apt-cyg install rsync

