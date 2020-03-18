#!/bin/bash
timedatectl set-timezone Europe/Moscow
yum -y install chrony
systemctl start chronyd
systemctl enable chronyd
useradd user && useradd admin && groupadd admins && usermod -aG admins admin && usermod -aG admins vagrant
echo "Otus202001" | passwd --stdin user && echo "Otus202001" | passwd --stdin admin
bash -c "sed -i 's/^PasswordAuthentication.*$/PasswordAuthentication yes/' /etc/ssh/sshd_config && systemctl restart sshd.service"
cat >> /etc/security/time.conf << EOF
login
*;*;*;!Wk0000-2400
EOF
for file in '/etc/pam.d/sshd' '/etc/pam.d/login'
do
if grep -q "pam_nologin.so" "$file"; then
  cat $file | grep "pam_nologin.so" | awk '{print $2}' | sed -i 's|\*|required|' $file
  sed -i '/pam_nologin.so/a account    [success=1 default=ignore] pam_succeed_if.so user ingroup admins' $file
  sed -i '/pam_succeed_if.so user ingroup admins/a account required pam_time.so' $file
else
  echo "account required pam_nologin.so" >> $file
  sed -i '/pam_nologin.so/a account    [success=1 default=ignore] pam_succeed_if.so user ingroup admins' $file
  sed -i '/pam_succeed_if.so user ingroup admins/a account required pam_time.so' $file
fi
done