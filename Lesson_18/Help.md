# Установка и настройка Prometheus

## Создание пользователя

useradd prometheus --comment "Prometheus server user" --shell /bin/false

## Установка

yum -y install wget
cd /tmp
wget https://github.com/prometheus/prometheus/releases/download/v2.17.2/prometheus-2.17.2.linux-amd64.tar.gz
tar xvfz prometheus-2.17.2.linux-amd64.tar.gz
cd prometheus-2.17.2.linux-amd64
mv prometheus /usr/local/bin/

## Каталог для конфигурационных файлов

mkdir /etc/prometheus
cp prometheus.yml /etc/prometheus/
chown -R prometheus:prometheus /etc/prometheus

## Создаем каталог для Prometheus DB

mkdir /var/lib/prometheus
chown prometheus:prometheus /var/lib/prometheus

Создадим файл со списком ключей для запуска Prometheus. Для того, чтобы каждый раз не перечитывать настройки systemd, список ключей вынесен
в файл: /etc/sysconfig/prometheus

cat <<EOF>> /etc/sysconfig/prometheus
OPTIONS="--config.file=/etc/prometheus/prometheus.yml \
--storage.tsdb.path=/var/lib/prometheus/"
EOF

## Создаем systemd сервис

cat <<EOF>> /usr/lib/systemd/system/prometheus.service
[Unit]
Description=Prometheus Server
Documentation=https://github.com/prometheus/prometheus
[Service]
Restart=always
User=prometheus
Group=prometheus
EnvironmentFile=/etc/sysconfig/prometheus
ExecStart=/usr/local/bin/prometheus \$OPTIONS
ExecReload=/bin/kill -HUP \$MAINPID
TimeoutStopSec=20s
SendSIGKILL=no
[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl start prometheus
systemctl enable prometheus

## Проверка

curl -XGET -IL http://localhost:9090/graph

## Утилита для тестирования конфигурационных файлов

cp promtool /usr/local/bin/
Для проверки конфигурационного файла запускаем команду:
promtool check config /etc/prometheus/prometheus.yml

