# Домашнее задание №31
## Условие

1. Установить в виртуалке postfix+dovecot для приёма почты на виртуальный домен любым обсужденным на семинаре способом  
2. Отправить почту телнетом с хоста на виртуалку  
3. Принять почту на хост почтовым клиентом  

Результат  
1. Полученное письмо со всеми заголовками  
2. Конфиги postfix и dovecot  

## Проверка

Для проверки необходимо скачать из данного репозитория GitHub каталог Lesson_31 и перейти в него. Далее необходимо выполнить в терминале

    vagrant up

### Отправить почту телнетом с хоста на виртуалку

    telnet localhost 10025

    ehlo mail.otus.local
    mail from: admin@dparshin.ru
    rcpt to: vagrant@mail.otus.local
    data
    subject: Test mail from telnet
    OTUS!
    .
    quit

Данное письмо можно посмотреть на mail сервере

    vagrant ssh mail -c 'cat /var/spool/mail/vagrant'

![mail-server](https://github.com/parshyn-dima/screens/blob/master/Lesson_31/mail-server.png)

### Принять почту на хост почтовым клиентом (thunderbird)

![thunderbird](https://github.com/parshyn-dima/screens/blob/master/Lesson_31/thunderbird.png)