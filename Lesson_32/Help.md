    sudo su -

При установке пароль root в /var/log/mysqld.log

    cat /var/log/mysqld.log | grep pass

 Установить новый пароль, должен быть более 12 сиволов!

    mysql_secure_installation

Вход с новым паролем

    mysql -u root -p

Можно создать файл **.my.cnf** в домашней директории и вводить пароль каждый раз (только для тестовых конфигураций)

    [client]
    password="<password>"

