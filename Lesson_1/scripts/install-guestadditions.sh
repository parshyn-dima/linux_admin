#!/bin/bash
sudo mkdir /media/VirtualBoxGuestAdditions
sudo mount -t iso9660 -o loop /home/vagrant/VBoxGuestAdditions.iso /media/VirtualBoxGuestAdditions
sudo rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
sudo yum install -y gcc kernel-devel kernel-headers dkms make bzip2 perl
sudo cd /media/VirtualBoxGuestAdditions
sudo ./VBoxLinuxAdditions.run
sudo reboot