#!/bin/bash
sudo yum -y update
sudo yum -y install mdadm smartmontools hdparm gdisk

sudo mdadm --zero-superblock --force /dev/sd{b,c,d,e,f,g}
sudo mdadm --create --verbose /dev/md0 -l 10 -n 6 /dev/sd{b,c,d,e,f,g}

sudo mkdir /etc/mdadm/
echo "DEVICE partitions" | sudo tee -a  /etc/mdadm/mdadm.conf
sudo mdadm --detail --scan --verbose | awk '/ARRAY/ {print}' | sudo tee -a /etc/mdadm/mdadm.conf

sudo parted -s /dev/md0 mklabel gpt
sudo parted /dev/md0 mkpart primary ext4 0% 100%
for i in $(seq 1); do sudo mkfs.ext4 /dev/md0p$i; done

sudo mkdir -p /data
sudo mount /dev/md0p1 /data

UUID=$(blkid /dev/md0p1 -sUUID -ovalue)
echo UUID=$UUID /data ext4 defaults 0 0 | sudo tee -a /etc/fstab