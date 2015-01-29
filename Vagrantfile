# -*- mode: ruby -*-
# vi: set ft=ruby :

# Versão da API
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  
# Nome da box
  config.vm.box = "python"

#URL da box CentOS 5.9 64 bits 
  config.vm.box_url = "http://puppet-vagrant-boxes.puppetlabs.com/centos-64-x64-vbox4210.box"

#Hostname da máquina
  config.vm.hostname = "python-desenv"


#Puppet
  if Vagrant.has_plugin?("vagrant-librarian-puppet")
    config.librarian_puppet.puppetfile_dir = "librarian"
  end

  if Vagrant.has_plugin?("vagrant-cachier")
    config.cache.scope = :box
  end
  
#Usando DHCP para rede
  config.vm.network "private_network", type: "dhcp"
  
#Habilitando SSH
  config.ssh.forward_agent = true

#Usando Puppet para provisionar as configurações
  config.vm.provision "puppet" do |puppet|
      puppet.manifests_path = "manifests"
      puppet.manifest_file = "init.pp"
    end
 

end