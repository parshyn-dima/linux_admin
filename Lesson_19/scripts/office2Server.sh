#!/usr/bin/env bash
sudo nmcli con mod "System eth0" ipv4.never-default yes
sudo nmcli con up "System eth0"
sudo nmcli con mod "System eth1" ipv4.gateway 192.168.253.2 ipv4.dns 8.8.8.8
sudo nmcli con up "System eth1"