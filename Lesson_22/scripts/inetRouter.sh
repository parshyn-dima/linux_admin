#!/usr/bin/env bash
if grep -q "net.ipv4.ip_forward" /etc/sysctl.conf; then
echo "forwarding configured"
else
sudo echo net.ipv4.ip_forward=1 >> /etc/sysctl.conf
sudo sysctl -p
fi
systemctl start firewalld
systemctl enable firewalld
firewall-cmd --change-interface=eth0 --zone=external --permanent
firewall-cmd --complete-reload
sudo nmcli con mod "System eth1" +ipv4.routes "192.168.0.0/16 192.168.255.2"
sudo nmcli con up "System eth1"