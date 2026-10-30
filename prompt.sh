#!/bin/bash

# --- НАСТРОЙКИ ЦВЕТОВ ---
COLOR_LINE="\e[34m"
COLOR_TEXT="\e[32m"
COLOR_ARROW="\e[33m"
COLOR_RESET="\e[0m"

# --- ВАРИАНТЫ ---
PROMPT_STANDARD="\n\n\n\n\n\e[5A\[${COLOR_LINE}\]--------------------------------------------------------------------------\[${COLOR_RESET}\]\n\[${COLOR_TEXT}\]\u@\h:\w\\\$ \[${COLOR_ARROW}\]➜\[${COLOR_RESET}\] "

PROMPT_CUSTOM="\n\n\n\n\n\e[5A\[${COLOR_LINE}\]--------------------------------------------------------------------------\[${COLOR_RESET}\]\n          \[${COLOR_LINE}\][\[${COLOR_RESET}\]\[${COLOR_TEXT}\]\h\[${COLOR_RESET}\] \[${COLOR_LINE}\]|\[${COLOR_RESET}\] \[${COLOR_ARROW}\]\t\[${COLOR_RESET}\]\[${COLOR_LINE}\]]\[${COLOR_RESET}\]\n\[${COLOR_LINE}\]--------------------------------------------------------------------------\[${COLOR_RESET}\]\n\[${COLOR_TEXT}\]\u@\h:\w\\\$ \[${COLOR_ARROW}\]➜\[${COLOR_RESET}\] "

apply_prompt() {
    local prompt_string="$1"
    local target_file="$HOME/.bashrc"

    [ ! -f "$target_file" ] && touch "$target_file"
    sed -i '/PS1=/d' "$target_file"
    echo "PS1='$prompt_string'" >> "$target_file"
    source "$target_file"
    echo -e "\n✅ Успешно применено! Если приглашение не изменилось, выполните: source ~/.bashrc"
}

echo -e "\n=== Выберите стиль приглашения ==="
echo "1) 📏 Стандарт (одна линия, зеленая строка, желтая стрелка)"
echo "2) 🎨 Кастом (двойная рамка, имя сервера, время)"
echo "3) 🔄 Сбросить на дефолт"
read -p "Введите номер [1-3]: " choice

case $choice in
    1) apply_prompt "$PROMPT_STANDARD" ;;
    2) apply_prompt "$PROMPT_CUSTOM" ;;
    3) 
        sed -i '/PS1=/d' ~/.bashrc
        source ~/.bashrc
        echo -e "\n✅ Возвращено стандартное приглашение."
        ;;
    *) echo -e "\n❌ Неверный выбор." ;;
esac
