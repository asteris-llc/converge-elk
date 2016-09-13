# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "centos/7"
  config.vm.synced_folder ".", "/vagrant", type: "rsync", rsync__exclude: ".git/"
  config.vm.network "forwarded_port", guest: 5601, host: 5601

  # change the source to a linux_amd64 converge binary
  config.vm.provision "file", source: "/Users/ryan/Projects/golang/src/github.com/asteris-llc/converge/build/converge_0.1.1_linux_amd64/converge", destination: "converge"

  config.vm.provision "shell", inline: "mv converge /usr/local/bin; sudo /usr/local/bin/converge apply --local --log-level=info /vagrant/elk.hcl"
end
