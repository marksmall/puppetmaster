# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.define :puppetmaster do |host|
    # Supports local cache, don't wast bandwitdh
    # vagrant plugin install vagrant-cachier
    # https://github.com/fgrehm/vagrant-cachier 
    if Vagrant.has_plugin?("vagrant-cachier")
      config.cache.auto_detect = true
    end

    # Every Vagrant virtual environment requires a box to build off of.
    host.vm.box = "centos-6.4-minimal"

    # The url from where the 'config.vm.box' box will be fetched if it
    # doesn't already exist on the user's system.
    host.vm.box_url = "http://puppet-vagrant-boxes.puppetlabs.com/centos-64-x64-vbox4210.box"

    # Create a private network, which allows host-only access to the machine
    # using a specific IP.
    host.vm.network :private_network, ip: "192.168.50.10"
    host.vm.hostname = "puppetmaster.edina.ac.uk"

    # Provider-specific configuration so you can fine-tune various
    # backing providers for Vagrant. These expose provider-specific options.
    # Example for VirtualBox:    
    host.vm.provider :virtualbox do |vb|
      # Use VBoxManage to customize the VM. For example to change memory:
      vb.customize ["modifyvm", :id, "--memory", "1048"]
    end
    
    # Enable provisioning with Puppet stand alone.  Puppet manifests
    # are contained in a directory path relative to this Vagrantfile.
    # You will need to create the manifests directory and a manifest in
    # the file ..pp in the manifests_path directory.    

    # Bootstrap the vm to install puppet, facter etc.
    host.vm.provision :shell, :path => "centos_6_x.sh"

    host.vm.provision :puppet do |puppet|
      puppet.manifests_path = "manifests"
      puppet.manifest_file  = "site.pp"
      puppet.module_path = "modules"
      puppet.options = "--verbose --debug --environment dev"

      # Puppet 3 only.
      puppet.hiera_config_path = "config/hiera.yaml"
      puppet.working_directory = "/vagrant"
    end
  end


  config.vm.define :puppetagent do |host|
    # Supports local cache, don't wast bandwitdh
    # vagrant plugin install vagrant-cachier
    # https://github.com/fgrehm/vagrant-cachier 
    if Vagrant.has_plugin?("vagrant-cachier")
      config.cache.auto_detect = true
    end

    # Every Vagrant virtual environment requires a box to build off of.
    host.vm.box = "centos-6.4-minimal"

    # The url from where the 'config.vm.box' box will be fetched if it
    # doesn't already exist on the user's system.
    host.vm.box_url = "http://puppet-vagrant-boxes.puppetlabs.com/centos-64-x64-vbox4210.box"

    # Create a private network, which allows host-only access to the machine
    # using a specific IP.
    host.vm.network :private_network, ip: "192.168.50.11"
    host.vm.hostname = "puppetagent.edina.ac.uk"

    # Provider-specific configuration so you can fine-tune various
    # backing providers for Vagrant. These expose provider-specific options.
    # Example for VirtualBox:    
    host.vm.provider :virtualbox do |vb|
      # Use VBoxManage to customize the VM. For example to change memory:
      vb.customize ["modifyvm", :id, "--memory", "1048"]
    end
    
    # Enable provisioning with Puppet stand alone.  Puppet manifests
    # are contained in a directory path relative to this Vagrantfile.
    # You will need to create the manifests directory and a manifest in
    # the file ..pp in the manifests_path directory.    

    # Bootstrap the vm to install puppet, facter etc.
    host.vm.provision :shell, :path => "centos_6_x.sh"

    host.vm.provision :puppet do |puppet|
      puppet.manifests_path = "manifests"
      puppet.manifest_file  = "site.pp"
      puppet.module_path = "modules"
      puppet.options = "--verbose --debug --environment dev"

      # Puppet 3 only.
      puppet.hiera_config_path = "config/hiera.yaml"
      puppet.working_directory = "/vagrant"
    end
  end
end
