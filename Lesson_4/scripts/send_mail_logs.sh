#!/bin/bash

/vagrant/scripts/nginx_parser.sh | mail -s "Nginx log report" root@localhost