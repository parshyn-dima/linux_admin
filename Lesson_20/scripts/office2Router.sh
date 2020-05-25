if grep -q "net.ipv4.ip_forward" /etc/sysctl.conf; then
echo "forwarding configured"
else
sudo echo net.ipv4.ip_forward=1 >> /etc/sysctl.conf
sudo sysctl -p
fi
sudo nmcli con mod "System eth0" ipv4.never-default yes
sudo nmcli con up "System eth0"
sudo nmcli con mod "System eth1" ipv4.gateway 192.168.253.1
sudo nmcli con up "System eth1"