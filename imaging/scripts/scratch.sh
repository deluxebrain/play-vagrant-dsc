#!/bin/sh

mkdir -p /home/Vagrant/.ssh

wget https://raw.githubusercontent.com/mitchellh/vagrant/master/keys/vagrant.pub -O /home/Vagrant/.ssh/authorized_keys

# create a /etc/passwd file ( use the -l option to grab the user information from the local machine )
mkpasswd -l > /etc/passwd

