#!/bin/sh

mkdir -p /home/Vagrant/.ssh

wget https://raw.githubusercontent.com/mitchellh/vagrant/master/keys/vagrant.pub -O /home/Vagrant/.ssh/authorized_keys

