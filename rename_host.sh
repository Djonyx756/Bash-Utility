#!/bin/bash

# Введите новое имя хоста
read -p "Введите новое имя хоста: " new_hostname

# Обновить hostname в файле /etc/hostname
echo $new_hostname > /etc/hostname

# Изменить hostname
hostname $new_hostname

# Обновить файл hosts
sed -i "s/127.0.1.1.*/127.0.1.1\t$new_hostname/g" /etc/hosts

# Перезапустить службу hostnamectl, если она установлена
if command -v hostnamectl &> /dev/null; then
    hostnamectl set-hostname $new_hostname
fi

# Показать новое имя хоста
echo "Новое имя хоста: $new_hostname"
