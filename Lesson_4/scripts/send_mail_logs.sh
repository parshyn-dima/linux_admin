#!/bin/bash

/vagrant/scripts/mono_launch.sh /vagrant/scripts/nginx_parser.sh | mail -s "Nginx log report" root@localhost