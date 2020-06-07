#!/usr/bin/env bash
if grep -q "net.ipv4.ip_forward" /etc/sysctl.conf; then
echo "forwarding configured"
else
sudo echo net.ipv4.ip_forward=1 >> /etc/sysctl.conf
sudo sysctl -p
fi
sudo nmcli con mod "System eth1" +ipv4.routes "192.168.0.0/16 192.168.255.2"
sudo nmcli con up "System eth1"
iptables -t nat -A POSTROUTING ! -d 192.168.0.0/16 -o eth0 -j MASQUERADE
iptables -A INPUT -p tcp --dport 22 -i eth1 -j REJECT
cd /tmp/
yum install -y http://li.nux.ro/download/nux/misc/el6/i386/knock-server-0.5-7.el6.nux.i686.rpm
cp /vagrant/files/knockd.conf /etc/knockd.conf
systemctl start knockd