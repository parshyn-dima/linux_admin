Добавил в /etc/hosts
echo "192.168.11.13 ipa.otus.local ipa" | sudo tee -a /etc/hosts

sudo yum -y install ipa-server ipa-server-dns bind bind-dyndb-ldap

sudo ipa-server-install