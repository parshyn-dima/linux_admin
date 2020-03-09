#!/usr/bin/env bash
yum install -y redhat-lsb-core wget rpmdevtools rpm-build createrepo yum-utils gcc
cd /root/
wget https://nginx.org/packages/centos/7/SRPMS/nginx-1.16.1-1.el7.ngx.src.rpm
rpm -i /root/nginx-1.16.1-1.el7.ngx.src.rpm
wget https://www.openssl.org/source/latest.tar.gz
tar -xvf latest.tar.gz
yum-builddep -y /root/rpmbuild/SPECS/nginx.spec
sed -i 's|--with-debug|--with-openssl=/root/openssl-1.1.1d|' /root/rpmbuild/SPECS/nginx.spec
rpmbuild -bb /root/rpmbuild/SPECS/nginx.spec

yum localinstall -y /root/rpmbuild/RPMS/x86_64/nginx-1.16.1-1.el7.ngx.x86_64.rpm
systemctl start nginx
systemctl enable nginx

mkdir /usr/share/nginx/html/repo
cp /root/rpmbuild/RPMS/x86_64/nginx-1.16.1-1.el7.ngx.x86_64.rpm /usr/share/nginx/html/repo
wget https://www.percona.com/redir/downloads/percona-release/redhat/1.0-15/percona-release-1.0-15.noarch.rpm -O /usr/share/nginx/html/repo/percona-release-1.0-15.noarch.rpm
createrepo /usr/share/nginx/html/repo/

sed -i '/index  index.html index.htm;/a autoindex on;' /etc/nginx/conf.d/default.conf
nginx -t
nginx -s reload

cat >> /etc/yum.repos.d/otus.repo << EOF
[otus]
name=otus-linux
baseurl=http://localhost/repo
gpgcheck=0
enabled=1
EOF
