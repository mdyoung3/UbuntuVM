# -*- mode: ruby -*-
# vi: set ft=ruby :
# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "ubuntu/trusty64"
  config.vm.provision :shell, path: "bash/bootstrap.sh"
  config.vm.network :forwarded_port, host: 4567, guest: 80
  config.ssh.forward_agent = true
  config.vm.provider "virtualbox" do |v| 
    v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"] 
    v.customize ["modifyvm", :id, "--natdnsproxy1", "on"] 
    v.memory = 2028
    v.cpus = 2
  end
end
