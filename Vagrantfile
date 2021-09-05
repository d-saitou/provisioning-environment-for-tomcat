# encoding : utf-8
# -*- mode: ruby -*-
# vi: set ft=ruby :
# 
# Vagrantfile for Tomcat application provisioning environment
# 
# auther: d-saitou
# release: 2021/09/05
# 
Vagrant.configure("2") do |config|
  
  config.vm.box = "almalinux/8"
  config.vm.box_check_update = false
  
  config.vbguest.auto_update = true
  config.vbguest.no_remote = true
  #if Vagrant.has_plugin?("vagrant-vbguest")
  #  config.vbguest.auto_update = false
  #end
  
  config.ssh.insert_key = false
  
  config.vm.hostname = "almalinux8-tomcat"
  
  config.vm.network "private_network", ip: "192.168.33.11"
  #config.vm.network "public_network"
  
  config.vm.synced_folder "./sync", "/home/vagrant/sync", type: "virtualbox", mount_options: ["dmode=775,fmode=664"]
  
  config.vm.provider "virtualbox" do |vb|
    vb.name = "almalinux8-tomcat"
    vb.gui = false
    vb.cpus = "4"
    vb.memory = "3072"
    vb.customize ["modifyvm", :id, "--vram", "32", "--clipboard", "bidirectional", "--draganddrop", "bidirectional"]
  end
  
  config.vm.provision "shell", path: "sync/provision/provision.sh"
  
end
