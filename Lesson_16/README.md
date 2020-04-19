# Домашнее задание №16
## Условие

    в вагранте поднимаем 2 машины web и log
    на web поднимаем nginx
    на log настраиваем центральный лог сервер на любой системе на выбор
    - journald
    - rsyslog
    - elk
    настраиваем аудит следящий за изменением конфигов нжинкса
    все критичные логи с web должны собираться и локально и удаленно
    все логи с nginx должны уходить на удаленный сервер (локально только критичные)
    логи аудита должны также уходить на удаленную систему

Для проверки необходимо скачать из данного репозитория GitHub каталог Lesson_16 и перейти в него.
Далее необходимо выполнить в терминале

		vagrant up

Проверка критических логов.

		vagrant ssh web
		sudo su -
		logger -p local7.crit "Test critical log"

		vagrant ssh log
		sudo su -
		tail /var/log/rsyslog/web/vagrant.log

Проверка логов nginx

		vagrant ssh log
		sudo su -

		curl -I 192.168.11.13:8080
		tail /var/log/rsyslog/web.otus.local/nginx_access.log

		curl -I 192.168.11.13:8080/web
		tail /var/log/rsyslog/web.otus.local/nginx_error.log

Проверка аудита файла nginx.conf

		vagrant ssh web
		sudo su -
		# Сделать какое-либо изменение файла конфигурации nginx
		vi /etc/nginx/nginx.conf
			
		vagrant ssh log
		sudo su -
		ausearch -k nginx_conf