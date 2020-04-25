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

# Задание с *
## Nagios Core 4.4.5

На отдельный сервер установил Nagios Core. Установка практически всех компонентов осуществляется с помощью make. Данная система использует Apache+PHP.
На клиента устанавливается отдельный агент Nagios Core Linux NRPE Agent. Клиента добавить удалось, а как добавить дашборды для его мониторинга я так и не понял.
Система крайте не запутаная )

![Nagios](https://github.com/parshyn-dima/screens/blob/master/lesson18/Nagios.png)

## NagiosXI

Обнаружил, что существует платная версия, в которой существуют дашборды из коробки (30 дней trial). Установка данной версии намного проще, запуск скрипта.

		curl https://assets.nagios.com/downloads/nagiosxi/install.sh | sh

Агент также устанавливается скриптом

		wget https://assets.nagios.com/downloads/nagiosxi/agents/linux-nrpe-agent.tar.gz
		tar xzf linux-nrpe-agent.tar.gz
		cd linux-nrpe-agent
		./fullinstall

Клиента на сервер добавил, но не смог добавить метрики CPU, Disk, Network. Документация не понравилась, очень все запутанно, нужной информации найти не смог. Форум только для тех, кто купил данную систему мониторинга. Интерфейс системы также не очень удобен.

![NagiosXI](https://github.com/parshyn-dima/screens/blob/master/lesson18/NagiosXI.png)

Не знаю зачтется ли такая работа, но дальше проводить исследования времени нет, потратил всё на данный продукт )

