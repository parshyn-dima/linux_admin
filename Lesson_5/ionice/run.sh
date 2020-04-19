#!/bin/bash
#Запускаем скрипт с импользованием класса best effort и приоритетом 7 (наименьший)
ionice -c 2 -n 7 ./ionice/io_test.sh &
#Запускаем скрипт с импользованием класса best effort и приоритетом 0 (навысший)
ionice -c 2 -n 0 ./ionice/io_test.sh &

wait