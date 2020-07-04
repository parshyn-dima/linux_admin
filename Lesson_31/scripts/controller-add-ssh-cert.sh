#!/usr/bin/env bash
sudo yum -y install wget
if [ ! -f /home/vagrant/.ssh/id_rsa ]; then
    wget --no-check-certificate https://raw.githubusercontent.com/mitchellh/vagrant/master/keys/vagrant -O /home/vagrant/.ssh/id_rsa
    wget --no-check-certificate https://raw.githubusercontent.com/mitchellh/vagrant/master/keys/vagrant.pub -O /home/vagrant/.ssh/id_rsa.pub
    chmod 600 /home/vagrant/.ssh/id_*
fi