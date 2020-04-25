# Домашнее задание №18

		Настроить дашборд с 4-мя графиками
		1) память
		2) процессор
		3) диск
		4) сеть

		настроить на одной из систем
		- zabbix (использовать screen (комплексный экран))
		- prometheus - grafana
	
		* использование систем примеры которых не рассматривались на занятии

## Prometheus+Grafana

Для Prometheus+Grafana создал роли на ansible.
Для проверки необходимо скачать из данного репозитория GitHub каталог Lesson_16 и перейти в него.
Далее необходимо выполнить в терминале

		vagrant up

После того как ВМ развернутся
**Prometheus** будет доступен по адресу

		http://192.168.11.21:9090/graph

**Grafana**

		http://192.168.11.21:3000

Далее с помошью импорта добавил дашборд в *grafana*. Дашборд взял тот, который рассматривали на лекции.

![Prometheus+Grafana](https://github.com/parshyn-dima/screens/blob/master/lesson18/Prometheus%2BGrafana.png)

## Zabbix
### Сервер
На одну виртуальную машину установил Zabbix 4.4 по мануалу с официального сайта [ссылка](https://www.zabbix.com/ru/download?zabbix=4.4&os_distribution=red_hat_enterprise_linux&os_version=7&db=mysql&ws=apache)

Столкнулся с тем, что в документации не описана установка mysql. То есть идет установка сервера, а затем сразу создание БД.
Установил mariadb.

		yum install mariadb-server
		systemctl start mariadb
		systemctl enable mariadb

Также сервер не запускался пока не отключил selinux. Не стал "курить" мануал по данному вопросу )

### Клиент
Репозиторий на клиента ставить такой же как и для сервера

		yum -y install zabbix-agent

Отредактировать /etc/zabbix/zabbix_agentd.conf

		Server=192.168.1.25
		ServerActive=192.168.1.25
		Hostname=client # имя вашего узла мониторинга, которое будет указано на сервере zabbix

		systemctl start zabbix-agent
		systemctl enable zabbix-agent

На сервере Configuration -> Hosts добавил хост, который необходимо мониторить с шаблоном Template OS Linux by Zabbix agent.
На центральной консоли (Monitoring -> Dashboards -> Global View) добавил четыре новых дашборда

![Zabbix](https://github.com/parshyn-dima/screens/blob/master/lesson18/Zabbix.png)
