# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

# Configure additional CPUs and Memory
  config.vm.provider "virtualbox" do |v|
      v.memory = 2048
      v.cpus = 2
  end

  config.vm.network "forwarded_port", guest: 2375, host: 2375

  #
  # Add the required puppet modules before provisioning is run by puppet
  #
  config.vm.provision :shell do |shell|
     shell.inline = "puppet module install puppetlabs-stdlib;
                     puppet module install puppetlabs-apt;
		     puppet module install puppetlabs-java;
		     puppet module install cesnet-spark;
                     puppet module install boundary-boundary;
                     exit 0"
  end

  #
  # Use Puppet to provision the VM
  #
  config.vm.provision "puppet" do |puppet|
    puppet.manifests_path = "manifests"
    puppet.manifest_file  = "site.pp"
    puppet.facter = {
      "api_token" => ENV["API_TOKEN"],
    }
  end

  config.vm.define "centos-6.6", autostart: false do |v|
    v.vm.box = "puppetlabs/centos-6.6-64-puppet"
    v.vm.box_version = "1.0.1"
    v.vm.hostname = "centos-6-6"
  end

  config.vm.define "centos-7.0", autostart: false do |v|
    v.vm.box = "puppetlabs/centos-7.0-64-puppet"
    v.vm.box_version = "1.0.1"
    v.vm.hostname = "centos-7-0"
  end

  config.vm.define "ubuntu-12.04", autostart: false do |v|
    v.vm.box = "puppetlabs/ubuntu-12.04-64-puppet"
    v.vm.box_version = "1.0.1"
    v.vm.hostname = "ubuntu-12-04"
    
    # Needed to override to change the default outside-in ordering.
    config.vm.provision "puppet" do |puppet|
      puppet.manifests_path = "manifests"
      puppet.manifest_file  = "site.pp"
      puppet.facter = {
        "api_token" => ENV["API_TOKEN"],
      }
    end

  end

  config.vm.define "ubuntu-14.04", autostart: false do |v|
    v.vm.box = "puppetlabs/ubuntu-14.04-64-puppet"
    # fix box_version until Vagrant support newer versions of puppet.
    v.vm.box_version = "1.0.1"
    v.vm.hostname = "ubuntu-14-04"
    
    # Needed to override to change the default outside-in ordering.
    config.vm.provision "puppet" do |puppet|
      puppet.manifests_path = "manifests"
      puppet.manifest_file  = "site.pp"
      puppet.facter = {
        "api_token" => ENV["API_TOKEN"],
      }
    end
  end

end
