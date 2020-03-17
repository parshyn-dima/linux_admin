#!/bin/bash
for pkg in epel-release pam_script; do yum install -y $pkg; done
file='/etc/pam.d/sshd'
if grep -q "pam_nologin.so" "$file"; then
  cat $file | grep "pam_nologin.so" | awk '{print $2}' | sed -i 's|\*|required|' $file
  sed -i '/pam_nologin.so/a account required pam_script.so /vagrant/scripts/test_login.sh' $file
else
  echo "account required pam_nologin.so" >> $file
  sed -i '/pam_nologin.so/a account required pam_script.so /vagrant/scripts/test_login.sh' $file 
fi