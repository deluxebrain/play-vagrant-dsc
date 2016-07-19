# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

# Global variables
# WinRM configuration for communicating with the guest
WINRM_HOST_PORT = 5895
WINRM_PASSWORD = "FooBarBaz"

# Absolute paths for directories on the guest
GUEST_SOURCE_DIR = "c:\\tmp\\deploy\\MyApp\\artefacts\\MySite"

# Relative paths for directories relating to DSC configuration
# Paths are relative to the VagrantFile containing directory
DSC_MODULES_DIR = "packaging/MyApp/dsc/modules/"
DSC_MANIFESTS_DIR = "packaging/MyApp/dsc/manifests/"
DSC_MOF_DIR = "packaging/MyApp/dsc/mof/"

# Host setup
HOSTNAME = "MyAppServer"
# IP address has to be from its own subnet
IP_ADDRESS = "10.0.0.30"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  
  # Every Vagrant virtual environment requires a box to build off of.
  config.vm.box = "vagrant-dsc-demo"
  config.vm.guest = :windows
  config.vm.communicator = "winrm"

  # Create a private network on the specified ip address and hostname
  config.vm.network "private_network", ip: IP_ADDRESS
  config.vm.hostname = HOSTNAME

  # Configure port forwarding 
  config.vm.network :forwarded_port,   guest: 3389, host: 3399,       id: "rdp",   auto_correct: false
  config.vm.network :forwarded_port,   guest: 5985, host: WINRM_HOST_PORT,  id: "winrm", auto_correct: false
  config.vm.network :forwarded_port,   guest: 80,   host: 8000,       id: "web" # Port forward for IIS
  config.vm.network :forwarded_port,   guest: 443,  host: 8443,       id: "ssl" # Port forward for SSL IIS
  config.vm.network :forwarded_port,   guest: 4018, host: 4018,       id: "remotevsdebug"

  # Configure winrm
  config.winrm.host = "localhost"
  config.winrm.password = WINRM_PASSWORD
  config.winrm.port = WINRM_HOST_PORT
  config.winrm.guest_port = WINRM_HOST_PORT

  # GUI or headless
  config.vm.provider "virtualbox" do |v|
    v.gui = true
  end

  # Copy over the files for packaging
  config.vm.synced_folder 'packaging/', 
    "c:\\tmp\\deploy",
    type: "rsync",
    rsync__auto: "true"

  # Run DSC
  config.vm.provision "dsc" do |dsc|
  
    # Temp working folder on the guest machine
    dsc.temp_dir = "c:\\tmp\\dsc"

    # Type of synced folders to use
    # E.g. "nfs" to use NFS synced folders
    # Defaults to VirtualBox
    dsc.synced_folder_type = "rsync"

    #
    # Paths are relative to the Vagrantfile directory
    #

    # These paths are added to the DSC configuration running
    # environment to enable local modules to be addresses
    dsc.module_path = [DSC_MODULES_DIR]

    # Path to the directory containing the root configuration manifest file
    # Defaults to 'manifests'
    dsc.manifests_path = DSC_MANIFESTS_DIR

    # Path relative to the manifests path containing the configuration file
    dsc.configuration_file = "MyApp.ps1"

    # Path relative to the configuration data file
    dsc.configuration_data_file = DSC_MANIFESTS_DIR + "MyAppConfig.psd1"

    # The configuration command to run
    # Assumed to be the same as the configuration file sans extension if missing
    dsc.configuration_name = "MyApp"

    # Path to the directory containing a pre-generated MOF file
    # Uncomment to use a pre-compiled MOF file
    # dsc.mof_path = $MOF_DIR
    
    # Commandline arguments for the configuration command
    dsc.configuration_params = {
      "-MachineName" => "localhost",
      "-SourcePath" => "#{GUEST_SOURCE_DIR}",
      "-HostName" => "#{HOSTNAME}"
    }
  end
end
