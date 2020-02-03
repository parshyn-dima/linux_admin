#!/bin/bash
sudo yum -y install https://www.elrepo.org/elrepo-release-7.0-4.el7.elrepo.noarch.rpm
sudo rpm --import https://www.elrepo.org/RPM-GPG-KEY-elrepo.org
sudo yum -y update kernel*
sudo yum -y --enablerepo=elrepo-kernel install --skip-broken kernel-ml-{devel,headers} perf
sudo mkdir /media/VirtualBoxGuestAdditions
sudo mount -t iso9660 -o loop /home/vagrant/VBoxGuestAdditions.iso /media/VirtualBoxGuestAdditions
cd /media/VirtualBoxGuestAdditions
sudo ./VBoxLinuxAdditions.run
sudo reboot