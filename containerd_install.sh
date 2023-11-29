#!/bin/bash

# Установка containerd
wget https://github.com/containerd/containerd/releases/download/v1.7.0/containerd-1.7.0-linux-amd64.tar.gz
tar -C /usr/local -xzvf containerd-1.7.0-linux-amd64.tar.gz
rm containerd-1.7.0-linux-amd64.tar.gz

# Создание конфигурации по умолчанию для containerd
mkdir /etc/containerd/
containerd config default > /etc/containerd/config.toml

# Настройка cgroup драйвера
sed -i 's/SystemdCgroup = false/SystemdCgroup = true/g' /etc/containerd/config.toml

# Установка systemd сервиса для containerd
wget https://raw.githubusercontent.com/containerd/containerd/main/containerd.service
mv containerd.service /etc/systemd/system/

# Установка компонента runc
wget https://github.com/opencontainers/runc/releases/download/v1.1.4/runc.amd64
install -m 755 runc.amd64 /usr/local/sbin/runc
rm runc.amd64

# Установка сетевых плагинов
wget https://github.com/containernetworking/plugins/releases/download/v1.2.0/cni-plugins-linux-amd64-v1.2.0.tgz
mkdir -p /opt/cni/bin
tar -C /opt/cni/bin -xzvf cni-plugins-linux-amd64-v1.2.0.tgz
rm cni-plugins-linux-amd64-v1.2.0.tgz

# Запуск сервиса containerd
systemctl daemon-reload
systemctl enable --now containerd

# Выполнение дополнительных команд
crictl --runtime-endpoint unix:///var/run/containerd/containerd.sock version
ctr images pull docker.io/library/hello-world:latest
ctr run docker.io/library/hello-world:latest hello-world
