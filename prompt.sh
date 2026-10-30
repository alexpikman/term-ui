#!/bin/bash

# --- НАСТРОЙКИ ЦВЕТОВ ---
C_LINE="\e[34m"   # Синий
C_TEXT="\e[32m"   # Зеленый
C_ARR="\e[33m"    # Желтый
C_RST="\e[0m"     # Сброс

# --- IP ---
SERVER_IP=$(hostname -I | awk '{print $1}')
[ -z "$SERVER_IP" ] && SERVER_IP="NO-IP"

# --- ВАРИАНТ 1 ---
PROMPT_V1="\n\n\n\n\n\e[5A\[${C_LINE}\]--------------------------------------------------------------------------------\[${C_RST}\]\n                                              \[${C_TEXT}\]${SERVER_IP}  \[${C_LINE}\]|\[${C_RST}\]  \[${C_ARR}\]\t\[${C_RST}\]\n\[${C_LINE}\]--------------------------------------------------------------------------------\[${C_RST}\]\n\[${C_ARR}\]➜\[${C_RST}\] \[${C_TEXT}\]\u@\h:\w\\\$ \[${C_ARR}\]➜\[${C_RST}\] "

# --- ВАРИАНТ 2 ---
PROMPT_V2="\n\n\n\n\n\e[5A\[${C_LINE}\]--------------------------------\[\e[0m\] \[${C_TEXT}\]${SERVER_IP}\[\e[0m\] \[${C_LINE}\]\]-------------------------------\[${C_RST}\]\n  \n\[${C_ARR}\]\t \[${C_LINE}\]|\[${C_RST}\] \[${C_TEXT}\]\u \[${C_ARR}\]➜➜\[${C_RST}\]|\n/n\n\[${C_TEXT}\]\u@\h:\w\\\$ \[${C_ARR}\]➜\[${C_RST}\] "

# --- ФУНКЦИЯ ---
apply_prompt() {
    local prompt_string="$1"
    local target_file="$HOME/.bashrc"

    # Удаляем ВСЕ старые настройки PS1 (даже если они поломаны)
    sed -i '/PS1=/d' "$target_file"
    
    # Добавляем новую с помощью printf (безопасно для спецсимволов)
    printf "PS1='%s'\n" "$prompt_string" >> "$target_file"
    
    # Принудительно применяем к текущей сессии
    export PS1="$prompt_string"
    
    # Перезагружаем .bashrc
    source "$target_file"
    
    clear
    echo -e "✅ Успешно применено!"
}

echo -e "\n=== Выберите стиль ==="
echo "1) Твой стандарт (IP | Время, ➜ root)"
echo "2) Второй вариант (рамка с IP)"
echo "3) Сбросить на дефолт"
read -p "Введите номер [1-3]: " choice

case $choice in
    1) apply_prompt "$PROMPT_V1" ;;
    2) apply_prompt "$PROMPT_V2" ;;
    3) 
        sed -i '/PS1=/d' ~/.bashrc
        source ~/.bashrc
        clear
        echo "✅ Сброшено."
        ;;
    *) echo "❌ Неверный выбор." ;;
esac
