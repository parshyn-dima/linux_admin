#!/bin/bash
sudo yum install -y mailx
cd /vagrant/logs/
to_date=$(date +"%d/%b")
sed -i "s|[0-9][0-9]/Aug|$to_date|g" access-otus.log
sudo cp /vagrant/scripts/send_mail_logs.sh /etc/cron.hourly/