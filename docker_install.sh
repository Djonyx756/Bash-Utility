#!/bin/bash

# Обновление списка пакетов
sudo apt update

# Установка зависимостей для установки Docker
sudo apt install -y apt-transport-https ca-certificates curl software-properties-common

# Добавление GPG-ключа Docker
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

# Добавление репозитория Docker
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

# Обновление списка пакетов
sudo apt update

# Проверка доступных версий Docker
apt-cache policy docker-ce

# Установка Docker
sudo apt install -y docker-ce

# Установка Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/download/1.26.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
