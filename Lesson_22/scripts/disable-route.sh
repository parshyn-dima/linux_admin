sudo yum -y install tcpdump
sudo nmcli con mod "System eth0" ipv4.never-default yes
sudo nmcli con up "System eth0"