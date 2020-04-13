#!/bin/bash
mkdir /usr/lib/dracut/modules.d/01test
cp /vagrant/scripts/module-setup.sh /usr/lib/dracut/modules.d/01test/
cp /vagrant/scripts/test.sh /usr/lib/dracut/modules.d/01test/
mkinitrd -f -v /boot/initramfs-$(uname -r).img $(uname -r)
grubby --remove-args="rhgb quiet" --update-kernel /boot/vmlinuz-$(uname -r)