#!/usr/bin/env bash

# Скрипт генерирует файл размером 1 Гб и выводин информацию за какое время данный файл гененируется
# Переменной присваивается случайно сгенерированное имя
file="$(uuidgen)"
# Переменной присваивается информация о классе и приоритете ввода/вывода
run_params=$(ionice -p $$)

echo "Generating file with params (${run_params})"
# Время начала в секундах
START=$(date +%s.%N)
# Создание файл размером 1Gb
dd if=/dev/zero of="$file" count=2M bs=1024
rm "$file"

END=$(date +%s.%N)
# Высчитывает разницу между стартом и завершением
DIFF=$(echo "$END - $START" | bc)

echo "Running time of command with params (${run_params}): ${DIFF} seconds"