#!/bin/bash
#Update system
sudo yum -y update
#Install mdadm
sudo yum -y install mdadm
#Creates a raid 10 of six disks
sudo mdadm --zero-superblock --force /dev/sd{b,c,d,e,f,g}
sudo mdadm --create --verbose /dev/md0 -l 10 -n 6 /dev/sd{b,c,d,e,f,g}
#Creates mdadm.conf file
sudo mkdir /etc/mdadm/
echo "DEVICE partitions" | sudo tee -a  /etc/mdadm/mdadm.conf
sudo mdadm --detail --scan --verbose | awk '/ARRAY/ {print}' | sudo tee -a /etc/mdadm/mdadm.conf
#Creates partition table 
sudo parted -s /dev/md0 mklabel gpt
sudo parted /dev/md0 mkpart primary ext4 0% 20%
sudo parted /dev/md0 mkpart primary ext4 20% 40%
sudo parted /dev/md0 mkpart primary ext4 40% 60%
sudo parted /dev/md0 mkpart primary ext4 60% 80%
sudo parted /dev/md0 mkpart primary ext4 80% 100%
#Creates file system
for i in {1..5}; do sudo mkfs.ext4 /dev/md0p$i; done
#Creates directories and mounts partitions to created directories
sudo mkdir -p /raid/part{1,2,3,4,5}
for i in {1..5}; do sudo mount /dev/md0p$i /raid/part$i; done
#Add record in /etc/fstab
#for i in {1..5}; do echo /dev/md0p$i /raid/part$i ext4 defaults 0 0 | sudo tee -a /etc/fstab; done
for i in {1..5}
do
UUID=$(sudo blkid /dev/md0p$i -sUUID -ovalue)
echo UUID=$UUID /raid/part$i ext4 defaults 0 0 | sudo tee -a /etc/fstab
done