#!/usr/bin/env bash
sudo nmcli con mod "System eth0" ipv4.never-default yes
sudo nmcli con up "System eth0"
sudo nmcli con mod "System eth1" ipv4.gateway 192.168.0.1 ipv4.dns 8.8.8.8
sudo nmcli con up "System eth1"
sudo yum -y install epel-release
sudo yum -y install nginx
sudo sed -i 's/80 default_server/8080 default_server/g' /etc/nginx/nginx.conf
sudo systemctl enable --now nginx