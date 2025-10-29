#!/bin/bash
# install-private-stack.sh
# Приватный стек: Xray (Trojan) + SearXNG + Perplexica + (опц.) Passwordless
# Совместим с v2rayNG, v2rayN, Streisand, Shadowrocket
# Требует: Ubuntu 24.04, 1 CPU, 1 GB RAM

set -e

BOLD='\033[1m'
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

log() {
    echo -e "${GREEN}[+]${NC} $1"
}
error() {
    echo -e "${RED}[-]${NC} $1"
    exit 1
}

# === Проверка ОС ===
log "Проверка ОС..."
if ! grep -q "Ubuntu" /etc/os-release || ! grep -q "24.04\|22.04" /etc/os-release; then
    error "Поддерживаются только Ubuntu 22.04 и 24.04"
fi

# === Создание swap (для сборки Perplexica) ===
log "Создание временного swap-файла (2 ГБ)..."
if [ ! -f /swapfile ]; then
    fallocate -l 2G /swapfile
    chmod 600 /swapfile
    mkswap /swapfile
    swapon /swapfile
    echo '/swapfile none swap sw 0 0' | tee -a /etc/fstab
fi

# === Установка Xray (Trojan + TLS) ===
log "Установка Xray-core..."
bash -c "$(curl -L https://github.com/XTLS/Xray-install/raw/main/install-release.sh)" @ install

IP=$(curl -s ifconfig.me)
TROJAN_PASS=$(openssl rand -base64 32 | tr -d "=+/")

# Генерация сертификата
mkdir -p /usr/local/etc/xray
openssl req -x509 -nodes -newkey rsa:2048 -keyout /usr/local/etc/xray/privkey.pem \
  -out /usr/local/etc/xray/cert.pem -days 3650 -subj "/CN=$IP.nip.io"

# Конфиг Xray
cat > /usr/local/etc/xray/config.json <<EOF
{
  "log": { "loglevel": "warning" },
  "inbounds": [
    {
      "port": 443,
      "protocol": "trojan",
      "settings": {
        "clients": [{ "password": "$TROJAN_PASS" }],
        "fallbacks": [{ "dest": 80 }]
      },
      "streamSettings": {
        "network": "tcp",
        "security": "tls",
        "tlsSettings": {
          "serverName": "$IP.nip.io",
          "certificates": [{
            "certificateFile": "/usr/local/etc/xray/cert.pem",
            "keyFile": "/usr/local/etc/xray/privkey.pem"
          }]
        }
      }
    },
    {
      "port": 10809,
      "listen": "127.0.0.1",
      "protocol": "http",
      "settings": {}
    }
  ],
  "outbounds": [{ "protocol": "freedom" }]
}
EOF

systemctl restart xray
log "Xray запущен как Trojan + TLS"

# === Установка SearXNG (без Docker) ===
log "Установка SearXNG..."
apt update
apt install -y python3 python3-pip python3-venv git curl

git clone https://github.com/searxng/searxng.git /opt/searxng
cd /opt/searxng
python3 -m venv venv
source venv/bin/activate
pip install --upgrade pip
pip install -r requirements.txt

cp utils/searx/settings.yml searxng/settings.yml
sed -i 's/json_output: false/json_output: true/' searxng/settings.yml
sed -i '/^engines:/,/^$/ s/#.*wolframalpha/wolframalpha/' searxng/settings.yml

cp utils/searx/systemd/searx.service /etc/systemd/system/
systemctl daemon-reload
systemctl enable --now searx
log "SearXNG запущен на http://127.0.0.1:8888"

# === Установка Perplexica (без Docker) ===
log "Установка Perplexica..."
apt install -y nodejs npm build-essential python3 rustc
npm install -g pnpm

git clone https://github.com/ItzCrazyKns/Perplexica.git /opt/perplexica
cd /opt/perplexica
pnpm install
pnpm run build

cp sample.config.toml config.toml
# Настройка через UI — пользователь укажет API-ключи сам

cat > /etc/systemd/system/perplexica.service <<EOF
[Unit]
Description=Perplexica AI Search
After=network.target searx.service

[Service]
Type=simple
User=root
WorkingDirectory=/opt/perplexica
Environment=HTTP_PROXY=http://127.0.0.1:10809
Environment=HTTPS_PROXY=http://127.0.0.1:10809
ExecStart=/usr/bin/pnpm run start
Restart=always

[Install]
WantedBy=multi-user.target
EOF

systemctl enable --now perplexica
log "Perplexica запущена на http://$IP:3000"

# === Финал ===
SHARELINK="trojan://$TROJAN_PASS@$IP:443?security=tls&sni=$IP.nip.io#PrivateStack"

echo ""
echo -e "${BOLD}✅ Установка завершена!${NC}"
echo ""
echo "🔗 Ссылка для подключения:"
echo "$SHARELINK"
echo ""
echo "🌐 Perplexica: http://$IP:3000"
echo ""
echo "📱 Клиенты:"
echo "   Android: v2rayNG (https://github.com/2dust/v2rayNG/releases)"
echo "   Windows: v2rayN (https://github.com/2dust/v2rayN/releases)"
echo "   iOS/macOS: Streisand (https://testflight.apple.com/join/whnE5j9F)"
echo ""
echo "💡 Включите «Use Remote DNS» в клиенте для полной защиты от утечек!"
