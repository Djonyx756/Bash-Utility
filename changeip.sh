#!/bin/bash

old_ip="192.168.0.101"
new_ip="192.168.0.105"
sed -i "s/$old_ip/$new_ip/g" /etc/netplan/00-installer-config.yaml
echo "IP address changed to $new_ip in netplan YAML files."
