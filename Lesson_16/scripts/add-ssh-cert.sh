#!/usr/bin/env bash
sudo yum -y install wget
wget --no-check-certificate https://raw.githubusercontent.com/mitchellh/vagrant/master/keys/vagrant.pub -O /tmp/id_rsa.pub
cat /tmp/id_rsa.pub >> /home/vagrant/.ssh/authorized_keys