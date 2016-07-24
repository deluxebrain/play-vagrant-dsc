#!/bin/sh

# Install pub key - no idea at this stage why we are using mitchellh's!
mkdir -p /home/Vagrant/.ssh
wget https://raw.githubusercontent.com/mitchellh/vagrant/master/keys/vagrant.pub -O /home/Vagrant/.ssh/authorized_keys

# These are things you don't usually need todo with Cygwin due to its integration with the Windows account database
# 1. Create a /etc/passwd file ( use the -l option to grab the user information from the local machine )
mkpasswd -l > /etc/passwd

# 2. Create a local /etc/group file
mkgroup -l > /etc/group

# Setup sshd
# https://cygwin.com/ml/cygwin/2004-11/msg01117/ssh-host-config
ssh-host-config --yes \
        -w "FooBarBaz"



# Setup ssh directory permissions
chmod 700 /home/Vagrant/.ssh        # drwx------
chmod 600 /home/Vagrant/*           # -rw-r--r--
chmod 644 /home/Vagrant/.ssh/*.pub  # -rw-------
