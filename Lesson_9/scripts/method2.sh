#!/bin/bash
useradd user && useradd admin && groupadd admins && usermod -aG admins admin && usermod -aG admins vagrant
echo "Otus202001" | passwd --stdin user && echo "Otus202001" | passwd --stdin admin
bash -c "sed -i 's/^PasswordAuthentication.*$/PasswordAuthentication yes/' /etc/ssh/sshd_config && systemctl restart sshd.service"
for file in '/etc/pam.d/sshd' '/etc/pam.d/login'
do
if grep -q "pam_nologin.so" "$file"; then
  cat $file | grep "pam_nologin.so" | awk '{print $2}' | sed -i 's|\*|required|' $file
  sed -i '/pam_nologin.so/a account required pam_exec.so /usr/local/bin/test_login.sh' $file
else
  echo "account required pam_nologin.so" >> $file
  sed -i '/pam_nologin.so/a account required pam_exec.so /usr/local/bin/test_login.sh' $file 
fi
done
cp /vagrant/scripts/test_login.sh /usr/local/bin/