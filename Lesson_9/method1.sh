#!/bin/bash
timedatectl set-timezone Europe/Moscow
yum -y install chrony
systemctl start chronyd
systemctl enable chronyd
useradd day && sudo useradd night && sudo useradd friday
echo "Otus202001" | sudo passwd --stdin day && echo "Otus202001" | sudo passwd --stdin night && echo "Otus202001" | sudo passwd --stdin friday
bash -c "sed -i 's/^PasswordAuthentication.*$/PasswordAuthentication yes/' /etc/ssh/sshd_config && systemctl restart sshd.service"
cat >> /etc/security/time.conf << EOF
*;*;day;Al0800-2000
*;*;night;!Al0800-2000
*;*;friday;Fr
EOF
file='/etc/pam.d/sshd'
if grep -q "pam_nologin.so" "$file"; then
  cat $file | grep "pam_nologin.so" | awk '{print $2}' | sed -i 's|\*|required|' $file
  sed -i '/pam_nologin.so/a account required pam_time.so' $file
else
  echo "account required pam_nologin.so" >> $file
  sed -i '/pam_nologin.so/a account required pam_time.so' $file
fi


file='/etc/pam.d/system-auth' 
if grep -q "pam_unix.so" "$file"; then
  cat $file | grep "pam_unix.so" | awk '{print $2}' | sed -i 's|\*|required|' $file
  sed -i '/pam_unix.so/a account required pam_time.so' $file
else
  echo "account required pam_unix.so" >> $file
  sed -i '/pam_unix.so/a account required pam_time.so' $file
fi