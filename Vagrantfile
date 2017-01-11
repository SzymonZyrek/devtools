# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "debian/jessie64"
  config.vm.provider :virtualbox do |vb|
	  vb.gui = true
	  vb.memory = "4096"
	  config.vm.synced_folder ".", "/vagrant", type: "virtualbox"
  end
  
  config.vm.provision :shell, path: "installPackages.sh"
  
  
  # forwarded ports:
  # config.vm.network "forwarded_port", guest: 80, host: 8080

  # private network (for host-guest only communication):
  # config.vm.network "private_network", ip: "192.168.33.10"

  # public networks (make machine appear as new host in the network)
  # config.vm.network "public_network"

  # additional shares 
  # config.vm.synced_folder "../data", "/vagrant_data"
end
