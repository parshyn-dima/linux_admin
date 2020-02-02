#!/bin/bash
sudo yum install -y http://www.elrepo.org/elrepo-release-7.0-3.el7.elrepo.noarch.rpm
sudo yum --enablerepo elrepo-kernel install kernel-ml -y
sudo grub2-mkconfig -o /boot/grub2/grub.cfg
sudo grub2-set-default 0
sudo reboot