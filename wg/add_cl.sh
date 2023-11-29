#!/bin/bash
source variables.sh
wg genkey | tee "/etc/wireguard/${var_username}_privatekey" | wg pubkey | tee "/etc/wireguard/${var_username}_publickey" > /dev/null
echo "[Peer]" >> /etc/wireguard/wg0.conf
echo "PublicKey = $(cat "/etc/wireguard/${var_username}_publickey")" >> /etc/wireguard/wg0.conf
echo "AllowedIPs = 10.10.0.2/32" >> /etc/wireguard/wg0.conf
systemctl restart wg-quick@wg0
echo "[Interface]
PrivateKey = $(cat "/etc/wireguard/${var_username}_privatekey")
Address = 10.10.0.2/24
DNS = 8.8.8.8

[Peer]
PublicKey = ${var_public_key}
Endpoint = ${var_ip_global}:51830
AllowedIPs = 0.0.0.0/0
PersistentKeepalive = 20" | sudo tee -a /etc/wireguard/${var_username}_cl.conf
systemctl restart wg-quick@wg0
