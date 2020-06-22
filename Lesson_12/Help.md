yum -y install epel-release setools-console selinux-policy-devel policycoreitils-python setroubleshoot
yum -y install nginx

server {
    listen 8000 default_server;
    server_name default_server;
    root /usr/share/nginx/html;

    location / {
    }
}

ls -Z /usr/sbin/nginx
vi /etc/nginx/conf.d/default.conf
systemctl restart nginx
systemctl status nginx
tail -f /var/log/audit/audit.log 
audit2why < /var/log/audit/audit.log
grep http /var/log/audit/audit.log | audit2why
sealert -a /var/log/audit/audit.log





















#### SELinux: проблема с удаленным обновлением зоны DNS

Инженер настроил следующую схему:

- ns01 - DNS-сервер (192.168.50.10);
- client - клиентская рабочая станция (192.168.50.15).

При попытке удаленно (с рабочей станции) внести изменения в зону ddns.lab происходит следующее:
```bash
[vagrant@client ~]$ nsupdate -k /etc/named.zonetransfer.key
> server 192.168.50.10
> zone ddns.lab
> update add www.ddns.lab. 60 A 192.168.50.15
> send
update failed: SERVFAIL
>
```
Инженер перепроверил содержимое конфигурационных файлов и, убедившись, что с ними всё в порядке, предположил, что данная ошибка связана с SELinux.

В данной работе предлагается разобраться с возникшей ситуацией.


#### Задание

- Выяснить причину неработоспособности механизма обновления зоны.
- Предложить решение (или решения) для данной проблемы.
- Выбрать одно из решений для реализации, предварительно обосновав выбор.
- Реализовать выбранное решение и продемонстрировать его работоспособность.


#### Формат

- README с анализом причины неработоспособности, возможными способами решения и обоснованием выбора одного из них.
- Исправленный стенд или демонстрация работоспособной системы скриншотами и описанием.


