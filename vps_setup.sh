#!/bin/bash

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

print_status() { echo -e "${GREEN}[INFO]${NC} $1"; }
print_warning() { echo -e "${YELLOW}[WARNING]${NC} $1"; }

# Получение внешнего IP
EXTERNAL_IP=$(curl -s icanhazip.com)

print_status "Настройка VPS Ubuntu 24.04 Minimal"
print_status "Внешний IP: $EXTERNAL_IP"

# Обновление системы
print_status "Обновление системных пакетов..."
apt update && apt full-upgrade -y

# Установка пакетов
print_status "Установка системных пакетов..."
apt install -y ufw fail2ban net-tools curl

# Настройка UFW
print_status "Настройка фаервола..."
ufw --force reset
ufw default deny incoming
ufw default allow outgoing
ufw allow 22/tcp
ufw deny in proto icmp
ufw --force enable

# Настройка Fail2Ban для защиты от брутфорса
print_status "Настройка Fail2Ban..."
cat > /etc/fail2ban/jail.local << 'EOF'
[DEFAULT]
bantime = 3600
findtime = 300
maxretry = 3
backend = auto

[sshd]
enabled = true
port = ssh
logpath = /var/log/auth.log
maxretry = 3
bantime = 86400
findtime = 600
EOF

systemctl enable fail2ban
systemctl start fail2ban

# Создание swap
print_status "Создание swap файла 2GB..."
if ! swapon --show | grep -q "."; then
    fallocate -l 2G /swapfile
    chmod 600 /swapfile
    mkswap /swapfile
    swapon /swapfile
    echo '/swapfile none swap sw 0 0' >> /etc/fstab
fi

# Оптимизация системы
print_status "Применение оптимизаций..."
cat > /etc/sysctl.d/99-optimization.conf << 'EOF'
net.core.default_qdisc = fq
net.ipv4.tcp_congestion_control = bbr
net.ipv4.tcp_fastopen = 3
net.core.rmem_max = 67108864
net.core.wmem_max = 67108864
net.core.rmem_default = 131072
net.core.wmem_default = 131072
net.ipv4.tcp_rmem = 4096 87380 67108864
net.ipv4.tcp_wmem = 4096 65536 67108864
net.ipv4.tcp_mem = 786432 1048576 1572864
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
net.ipv4.tcp_limit_output_bytes = 262144
net.ipv4.tcp_moderate_rcvbuf = 1
vm.swappiness = 10
vm.dirty_ratio = 15
vm.dirty_background_ratio = 5
net.ipv6.conf.all.disable_ipv6 = 1
net.ipv6.conf.default.disable_ipv6 = 1
net.ipv6.conf.lo.disable_ipv6 = 1
EOF

sysctl -p /etc/sysctl.d/99-optimization.conf

# Явно отключаем парольную аутентификацию в SSH
print_status "Отключение парольной аутентификации SSH..."
sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config
sed -i 's/PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config
sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
systemctl restart ssh

# Финальный вывод
echo
echo -e "${CYAN}┌────────────────────────────────────────┐${NC}"
echo -e "${CYAN}│           Настройка завершена          │${NC}"
echo -e "${CYAN}└────────────────────────────────────────┘${NC}"
echo
echo -e "${GREEN}✓  Система обновлена и оптимизирована${NC}"
echo -e "${GREEN}✓  Фаервол UFW активен (SSH 22/tcp)${NC}"
echo -e "${GREEN}✓  Fail2Ban защищает от брутфорса${NC}"
echo -e "${GREEN}✓  Swap 2GB создан${NC}"
echo
echo -e "${YELLOW}⚠  ICMP (ping) закрыт${NC}"
echo -e "${YELLOW}⚠  SSH доступ только по 🔑${NC}"
echo
echo -e "${BLUE}Подключение:${NC}"
echo -e "  ${CYAN}ssh root@${EXTERNAL_IP}${NC}"
echo -e "${YELLOW}[1m‼ ПРОВЕРЬТЕ ПОДКЛЮЧЕНИЕ ПЕРЕД ВЫХОДОМ! ‼${NC}[0m"

echo
