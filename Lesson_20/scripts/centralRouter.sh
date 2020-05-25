#!/usr/bin/env bash
if grep -q "net.ipv4.ip_forward" /etc/sysctl.conf; then
echo "forwarding configured"
else
sudo echo net.ipv4.ip_forward=1 >> /etc/sysctl.conf
sudo sysctl -p
fi
sudo nmcli con mod "System eth0" ipv4.never-default yes
sudo nmcli con up "System eth0"
sudo nmcli con mod "System eth1" ipv4.gateway 192.168.255.1
sudo nmcli con up "System eth1"
sudo nmcli con mod "System eth2" +ipv4.routes "192.168.2.0/24 192.168.254.2"
sudo nmcli con up "System eth2"
sudo nmcli con mod "System eth3" +ipv4.routes "192.168.1.0/24 192.168.253.2"
sudo nmcli con up "System eth3"
#sudo ip route add 192.168.2.0/24 via 192.168.254.2 dev eth2
#sudo ip route add 192.168.1.0/24 via 192.168.253.2 dev eth3