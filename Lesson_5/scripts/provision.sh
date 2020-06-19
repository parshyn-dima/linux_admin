#!/usr/bin/env bash

#Включить планировщик ядра cfq для работы ionice
echo 'cfq' > /sys/block/sda/queue/scheduler
#Установка консольного калькулятора
yum install -y bc