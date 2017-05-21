# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/zesty64"
  config.vm.network "forwarded_port", guest: 4000, host: 4000, host_ip: "127.0.0.1"
  config.ssh.forward_agent = true

  config.vm.provision :shell, :inline => <<-EOT
     echo LANG="en_US.utf8" > /etc/default/locale
     echo LANGUAGE="en_US:" >> /etc/default/locale
     echo LC_ALL="en_US.UTF-8" >> /etc/default/locale
     sudo apt-get install python -y
  EOT

  config.vm.provision :ansible do |ansible|
    ansible.playbook = "setup/playbook.yml"
  end
end
