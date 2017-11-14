# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = '2'

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.define "hackweek_tool_dev" , primary: true do |fe|
    fe.vm.box = 'opensuse/openSUSE-42.3-x86_64'
    fe.vm.network :forwarded_port, guest: 3000, host: 3000
    fe.vm.provision :shell, path: 'bootstrap.sh'
  end

  config.vm.provider :virtualbox do |vb|
    vb.customize ['modifyvm', :id, '--memory', '1024']
    vb.destroy_unused_network_interfaces = true
  end
end
