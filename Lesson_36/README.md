# Домашнее задание №36

## Условие

vagrant up должен поднимать 2 виртуалки: сервер и клиент  
на сервер должна быть расшарена директория  
на клиента она должна автоматически монтироваться при старте (fstab или autofs)  
в шаре должна быть папка upload с правами на запись  
- требования для NFS: NFSv3 по UDP, включенный firewall

Для проверки необходимо скачать из данного репозитория GitHub каталог Lesson_36 и перейти в него.  
Далее необходимо выполнить в терминале  

	vagrant up
    vagrant ssh client

    cd /var/nfs/upload # Данный каталог монтируется автоматически

    mount # Проверить параметры монтирования

При развертывании роли по непонятной причине не создавался каталог /var/nfs на клиенте. При повторном запуске роли директория создалась.
