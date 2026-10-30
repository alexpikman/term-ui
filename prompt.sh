#!/bin/bash

# --- НАСТРОЙКИ ЦВЕТОВ ---
COLOR_LINE="\e[34m"   # Синий (полоска)
COLOR_TEXT="\e[32m"   # Зеленый (приглашение)
COLOR_ARROW="\e[33m"  # Желтый (стрелка)
COLOR_RESET="\e[0m"   # Сброс

# --- ВЫЧИСЛЯЕМ IP ---
SERVER_IP=$(hostname -I | awk '{print $1}')
[ -z "$SERVER_IP" ] && SERVER_IP="NO-IP"

# --- ВАРИАНТ 1: Твой скорректированный стандарт ---
# Линия, по центру IP | Время, линия, стрелка root... стрелка
PROMPT_V1="\n\n\n\n\n\e[5A\[${COLOR_LINE}\]--------------------------------------------------------------------------------\[${COLOR_RESET}\]\n                                              \[${COLOR_TEXT}\]${SERVER_IP}  \[${COLOR_LINE}\]|\[${COLOR_RESET}\]  \[${COLOR_ARROW}\]\t\[${COLOR_RESET}\]\n\[${COLOR_LINE}\]--------------------------------------------------------------------------------\[${COLOR_RESET}\]\n\[${COLOR_ARROW}\]➜\[${COLOR_RESET}\] \[${COLOR_TEXT}\]\u@\h:\w\\\$ \[${COLOR_ARROW}\]➜\[${COLOR_RESET}\] "

# --- ВАРИАНТ 2: Твой второй дизайн ---
# Линия с IP в рамке, отступ, время | root стрелки, /n
PROMPT_V2="\n\n\n\n\n\e[5A\[${COLOR_LINE}\]--------------------------------\[\e[0m\] \[${COLOR_TEXT}\]${SERVER_IP}\[\e[0m\] \[${COLOR_LINE}\]\]-------------------------------\[${COLOR_RESET}\]\n  \n\[${COLOR_ARROW}\]\t \[${COLOR_LINE}\]|\[${COLOR_RESET}\] \[${COLOR_TEXT}\]\u \[${COLOR_ARROW}\]➜➜\[${COLOR_RESET}\]|\n/n\n\[${COLOR_TEXT}\]\u@\h:\w\\\$ \[${COLOR_ARROW}\]➜\[${COLOR_RESET}\] "

# --- ФУНКЦИЯ ПРИМЕНЕНИЯ ---
apply_prompt() {
    local prompt_string="$1"
    local target_file="$HOME/.bashrc"

    [ ! -f "$target_file" ] && touch "$target_file"
    
    # Удаляем старые настройки PS1
    sed -i '/PS1=/d' "$target_file"
    
    # Записываем новую настройку
    echo "PS1='$prompt_string'" >> "$target_file"
    
    # МГНОВЕННО применяем к текущей сессии
    eval "PS1='$prompt_string'"
    
    # Очищаем экран
    clear
    echo -e "✅ Успешно применено!"
}

# --- МЕНЮ ВЫБОРА ---
echo -e "\n=== Выберите стиль приглашения ==="
echo "1) 📏 Твой стандарт (IP | Время, ➜ root)"
echo "2) 🎨 Второй вариант (IP в рамке, Время | root)"
echo "3) 🔄 Сбросить на дефолт"
read -p "Введите номер [1-3]: " choice

case $choice in
    1)
        apply_prompt "$PROMPT_V1"
        ;;
    2)
        apply_prompt "$PROMPT_V2"
        ;;
    3)
        sed -i '/PS1=/d' ~/.bashrc
        source ~/.bashrc
        clear
        echo -e "✅ Возвращено стандартное приглашение."
        ;;
    *)
        echo -e "\n❌ Неверный выбор."
        ;;
esac
