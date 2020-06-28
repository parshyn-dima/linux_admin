cd /vagrant
script borg-baackup
sudo su - borg
ssh borg@backup hostname
borg init -e none borg@backup:server-etc
exit
sudo su -
bash /home/borg/backup-data.sh
bash /etc/cron.hourly/backup-data-cron.sh
sudo run-parts /etc/cron.hourly
sudo su - borg
borg list backup:server-etc
mkdir /tmp/backup
borg mount backup:server-etc::etc-2020-06-28_09:32:55 /tmp/backup/
cat /tmp/backup/etc/hosts


borg create --stats --progress borg@backup:server-etc::"etc-{now:%Y-%m-%d_%H:%M:%S}" /etc

# server
sudo useradd -m borg
sudo su - borg
mkdir .ssh
chmod 700 .ssh

# backup
sudo useradd -m borg
sudo su - borg
mkdir .ssh
chmod 700 .ssh
touch .ssh/authorized_keys

bash /etc/cron.hourly/backup-data.sh >> /var/log/borg/backup.log 2>&1
