#!/bin/bash
sudo yum install -y mailx
cd /vagrant/logs/
to_date=$(date +"%d/%b/%G")
sed -i "s|[0-9][0-9]/Aug/2019|$to_date|g" access-otus.log
sudo cp /vagrant/scripts/send_mail_logs.sh /etc/cron.hourly/