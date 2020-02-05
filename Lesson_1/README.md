# Домашнее задание №1
## Условие
    В материалах к занятию есть методичка, в которой описана процедура обновления ядра из репозитория. 
    По данной методичке требуется выполнить необходимые действия. Полученный в ходе выполнения ДЗ 
    Vagrantfile должен быть залит в ваш репозиторий. Для проверки ДЗ необходимо прислать ссылку на него.
    Для выполнения ДЗ со * и ** вам потребуется сборка ядра и модулей из исходников.
    Критерии оценки: Основное ДЗ - в репозитории есть рабочий Vagrantfile с вашим образом.
    ДЗ со звездочкой: Ядро собрано из исходников
    ДЗ с **: В вашем образе нормально работают VirtualBox Shared Folders
    
### Для выполнения задания я установил следующее ПО:
1.  VirtualBox 6.1.2
2.  Vagrant 2.2.7
3.  Packer 1.5.1
4.  Git 2.17.1

***На других версиях ПО не тестировалось.***<br/>
***За основу были взяты части кода из репозитория доступного в личном кабинете [manual_kernel_update](https://github.com/dmitry-lyutenko/manual_kernel_update), с внесением некоторых изменений.***

***

## Развертывание ВМ с помощью Vagrant

Vagrantfile, который был предоставлен в репозитории меня не устроил, так как содержит не совсем мне понятный код,
а также при задании параметров `:net` и `:forwarded_port` выполнение ***vagrant up*** заканчивается ошибкой.
Поэтому решил сделать свой вариант. Источники нашел в открытом доступе [здесь](http://sysadm.pp.ua/linux/sistemy-virtualizacii/vagrantfile.html) и [здесь](https://github.com/erlong15/otus-linux/blob/master/Vagrantfile).

В массиве servers описываются параметры ВМ. Если добавить еще один блок {} с параметрами, vagrant создаст две ВМ.

    servers=[
      {
        :box_name => "centos/7",
        :hostname => "kernel-update",
        :cpus => 2,
        :ram => 2048
      }
    ]

После создания и старта ВМ, запускается скрипт, который находится в каталоге scripts. Данный скрипт выполняет установку ядра из репозитория и обновление конфигурации grub2.

    node.vm.provision "shell", path: "./scripts/kernel-update.sh"

Для создания ВМ на основе Vagrantfile необходимо скачать репозиторий. Перейти в каталог Lesson_1 и выполнить команду ***vagrant up***.
В результате вывод команды *uname -r* должен показать следующее:

![result vagrant](https://github.com/parshyn-dima/screens/blob/master/lesson01/vagrant-result.png)

***

## Создание образа для Vagrant с помощью Packer

Создал образ CentOS 7 с обновленным ядром. Ядро собрано из исходников, взятых с сайта https://www.kernel.org/

Для того, чтобы создать образ с помощью Packer необходимы следующие файлы:
* **centos7-virtualbox.json** - шаблон ВМ, описывается характеристики ВМ и тд.
* **ks.cfg** - файл ответов, для автоматической установки ОС. В данном задании создается образ для ОС CentOS 7.
Данные файлы были взяты из репозитория, указанного в личном кабинете и внесены некоторые изменения.

### packer provision config
Образ ОС скачивается с официального сайта https://centos.org/

    "iso_url":"http://centos-mirror.rbc.ru/pub/centos/7.7.1908/isos/x86_64/CentOS-7-x86_64-Minimal-1908.iso"
    
Так как ядро обновлял не из репозитория, пришлось увеличить объём жесткого диска до 20 Гб.

    "disk_size":"20480"
    
Количество процессоров установил 12.

    ["modifyvm", "{{.Name}}", "--cpus", "12"]
    
В секции **provisioners** задал путь к скриптам, который находятся в каталоге scripts.

    "scripts" :
         [
            "../scripts/kernel-build.sh",
            "../scripts/install-guestadditions.sh",
            "../scripts/clean.sh"
         ]

**kernel-build.sh**

Данный скрипт выполняет сборку компиляцию с помощью утилиты make
В скрипте используется опция *j*, используется для многопроцессорных систем для распределения нагрузки на все ядра. *(nproc)* - количество ядер в системе.

    cp /boot/config-"$(uname -r)" .config
    make olddefconfig
    make -j"$(nproc)" bzImage
    make -j"$(nproc)" modules
    make -j"$(nproc)"
    make modules_install
    make install
    
После сборки ядра выполняются команды переконфигурации загрузчика и по умолчанию устанавливается загрузка нового ядра.

**install-guestadditions.sh**

Устанавливается репозиторий elrepo.

    sudo yum -y install https://www.elrepo.org/elrepo-release-7.0-4.el7.elrepo.noarch.rpm
    
Устанавливаются пакеты *kernel-headers* и *kernel-devel* для новой версии ядра.

    sudo yum -y --enablerepo=elrepo-kernel install --skip-broken kernel-ml-{devel,headers} perf
    
Далее монтируется образ *VirtualBoxGuestAdditions* и запускается скрипт установки

    sudo mkdir /media/VirtualBoxGuestAdditions
    sudo mount -t iso9660 -o loop /home/vagrant/VBoxGuestAdditions.iso /media/VirtualBoxGuestAdditions
    cd /media/VirtualBoxGuestAdditions
    sudo ./VBoxLinuxAdditions.run
    
**clean.sh**

Скрипт очищает временные каталоги. Взят полностью из репозитория мануала.

Сборка образа заняла около двух часов (Intel i5 8 core, 16Gb ram, SSD). В результате был получен образ *centos-7.7.1908-kernel-5-x86_64-Minimal.box*.

### Загрузка образа в Vagrant Cloud

Полученный box файл загрузил в Vagrant Cloud

    vagrant cloud publish --release parshyn-dima/centos-7-7 1.0 virtualbox centos-7.7.1908-kernel-5-x86_64-Minimal.box
    
***

# Заключение
Образ получил конечно большой (5.5Гб), но Shared Folder работают. 
Для создания образов с работающими Shared Folder вижу следующие варианты:
1. Использовать плагин **vagrant-vbguest**, а затем создать образ средствами vagrant (с вторым ядром не подходит)

        vagrant package --output <имя файла>.box

2. Создать в VirtualBox ВМ, установить ОС с официально дистрибутива, установить все необходимые пакеты и затем создать образ из этой системы

       vagrant package --base <Имя_ВМ_в_VirtualBox> --output <имя файла>.box
