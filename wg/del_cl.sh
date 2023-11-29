# Запрос адреса от пользователя
read -p "Введите адрес (например, 10.10.0.8): " address

# Поиск и удаление строки с указанным адресом
sed -i "/AllowedIPs = $address\/32/{N;N;d;}" /etc/wireguard/wg0.conf

echo "Строка с адресом $address и две предыдущие строки были удалены из файла."

systemctl restart wg-quick@wg0
