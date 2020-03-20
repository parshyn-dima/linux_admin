# Домашнее задание №10
## Условие

        Подготовить стенд на Vagrant как минимум с одним сервером. На этом сервере используя Ansible необходимо развернуть nginx со следующими условиями:
        - необходимо использовать модуль yum/apt
        - конфигурационные файлы должны быть взяты из шаблона jinja2 с перемененными
        - после установки nginx должен быть в режиме enabled в systemd
        - должен быть использован notify для старта nginx после установки
        - сайт должен слушать на нестандартном порту - 8080, для этого использовать переменные в Ansible
        * Сделать все это с использованием Ansible роли

Для проверки необходимо скачать из данного репозитория GitHub каталог Lesson_10 и перейти в него. Также на хостовой машине должен быть установлен *ansible*. 
Далее необходимо выполнить в терминале

        vagrant up

После развертывания ВМ необходимо выполнить команду

        ansible-playbook -i production/hosts.yml nginx.yml

