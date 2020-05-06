man nmcli-examples

**/etc/sysconfig/network-scripts** - глобальные настройки
**/etc/networkmanager/system-connections** - VPN, PPoE
**/etc/sysconfig/network-scripts/ifcfg-<имя_соединения>** - настройки сетевых интерфейсов
Если были внесены изменения в файл ifcfg-*, чтобы NM перечитал их, необходимо

        nmcli connection reload - все
        nmcli con load /etc/sysconfig/network-scripts/ifcfg-<имя_соединения> - конкретный

nmcli [OPTIONS] OBJECT {COMMAND | help}
OBJECT:
    general
    networking
    radio
    connection
    device
    agent
    monitor

**ip -c link show** - показать существующие адаптеры

nmcli connection show
nmcli device status

После внесения изменений

inetRouter
1) Настроить интерфейс enp0s8
nmcli con mod "eth1" connection.autoconnect yes ipv4.method manual ipv4.address 192.168.255.1/30
2)  Включить форвардинг между интерфейсами
vi /etc/sysctl.conf
net.ipv4.ip_forward=1
sysctl -p

        echo net.ipv4.ip_forward=1 >> /etc/sysctl.conf
        sysctl -p

3) Обратный маршрут

        nmcli con mod eth1 +ipv4.routes "192.168.0.0.0/16 192.168.255.2"
        nmcli con reload

Добавить обратный маршрут, так как если его не добавить пакеты не смогут обратно вернуться. Можно указать сразу 192.168.0.0/16, чтобы не указывать сети по отдельности
ip route add 192.168.0.0/16 via 192.168.255.2

4) Так как в vagrant firewall отключен, то данные команды использовать не буду        
firewall-cmd --change-interface=enp0s3 --zone=external --permanent
firewall-cmd --complete-reload
Проверка
firewall-cmd --get-zone-of-interface=enp0s3


centralRouter
nmcli con mod "eth1" connection.autoconnect yes ipv4.method manual ipv4.address 192.168.255.2/30 ipv4.gateway 192.168.255.1
nmcli con mod "eth1" +ipv4.dns 8.8.8.8
nmcli con reload
nmcli dev disconnect "eth0" 

Переименовать через nmcli
nmcli connection modify "Wired connection 1" connection.id "enp0s8"

