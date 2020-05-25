#!/usr/bin/env bash
sudo nmcli dev dis eth0
cd /vagrant/
ansible-playbook provision.yml