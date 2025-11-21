#!/bin/bash

# Цвета для вывода
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Функции для цветного вывода
print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Проверка запуска от root
if [ "$EUID" -ne 0 ]; then 
    print_error "Запустите скрипт от root: sudo bash $0"
    exit 1
fi

print_status "Начало настройки VPS Ubuntu 24.04 Minimal"

# Шаг 1: Обновление системы
print_status "Шаг 1: Обновление системных пакетов..."
apt update && apt full-upgrade -y
if [ $? -eq 0 ]; then
    print_status "Система успешно обновлена"
else
    print_error "Ошибка обновления системы"
    exit 1
fi

# Шаг 2: Установка необходимых пакетов
print_status "Шаг 2: Установка системных пакетов..."
apt install -y ufw fail2ban net-tools htop nethogs iotop curl wget git
if [ $? -eq 0 ]; then
    print_status "Пакеты успешно установлены"
else
    print_error "Ошибка установки пакетов"
    exit 1
fi

# Шаг 3: Настройка фаервола UFW
print_status "Шаг 3: Настройка фаервола UFW..."

# Сброс UFW к настройкам по умолчанию
ufw --force reset

# Запретить все входящие, разрешить все исходящие
ufw default deny incoming
ufw default allow outgoing

# Разрешить SSH на порту 22
ufw allow 22/tcp

# ЗАКРЫТЬ ICMP (ping) - важное изменение!
ufw deny in proto icmp

# Включить UFW
ufw --force enable

print_status "UFW настроен: разрешен только SSH (22/tcp), ICMP (ping) ЗАКРЫТ"

# Шаг 4: Настройка Fail2Ban для защиты SSH
print_status "Шаг 4: Настройка Fail2Ban..."
cat > /etc/fail2ban/jail.local << 'EOF'
[DEFAULT]
bantime = 3600
findtime = 600
maxretry = 3
backend = auto

[sshd]
enabled = true
port = ssh
logpath = /var/log/auth.log
maxretry = 3
bantime = 86400
EOF

systemctl enable fail2ban
systemctl start fail2ban
print_status "Fail2Ban настроен для защиты SSH"

# Шаг 5: Создание swap файла 2GB
print_status "Шаг 5: Создание swap файла 2GB..."

# Проверка существующего swap
if swapon --show | grep -q "."; then
    print_warning "Swap уже существует. Пропускаем создание."
else
    # Создание swap файла 2GB
    fallocate -l 2G /swapfile
    chmod 600 /swapfile
    mkswap /swapfile
    swapon /swapfile
    
    # Добавление в fstab для автозагрузки
    echo '/swapfile none swap sw 0 0' >> /etc/fstab
    
    print_status "Swap файл 2GB создан и активирован"
fi

# Шаг 6: Оптимизация системы
print_status "Шаг 6: Применение системных оптимизаций..."

# Создание конфигурации sysctl
cat > /etc/sysctl.d/99-optimization.conf << 'EOF'
# Сетевые оптимизации
net.core.default_qdisc = fq
net.ipv4.tcp_congestion_control = bbr
net.ipv4.tcp_fastopen = 3

# Оптимизация памяти и буферов
net.core.rmem_max = 67108864
net.core.wmem_max = 67108864
net.core.rmem_default = 131072
net.core.wmem_default = 131072
net.ipv4.tcp_rmem = 4096 87380 67108864
net.ipv4.tcp_wmem = 4096 65536 67108864
net.ipv4.tcp_mem = 786432 1048576 1572864

# Оптимизация соединений
net.ipv4.tcp_slow_start_after_idle = 0
net.ipv4.tcp_max_syn_backlog = 65536
net.ipv4.tcp_synack_retries = 2
net.ipv4.tcp_syn_retries = 3
net.ipv4.tcp_retries2 = 8
net.ipv4.tcp_keepalive_time = 300
net.ipv4.tcp_keepalive_probes = 5
net.ipv4.tcp_keepalive_intvl = 15
net.core.netdev_max_backlog = 65536
net.core.somaxconn = 65535
net.ipv4.tcp_max_tw_buckets = 1440000
net.ipv4.tcp_tw_reuse = 1

# Дополнительные оптимизации
net.ipv4.tcp_limit_output_bytes = 262144
net.ipv4.tcp_moderate_rcvbuf = 1

# Оптимизация памяти и swap
vm.swappiness = 10
vm.dirty_ratio = 15
vm.dirty_background_ratio = 5

# Отключение IPv6 (можно удалить если нужен IPv6)
net.ipv6.conf.all.disable_ipv6 = 1
net.ipv6.conf.default.disable_ipv6 = 1
net.ipv6.conf.lo.disable_ipv6 = 1
EOF

# Применение настроек sysctl
sysctl -p /etc/sysctl.d/99-optimization.conf

print_status "Системные оптимизации применены"

# Шаг 7: Настройка SSH (только для ключей) - УБРАНА, так как ключ уже в ЛК хостера
print_status "Шаг 7: Проверка настроек SSH..."
print_warning "SSH ключ должен быть уже настроен в личном кабинете хостера"
print_warning "Дополнительная настройка SSH не требуется"

# Шаг 8: Финальные проверки
print_status "Шаг 8: Финальные проверки..."

# Проверка swap
echo "--- Статус Swap ---"
swapon --show
free -h

# Проверка статуса UFW
echo "--- Статус UFW ---"
ufw status

# Проверка статуса Fail2Ban
echo "--- Статус Fail2Ban ---"
systemctl status fail2ban --no-pager -l

# Проверка оптимизаций
echo "--- Применённые оптимизации ---"
sysctl net.ipv4.tcp_congestion_control
sysctl vm.swappiness

# Финальный вывод
echo "----------------------------------------"
echo "Итог выполненных изменений:"
echo "✅ Система обновлена"
echo "✅ UFW настроен (только SSH 22/tcp)"
echo "✅ ICMP (ping) ЗАКРЫТ ‼️"
echo "✅ Fail2Ban установлен и настроен"
echo "✅ Swap файл 2GB создан"
echo "✅ Системные оптимизации применены"
echo "✅ SSH работает с ключами (настройте в ЛК хостера)"
echo "----------------------------------------"
echo ""
print_status "Для проверки подключения используйте: ssh root@your-server"
