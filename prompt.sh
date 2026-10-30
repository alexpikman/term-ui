#!/bin/bash

# --- НАСТРОЙКИ ЦВЕТОВ ---
COLOR_LINE="\e[34m"   # Синий (полоска)
COLOR_TEXT="\e[32m"   # Зеленый (приглашение)
COLOR_ARROW="\e[33m"  # Желтый (стрелка)
COLOR_RESET="\e[0m"   # Сброс

# --- ВАРИАНТЫ ПРИГЛАШЕНИЙ ---
# 1. Стандарт: одна линия + отступ снизу 5 строк
PROMPT_STANDARD="\n\n\n\n\n\e[5A\[${COLOR_LINE}\]--------------------------------------------------------------------------\[${COLOR_RESET}\]\n\[${COLOR_TEXT}\]\u@\h:\w\\\$ \[${COLOR_ARROW}\]➜\[${COLOR_RESET}\] "

# 2. Кастом: двойная рамка + имя сервера + время
PROMPT_CUSTOM="\n\n\n\n\n\e[5A\[${COLOR_LINE}\]--------------------------------------------------------------------------\[${COLOR_RESET}\]\n          \[${COLOR_LINE}\][\[${COLOR_RESET}\]\[${COLOR_TEXT}\]\h\[${COLOR_RESET}\] \[${COLOR_LINE}\]|\[${COLOR_RESET}\] \[${COLOR_ARROW}\]\t\[${COLOR_RESET}\]\[${COLOR_LINE}\]]\[${COLOR_RESET}\]\n\[${COLOR_LINE}\]--------------------------------------------------------------------------\[${COLOR_RESET}\]\n\[${COLOR_TEXT}\]\u@\h:\w\\\$ \[${COLOR_ARROW}\]➜\[${COLOR_RESET}\] "

# --- ФУНКЦИЯ ПРИМЕНЕНИЯ ---
apply_prompt() {
    local prompt_string="$1"
    local target_file="$HOME/.bashrc"

    # Проверяем, существует ли .bashrc, если нет — создаем
    [ ! -f "$target_file" ] && touch "$target_file"

    # Удаляем старые настройки PS1, чтобы не было мусора
    sed -i '/PS1=/d' "$target_file"

    # Записываем новую настройку
    echo "PS1='$prompt_string'" >> "$target_file"

    # Применяем
    source "$target_file"
    echo -e "\n✅ Успешно применено!"
}

# --- МЕНЮ ВЫБОРА ---
echo -e "\n=== Выберите стиль приглашения ==="
echo "1) 📏 Стандарт (одна синяя полоска, зеленая строка, желтая стрелка)"
echo "2) 🎨 Кастом (двойная рамка, имя сервера, время)"
echo "3) 🔄 Сбросить на дефолт (системный)"
read -p "Введите номер [1-3]: " choice

case $choice in
    1)
        apply_prompt "$PROMPT_STANDARD"
        ;;
    2)
        apply_prompt "$PROMPT_CUSTOM"
        ;;
    3)
        sed -i '/PS1=/d' ~/.bashrc
        source ~/.bashrc
        echo -e "\n✅ Возвращено стандартное приглашение системы."
        ;;
    *)
        echo -e "\n❌ Неверный выбор. Попробуйте снова."
        ;;
esac
