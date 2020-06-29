Добавил в /etc/hosts
echo "192.168.11.13 ipa.otus.local ipa" | sudo tee -a /etc/hosts

sudo yum -y install ipa-server ipa-server-dns bind bind-dyndb-ldap

sudo ipa-server-install

[ipaserver:vars]
ipaserver_domain=otus.local
ipaserver_realm=OTUS.LOCAL
ipaserver_setup_dns=yes
ipaserver_auto_forwarders=yes
ipaadmin_password=MySecretPassword123
ipadm_password=MySecretPassword234

ipa-server-install --hostname=ipa.otus.local --domain=otus.local --realm=OTUS.LOCAL --ds-password=Pa$$w0rd1 --admin-password=Pa$$w0rd1 --mkhomedir --setup-dns --forwarder=8.8.8.8 --auto-reverse --unattended

domain: "otus.local"
server: "ipa.otus.local"
realm: "OTUS.LOCAL"
admin: "administrator"
password: "Pa$$w0rd1"
dbpassword: "Pa$$w0rd1"

обновить ОС!!!
удалить из hosts 127.0.0.1

