# Домашнее задание №2
## Условие
    Добавить в Vagrantfile еще дисков
    Собрать R0/R5/R10 на выбор
    Прописать собранный рейд в конф, чтобы рейд собирался при загрузке
    Создать GPT раздел и 5 партиций
    В качестве проверки принимаются - измененный Vagrantfile, скрипт для создания рейда, 
    конф для автосборки рейда при загрузке.
    *  Доп. задание - Vagrantfile, который сразу собирает систему с подключенным рейдом.
    ** Перенести работающую систему с одним диском на RAID 1. Даунтайм на загрузку с нового диска предполагается. 
       В качестве проверки принимается вывод команды lsblk до и после и описание хода решения.
    
***За основу был взят Vagrantfile из личного кабинета [ссылка](https://github.com/erlong15/otus-linux)***

***

## Vagrantfile, который сразу собирает систему с подключенным рейдом

При запуске vagrant создает 6 дополнительных дисков по 1024Мб в домашней директории в каталоге VirtualBox VMs.
Далее запускается скрипт **create_raid10.sh**

### Скрипт create_raid10.sh

Данный скрипт:
1. Обновляет систему и устанавливает mdadm;
2. Создаёт из 6-ти дисков по 1Гб raid массив 10 уровня;
3. Записывает конфиргуацию raid массива в файл mdadm.conf;
4. Создаёт таблицу разделов gpt на raid массиве md0;
5. Создает на md0 пять одинаковых разделов md0p1-5;
6. Создаёт на разделах файловую систему ext4;
7. Создаёт директории /raid/part1-5 и монтирует туда разделы md0p1-5;
8. Добавляет записи в fstab для того, чтобы md0p1-5 монтировались автоматически при загрузке.

***

## Перенос работающей системы с одним диском на RAID 1

Для данного задания развернул ВМ из образа CentOS-7-x86_64-Minimal-1908. Диск размером 8Гб, разметка по умолчанию.

![lsblk_before](https://github.com/parshyn-dima/screens/blob/master/lesson02/lsblk_before.png)

1. Добавил второй жесткий диск 8Гб (sdb) и разметил также как первый (sda)

       parted /dev/sdb mklabel msdos
       parted /dev/sdb mkpart primary 2048s 2099199s
       parted /dev/sdb mkpart primary 2099200s 16777215s
       
2. Добавил флаг и создал новый RAID

       parted /dev/sda set 1 raid on
       parted /dev/sda set 2 raid on
       parted /dev/sdb set 1 raid on
       parted /dev/sdb set 2 raid on
       mdadm --create /dev/md0 --level=1 --raid-disks=2 missing /dev/sdb1 --metadata=1.0
       
3. Создал ФС и монтировал RAID md0, копировал /boot

       mkfs.xfs /dev/md0
       mkdir /mnt/md0
       mount /dev/md0 /mnt/md0
       yum -y install rsync
       rsync -a /boot/ /mnt/md0/
       sync
       umount /mnt/md0
       rmdir /mnt/md0
       
4. Размонтировал /boot и монтровал туда md0

       umount /boot
       mount /dev/md0 /boot
       
5. Добавил sda1 в md0

       mdadm /dev/md0 -a /dev/sda1

6. Изменил fstab, настроил, чтобы грузился с md0
7. Создал RAID 1 для sdb2, на котором находится lvm

       mdadm --create /dev/md1 --level=1 --raid-disks=2 missing /dev/sdb2 --metadata=1.0
       vgextend centos /dev/md1
       
8. Переместил sda2 в md1 и удалил

       pvmove /dev/sda2 /dev/md1
       vgreduce centos /dev/sda2
       pvremove /dev/sda2

9. Остановил службу lvm
 
       systemctl stop lvm2-lvmetad.service
       systemctl disable lvm2-lvmetad.service
       
10. Добавил раздел sda2 в md1

        mdadm /dev/md1 -a /dev/sda2

11. Сохранил конфигурацию RAID в mdadm.conf

        mdadm --examine --scan >/etc/mdadm.conf
        
12. Изменил в */etc/default/grub* параметр *GRUB_CMDLINE_LINUX*

        GRUB_CMDLINE_LINUX="rd.md.uuid=047a78d5:8ad861d2:e0dca429:424f828d rd.md.uuid=ac2439cb:e4769630:5f930b2c:623dfb77
        crashkernel=auto spectre_v2=retpoline rd.lvm.lv=centos/root rd.lvm.lv=centos/swap rhgb quiet"
        
13. Обновил grub2.cfg

        grub2-mkconfig -o /boot/grub2/grub.cfg
        
14. Переустановл grub на обоих дисках
   
        grub2-install /dev/sda
        grub2-install /dev/sdb
        
15. Ребилд initramfs

        dracut -f --mdadmconf
        
16. Перезагрузка

        reboot
        
Для выполнения этого задания использовал статьтью базы знаний RedHat https://access.redhat.com/solutions/2390831
Вывод команды lsblk после перезапуска сервера
![lsblk_after](https://github.com/parshyn-dima/screens/blob/master/lesson02/lsblk_after.png)
