# Домашнее задание №26
## Условие

1. Установить FreeIPA;  
2. Написать Ansible playbook для конфигурации клиента;  

Для проверки необходимо скачать из данного репозитория GitHub каталог Lesson_17 и перейти в него.  
Далее необходимо выполнить в терминале  

	vagrant up

Для того, чтобы иметь возможность подключиться к FreeIPA, через web, необходимо на гостевой ОС добавить в */etc/hosts*

    192.168.11.13 ipa.otus.local ipa

Добовляем пользователя **user**

![FreeIPA](https://github.com/parshyn-dima/screens/blob/master/Lesson26/FreeIPA.png)

Затем перейдя в ВМ cl01 можно убедиться, что пользователь создался и на cl01

![Client](https://github.com/parshyn-dima/screens/blob/master/Lesson26/Client.png)