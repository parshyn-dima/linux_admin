#!/bin/bash
yum install -y mailx
mkdir /var/log/nginx
wget https://github.com/parshyn-dima/linux_admin/blob/master/Lesson_4/logs/access-otus.log
sed -i "s|[0-9][0-9]/Aug|$to_date|g" access-otus.log
mkdir /vagrant/script/
wget https://github.com/parshyn-dima/linux_admin/blob/master/Lesson_4/scripts/nginx_parser.sh
wget https://github.com/parshyn-dima/linux_admin/blob/master/Lesson_4/scripts/send_mail_logs.sh
cp /vagrant/script/send_mail_logs.sh /etc/cron.horly/