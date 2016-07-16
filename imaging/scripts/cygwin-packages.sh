#!/bin/bash

# apt-cyg
wget rawgit.com/transcode-open/apt-cyg/master/apt-cyg
install apt-cyg /bin

# apt-cyg packages
apt-cyg install openssh
apt-cyg install rsync

