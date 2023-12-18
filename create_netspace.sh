#!/bin/bash

NETSPACE_NAME="gm"
REMOTE_IF="veth_remote"
LOCAL_IF="veth_local"

# Проверяем существование пространства имен
if ! ip netns list | grep -q $NETSPACE_NAME; then
    # Создаем пространство имен, если не существует
    ip netns add $NETSPACE_NAME
fi

# Удаляем предыдущие виртуальные интерфейсы, если они существуют
ip link delete $LOCAL_IF 2>/dev/null
ip netns exec $NETSPACE_NAME ip link delete $REMOTE_IF 2>/dev/null

# Создаем новые виртуальные интерфейсы
ip link add $LOCAL_IF type veth peer name $REMOTE_IF

# Помещаем $REMOTE_IF в пространство имен $NETSPACE_NAME
ip link set $REMOTE_IF netns $NETSPACE_NAME

# Настраиваем интерфейсы
ip link set dev $LOCAL_IF up
ip netns exec $NETSPACE_NAME ip link set dev $REMOTE_IF up

# Устанавливаем IP-адреса
ip addr add 10.10.10.1/24 dev $LOCAL_IF
ip netns exec $NETSPACE_NAME ip addr add 10.10.10.2/24 dev $REMOTE_IF

# Включаем IP-маршрутизацию и настраиваем NAT
echo 1 > /proc/sys/net/ipv4/ip_forward
iptables -t nat -A POSTROUTING -s 10.10.10.0/24 -j MASQUERADE

# Устанавливаем маршрут по умолчанию в пространстве имен
ip netns exec $NETSPACE_NAME ip route add default via 10.10.10.1

# Устанавливаем DNS в пространстве имен
ip netns exec $NETSPACE_NAME bash -c 'echo "nameserver 8.8.8.8" > /etc/resolv.conf'

sysctl -w net.ipv4.ip_forward=1
iptables -P FORWARD ACCEPT
