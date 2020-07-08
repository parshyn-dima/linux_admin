#!/usr/bin/env bash
sudo cp /usr/share/zoneinfo/Europe/Moscow /etc/localtime
sudo yum -y install chrony vim
sudo systemctl enable chronyd
sudo systemctl start chronyd
sudo yum -y install epel-release
sudo yum -y install ansible