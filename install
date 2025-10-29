#!/bin/bash
# install
# Private Stack: Xray (Trojan + TLS) + SearXNG + Cloudflare Tunnel + Let's Encrypt
# Без Docker, под 1 ГБ RAM, совместим с iOS/macOS (Shadowrocket из App Store)

set -e
exec > >(tee -a /var/log/privatestack_install.log) 2>&1

log() { echo -e "\033[0;32m[+]\033[0m $1"; }
error() { echo -e "\033[0;31m[-]\033[0m $1"; exit 1; }

# === Проверка root ===
if [[ "$(id -u)" -ne 0 ]]; then error "Запускайте от root"; fi

# === Проверка ОС ===
if ! grep -q "Ubuntu" /etc/os-release || ! grep -q "24.04\|22.04" /etc/os-release; then
    error "Требуется Ubuntu 22.04 или 24.04"
fi

# === Установка jq и qrencode ===
for pkg in jq qrencode; do
    if ! command -v "$pkg" &> /dev/null; then
        log "Установка $pkg..."
        apt-get update -qq
        DEBIAN_FRONTEND=noninteractive apt-get install -y "$pkg"
    fi
done

# === Swap (2 ГБ, если нет) ===
if ! swapon -s | grep -q "/swapfile"; then
    if [ ! -f /swapfile ]; then
        log "Создание swap-файла (2 ГБ)..."
        fallocate -l 2G /swapfile
        chmod 600 /swapfile
        mkswap /swapfile
        swapon /swapfile
        echo '/swapfile none swap sw 0 0' >> /etc/fstab
    fi
else
    log "Swap-файл уже существует."
fi

# === Установка зависимостей ===
log "Установка базовых пакетов..."
DEBIAN_FRONTEND=noninteractive apt-get install -y \
    curl git python3 python3-venv nginx-light ufw fail2ban \
    certbot python3-certbot-nginx

# === Настройка UFW ===
log "Настройка UFW и fail2ban..."
ufw --force reset
ufw default deny incoming
ufw default allow outgoing
ufw allow 22/tcp comment "SSH (рекомендуется ограничить по IP)"
ufw allow 80/tcp comment "HTTP (Let's Encrypt + Cloudflare)"
ufw allow 443/tcp comment "HTTPS (Xray + Nginx)"
ufw --force enable
systemctl enable --now fail2ban

# === Установка Xray ===
log "Установка Xray-core..."
bash -c "$(curl -L https://github.com/XTLS/Xray-install/raw/main/install-release.sh)" @ install

# === Подготовка домена и пароля ===
IP=$(curl -s ifconfig.me)
PASS=$(openssl rand -base64 32 | tr -d "=+/")
SERVER_NAME="$IP.sslip.io"

# === Let’s Encrypt ===
log "Получение сертификата Let's Encrypt для $SERVER_NAME..."
if ! certbot certificates | grep -q "$SERVER_NAME"; then
    # Временный Nginx для HTTP-челленджа
    echo "server { listen 80; server_name $SERVER_NAME; root /var/www/html; }" > /etc/nginx/sites-enabled/default
    systemctl reload nginx
    certbot certonly --standalone -d "$SERVER_NAME" \
        --non-interactive --agree-tos --register-unsafely-without-email
fi

# === Конфиг Xray (Trojan + TLS) ===
log "Настройка Xray (Trojan + TLS)..."
mkdir -p /usr/local/etc/xray
cat > /usr/local/etc/xray/config.json <<EOF
{
  "log": { "loglevel": "warning" },
  "inbounds": [
    {
      "port": 443,
      "protocol": "trojan",
      "settings": {
        "clients": [{ "password": "$PASS" }],
        "fallbacks": [{ "alpn": "http/1.1", "dest": 80 }]
      },
      "streamSettings": {
        "network": "tcp",
        "security": "tls",
        "tlsSettings": {
          "serverName": "$SERVER_NAME",
          "certificates": [{
            "certificateFile": "/etc/letsencrypt/live/$SERVER_NAME/fullchain.pem",
            "keyFile": "/etc/letsencrypt/live/$SERVER_NAME/privkey.pem"
          }]
        }
      }
    }
  ],
  "outbounds": [{ "protocol": "freedom" }]
}
EOF

systemctl restart xray
log "✅ Xray (Trojan + TLS) запущен"

# === Установка SearXNG с uv ===
log "Установка SearXNG с uv..."
git clone https://github.com/searxng/searxng.git /opt/searxng
cd /opt/searxng

curl -LsSf https://astral.sh/uv/install.sh | sh
export PATH="/root/.cargo/bin:$PATH"

python3 -m venv venv
source venv/bin/activate
/root/.cargo/bin/uv pip install --system -r requirements.txt

cp utils/searx/settings.yml searxng/settings.yml
sed -i 's/json_output:.*/json_output: true/' searxng/settings.yml
sed -i "s|base_url:.*|base_url: http://127.0.0.1:8888|" searxng/settings.yml
sed -i 's|port:.*|port: 8888|' searxng/settings.yml
sed -i 's|bind_address:.*|bind_address: "127.0.0.1"|' searxng/settings.yml
sed -i '/^- name: wolframalpha/s/^#//' searxng/settings.yml
sed -i '/^- name: wolframalpha/,+3 s/^#//' searxng/settings.yml

cp utils/searx/systemd/searx.service /etc/systemd/system/
systemctl daemon-reload
systemctl enable --now searx
log "✅ SearXNG запущен на http://127.0.0.1:8888"

# === Nginx: HTTPS + заглушка ===
cat > /etc/nginx/sites-available/default <<EOF
server {
    listen 80;
    server_name _;
    return 301 https://\$host\$request_uri;
}

server {
    listen 443 ssl http2;
    server_name $SERVER_NAME;

    ssl_certificate /etc/letsencrypt/live/$SERVER_NAME/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/$SERVER_NAME/privkey.pem;

    location / {
        root /var/www/html;
        index index.html;
    }
}
EOF

echo "<h1>Secure Private Stack</h1>" > /var/www/html/index.html
systemctl reload nginx
log "✅ Nginx настроен с редиректом HTTP → HTTPS"

# === Cloudflare Tunnel (временный) ===
log "Установка cloudflared..."
ARCH=$(uname -m)
if [[ "$ARCH" == "x86_64" ]]; then
    DL_URL="https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64"
elif [[ "$ARCH" == "aarch64" ]]; then
    DL_URL="https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-arm64"
else
    error "Архитектура $ARCH не поддерживается"
fi
curl -L "$DL_URL" -o /usr/local/bin/cloudflared
chmod +x /usr/local/bin/cloudflared

cat > /etc/systemd/system/cloudflared-tunnel.service <<EOF
[Unit]
Description=Cloudflare Tunnel (temporary)
After=network.target

[Service]
Type=simple
ExecStart=/usr/local/bin/cloudflared tunnel --url https://localhost:443
Restart=always
RestartSec=10
User=root

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable --now cloudflared-tunnel
sleep 12

CF_URL=$(journalctl -u cloudflared-tunnel -n 60 2>/dev/null | grep -o 'https://[a-z0-9-]*\.trycloudflare\.com' | head -1)

# === Trojan-ссылка ===
if [ -n "$CF_URL" ]; then
    TROJAN_SNI=$(echo "$CF_URL" | sed 's|https://||; s|/||')
    SHARELINK="trojan://$PASS@$TROJAN_SNI:443?security=tls&sni=$TROJAN_SNI#PrivateStack-CF"
else
    SHARELINK="trojan://$PASS@$IP:443?security=tls&sni=$SERVER_NAME#PrivateStack"
    CF_URL="https://$SERVER_NAME (fallback)"
fi

# === Скрипты управления пользователями ===
cat > /usr/local/bin/mainuser <<EOF
#!/bin/bash
PASS=\$(jq -r '.inbounds[0].settings.clients[0].password' /usr/local/etc/xray/config.json)
IP=\$(curl -4s ifconfig.me)
SNI=\$(jq -r '.inbounds[0].streamSettings.tlsSettings.serverName' /usr/local/etc/xray/config.json)
LINK="trojan://\$PASS@\$IP:443?security=tls&sni=\$SNI#PrivateStack"
echo "🔗 Ссылка:"
echo "\$LINK"
echo
echo "📱 QR-код:"
echo "\$LINK" | qrencode -t ansiutf8
EOF
chmod +x /usr/local/bin/mainuser

# newuser, rmuser, sharelink — можно добавить позже (опционально для Trojan)

# === Скрипт обновления ===
cat > /usr/local/bin/private-stack-update <<'EOF'
#!/bin/bash
set -e
log() { echo -e "\033[0;32m[+]\033[0m $1"; }

log "Обновление Xray..."
bash -c "$(curl -L https://github.com/XTLS/Xray-install/raw/main/install-release.sh)" @ install

log "Обновление SearXNG..."
cd /opt/searxng && git pull
source venv/bin/activate
/root/.cargo/bin/uv pip install --system -r requirements.txt
systemctl restart searx

log "Обновление cloudflared..."
ARCH=$(uname -m)
if [[ "$ARCH" == "x86_64" ]]; then
    DL_URL="https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64"
elif [[ "$ARCH" == "aarch64" ]]; then
    DL_URL="https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-arm64"
fi
curl -L "$DL_URL" -o /usr/local/bin/cloudflared
chmod +x /usr/local/bin/cloudflared
systemctl restart cloudflared-tunnel

log "✅ Все компоненты обновлены!"
EOF
chmod +x /usr/local/bin/private-stack-update

# === Финал ===
systemctl restart xray nginx

echo
echo "🎉 Установка завершена!"
echo
echo "🔗 Trojan-ссылка для подключения:"
echo "$SHARELINK"
echo
echo "🌐 Cloudflare Tunnel или fallback:"
echo "$CF_URL"
echo
echo "📱 Клиенты:"
echo "   iOS/macOS: Shadowrocket (App Store)"
echo "   Android: v2rayNG"
echo "   Windows: v2rayN"
echo
echo "💡 Советы:"
echo "   - Включите «Remote DNS» в клиенте"
echo "   - SearXNG доступен только через прокси (127.0.0.1:8888)"
echo "   - Ваш IP скрыт благодаря Cloudflare Tunnel"
echo
echo "🔄 Обновление: sudo private-stack-update"
echo "🔑 Ссылка основного пользователя: sudo mainuser"
