# Домашнее задание №23

    взять стенд https://github.com/erlong15/vagrant-bind
    добавить еще один сервер client2
    завести в зоне dns.lab имена
    web1 - смотрит на клиент1
    web2 - смотрит на клиент2
    завести еще одну зону newdns.lab
    завести в ней запись
    www - смотрит на обоих клиентов
    настроить split-dns
    клиент1 - видит обе зоны, но в зоне dns.lab только web1
    клиент2 - видит только dns.lab

## Проверка

Для проверки необходимо скачать из данного репозитория GitHub каталог Lesson_23 и перейти в него. Далее необходимо выполнить в терминале

    vagrant up
    
### Клиент №1

    vagrant ssh client1
    
*Клиент1 видит web1*
    
    dig +noall +answer web1.dns.lab
    
*Клиент1 не видит web2*
    
    dig +noall +answer web2.dns.lab
    
*Клиент1 видит зону newdns*
    
    dig +noall +answer www.newdns.lab
    
*PTR записи видны в newdns.lab, но в зоне dns.lab видно только web1*
    
    dig +noall +answer -x 192.168.50.16

*Те же команды но в качестве сервера имен используется slave dns, ns02*
    
    dig +noall +answer @192.168.50.11 web1.dns.lab
    dig +noall +answer @192.168.50.11 web2.dns.lab
    dig +noall +answer @192.168.50.11 www.newdns.lab
    dig +noall +answer @192.168.50.11 -x 192.168.50.16
    exit
    
### Клиент №2

    vagrant ssh client2
    
*Клиент2 видит dns.lab*

    dig +noall +answer web1.dns.lab
    dig +noall +answer web2.dns.lab
    
*Клиент2 не видит зону newdns.lab*

    dig +noall +answer www.newdns.lab
    
*PTR записи также отображаются только для зоны dns.lab*

    dig +noall +answer -x 192.168.50.15
    dig +noall +answer -x 192.168.50.16
    
*Те же команды но в качестве сервера имен используется slave dns, ns02*
    
    dig +noall +answer @192.168.50.11 web1.dns.lab
    dig +noall +answer @192.168.50.11 web2.dns.lab
    dig +noall +answer @192.168.50.11 www.newdns.lab
    dig +noall +answer @192.168.50.11 -x 192.168.50.16
    exit
