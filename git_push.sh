#!/bin/bash

# Сохраняем текущее значение api_tg
current_mainid=$(grep "mainid" wg_telegram/config.py | sed 's/.*\[\(.*\)\].*/\1/')
current_api_tg=$(grep "api_tg =" wg_telegram/config.py | sed 's/.*"\(.*\)".*/\1/')

# Заменяем значение api_tg на пустую строку
sed -i 's/mainid = \[.*\]/mainid = \[\]/' wg_telegram/config.py
sed -i 's/api_tg = ".*"/api_tg = ""/' wg_telegram/config.py

# Переходим в папку с проектом Git
cd wg_telegram

# Выполняем git add и другие команды
git add .
git rm --cached cofigs.txt
git rm --cached variables.sh
git rm --cached -r __pycache__/
git commit -m "update main.py"
git push origin main

# Восстанавливаем предыдущее значение api_tg
sed -i "s/mainid = \[\]/mainid = \[$current_mainid\]/" config.py
sed -i "s/api_tg = \"\"/api_tg = \"$current_api_tg\"/" config.py
