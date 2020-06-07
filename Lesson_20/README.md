# Домашнее задание №20

1) Реализовать knocking port
   centralRouter может попасть на ssh inetrRouter через knock скрипт

2) Добавить inetRouter2, который виден(маршрутизируется (host-only тип сети для виртуалки)) с хоста или форвардится порт через локалхост
3) Запустить nginx на centralServer
4) Пробросить 80й порт на inetRouter2 8080
5) Дефолт в инет оставить через inetRouter


## Схема сети

![Схема сети](https://github.com/parshyn-dima/screens/blob/master/lesson20/Otus%20-firewallv2.png)

Для проверки необходимо скачать из данного репозитория GitHub каталог Lesson_20 и перейти в него. Далее необходимо выполнить в терминале

    vagrant up

После развертывания всех ВМ, необходимо по ssh подключаться к ВМ centralServer.

    vagrant ssh centralServer

### Проверка knocking port

Для начала необходимо проверить доступ по ssh

    ssh 192.168.255.1

Для открытия ssh на inetRouter

    bash /vagrant/scripts/knock.sh open

Доступ по ssh на inetRouter открыт

    ssh 192.168.255.1
    exit

Закрыть доступ по ssh на inetRouter

    bash /vagrant/scripts/knock.sh close

### Проброс порта

Для проверки на гостевой машине можно использовать браузер или curl.

Браузер: **http://localhost:8080/**

CURL: **curl -I localhost:8080/**
