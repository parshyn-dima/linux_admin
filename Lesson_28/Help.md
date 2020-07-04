Virtual Hosts
Размещение нескольких сайтов на одном сервере

IP-based
на каждом IP один сайт
Name-based
на одном IP несколько сайтов

Keep-alive

Cookies
Set-Cookie: name=newvalue; expires=date; path=/; domain=.example.org.

{} - контекст
В {} указываются директивы
Строки с директивами должны оканчиваться на точку с запятой
/etc/nginx/nginx.conf - Основной файл конфигурации

Директивы, которые не входят ни в один контекс, говорят, что они находятся в контексте main

Скопировал файлы на сервер
scp -r Moderna/ dparshin@84.201.143.72:/home/dparshin

Узнать какая ОС
cat /etc/os-release

dnf -y update
dnf -y install epel-release
dnf -y install nginx vim

ОБЯЗАТЕЛЬНО РЕШИТЬ ВОПРОС С SELINUX!!!!!!

В контексте *http* мы создаём контекст *server* (это виртуальные хосты). То есть можно создать много контекстов server, указав в них разные директивы listen и server_name.
При вводе http адреса, из запроса берется заголовок Hosts и сравнивается с директивами server_name.