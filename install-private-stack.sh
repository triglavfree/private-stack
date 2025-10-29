#!/bin/bash
# install-private-stack.sh
# Private Stack: Xray (Trojan) + SearXNG + Perplexica
# Без Docker, под 1 ГБ RAM, совместим с iOS/macOS

set -e

log() { echo -e "\033[0;32m[+]\033[0m $1"; }
error() { echo -e "\033[0;31m[-]\033[0m $1"; exit 1; }

# === Проверка ОС ===
if ! grep -q "Ubuntu" /etc/os-release || ! grep -q "24.04\|22.04" /etc/os-release; then
    error "Требуется Ubuntu 22.04 или 24.04"
fi

# === Swap для сборки ===
if [ ! -f /swapfile ]; then
    log "Создание swap-файла (2 ГБ)..."
    fallocate -l 2G /swapfile
    chmod 600 /swapfile
    mkswap /swapfile
    swapon /swapfile
    echo '/swapfile none swap sw 0 0' >> /etc/fstab
fi

# === Установка Xray (официальный скрипт) ===
log "Установка Xray-core..."
bash -c "$(curl -L https://github.com/XTLS/Xray-install/raw/main/install-release.sh)" @ install

IP=$(curl -s ifconfig.me)
PASS=$(openssl rand -base64 32 | tr -d "=+/")

# === Генерация TLS-сертификата ===
mkdir -p /usr/local/etc/xray
openssl req -x509 -nodes -newkey rsa:2048 -keyout /usr/local/etc/xray/privkey.pem \
  -out /usr/local/etc/xray/cert.pem -days 3650 -subj "/CN=$IP.nip.io"

# === Конфиг: Trojan + TLS + локальный прокси ===
cat > /usr/local/etc/xray/config.json <<EOF
{
  "log": { "loglevel": "warning" },
  "inbounds": [
    {
      "port": 443,
      "protocol": "trojan",
      "settings": {
        "clients": [{ "password": "$PASS" }],
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
log "✅ Xray (Trojan + TLS) запущен"

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

# Включить JSON
sed -i 's/json_output:.*/json_output: true/' searxng/settings.yml

# Включить Wolfram Alpha (без ключа)
sed -i '/^- name: wolframalpha/s/^#//' searxng/settings.yml
sed -i '/^- name: wolframalpha/,+3 s/^#//' searxng/settings.yml

cp utils/searx/systemd/searx.service /etc/systemd/system/
systemctl daemon-reload
systemctl enable --now searx
log "✅ SearXNG запущен на http://127.0.0.1:8888"

# === Установка Perplexica (без Docker) ===
log "Установка Perplexica..."
apt install -y nodejs npm build-essential python3 rustc
npm install -g pnpm

git clone https://github.com/ItzCrazyKns/Perplexica.git /opt/perplexica
cd /opt/perplexica
pnpm install
pnpm run build

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
log "✅ Perplexica запущена на http://$IP:3000"

# === Финал ===
SHARELINK="trojan://$PASS@$IP:443?security=tls&sni=$IP.nip.io#PrivateStack"

echo
echo "🎉 Установка завершена!"
echo
echo "🔗 Ссылка для подключения:"
echo "$SHARELINK"
echo
echo "📱 Клиенты:"
echo "   Android: v2rayNG"
echo "   Windows: v2rayN"
echo "   iOS/macOS: Streisand (TestFlight)"
echo
echo "💡 Обязательно включите «Use Remote DNS» в клиенте!"
