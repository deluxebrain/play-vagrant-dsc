# play-vagrant-dsc
Playing around with provisioning Windows servers using Packer, Vagrant and the vagrant-dsc plugin

## Prerequisities

- Packer
  - [packer-dsc](https://github.com/mefellows/packer-dsc)
    Build from source or use the binary included alongside the packer template (```./imaging/packer-provision-dsc```)
- Vagrant
  - [vagrant-dsc](https://github.com/mefellows/vagrant-dsc)
  - winrm-fs

## Sample appplication

The sample application is called ```vagrant-dsc-demo``` - all release artefacts and machine configuration (DSC) can be found in the ```./packaging``` directory.

## Packer

The packer template can be found in the ```imaging``` directory ( ```packer-vbox.json ```).
This defines the build chain for building out the ```vagrant-dsc-demo``` sample application. This is made up for the following build definitions for two Windows Server 2012 r2 virtualbox images:

1. ```raw```
  Builds out a base Windows Server 2012 r2 build as the first step in chained application build.
  The sample application is then baked from this image in one of two ways:
    
    1. Using packer via the ```baked``` build target
    2. Using vagrant.

  By default, builds out to ```/var/media/images/vbox/vagrant-dsc-demo-1.0.0/raw/```.
  
2. ```baked```
  Builds out the sample application using the ```raw``` image created as the first part of the build chain.
  Uses ```packer-dsc``` packer plugin to deploy and configure the sample application, including installation of the DSC Powershell modules required by the application DSC configuration and associated resources.

  By default, builds out to ```/var/media/images/vbox/vagrant-dsc-demo-1.0.0/baked/```. 

Note all virtualbox and vagrant images are defaulted to build out to ```/var/media/images```. This can be changed using the packer user variable ```images-directory```.

## Vagrant

Each build target builds provisions an associated vagrant box:

1. ```raw```
  This is the base image that is used by vagrant to provision the sample app ( via the vagrant-dsc plugin ).

2. ```baked```
  This is the baked application image created by packer. Included purely FYO and to allow the convenient comparison of packer-dsc vs vagrant-dsc provisioned servers.

The Vagrantfile expects to find a vm named ```vagrant-dsc-demo```. For example, this could be created as follows:

```script
vagrant box add vagrant-dsc-demo <path to box file>
```

Vagrant can be made to re-provision the box image against any changes to the dsc as follows:

```script
vagrant provision --provision-with dsc
```

