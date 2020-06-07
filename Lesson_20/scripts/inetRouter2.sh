#!/usr/bin/env bash
if grep -q "net.ipv4.ip_forward" /etc/sysctl.conf; then
echo "forwarding configured"
else
sudo echo net.ipv4.ip_forward=1 >> /etc/sysctl.conf
sudo sysctl -p
fi
sudo nmcli con mod "System eth1" +ipv4.routes "192.168.0.0/16 192.168.252.1"
sudo nmcli con up "System eth1"
sudo nmcli con mod "System eth1" ipv4.gateway 192.168.252.1 ipv4.dns 8.8.8.8
sudo nmcli con up "System eth1"
sudo nmcli con mod "System eth0" ipv4.never-default yes
sudo nmcli con up "System eth0"
sudo iptables -t nat -A PREROUTING -p tcp --dport 80 -j DNAT --to-destination 192.168.0.2:8080
sudo iptables -t nat -A POSTROUTING --destination 192.168.0.2/16 -j SNAT --to-source 192.168.252.2