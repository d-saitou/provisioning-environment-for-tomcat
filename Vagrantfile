# encoding : utf-8
# -*- mode: ruby -*-
# vi: set ft=ruby :
# 
# Vagrantfile for Tomcat 8 application provisioning environment
# 
# auther: d-saitou
# version: 1.00
# release: 2018/05/02
# 
# environments:
#  Vagrant: 1.9.8 -> 2.1.1
#  VirtualBox: 5.1.26 -> 5.2.12
Vagrant.configure("2") do |config|
  
  # using box
  config.vm.box = "centos/6"
  
  # box update check
  config.vm.box_check_update = false
  
  # auto update Virtualbox Guest Additions
  config.vbguest.auto_update = true
  config.vbguest.no_remote = true
  
  # ssh config
  config.ssh.insert_key = false
  
  # hostname
  config.vm.hostname = "centos6-tomcat8"
  
  # private network (host-only)
  config.vm.network "private_network", ip: "192.168.33.11"
  
  # public network (bridged)
  #config.vm.network "public_network"
  
  # synced directory
  config.vm.synced_folder "./sync", "/home/vagrant/sync", type: "virtualbox"
  
  # vm config
  config.vm.provider "virtualbox" do |vb|
    # vm name
    vb.name = "centos6-tomcat8"
    # using gui
    vb.gui = false
    # system resource
    vb.cpus = "2"
    vb.memory = "2048"
    # customize
    vb.customize ["modifyvm", :id, "--vram", "32", "--clipboard", "bidirectional", "--draganddrop", "bidirectional"]
    # dvd drive
    vb.customize ["storageattach", :id, "--storagectl", "IDE", "--port", "0", "--device", "1", "--type", "dvddrive", "--medium", "emptydrive"]
  end
  
  # provisioning
  config.vm.provision "shell", path: "sync/provision/provision.sh"
  
end
