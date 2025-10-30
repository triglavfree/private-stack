#!/bin/bash
# migrate-to-domain.sh — для будущего перехода на домен

set -euo pipefail

if [[ "$(id -u)" -ne 0 ]]; then
  echo "❌ Запускайте от root"
  exit 1
fi

read -p "Введите ваш домен (например, private-stack.site): " DOMAIN
if [[ -z "$DOMAIN" ]]; then
  echo "❌ Домен не указан"
  exit 1
fi

# Проверка cloudflared login
if [ ! -f /root/.cloudflared/*.json ]; then
  echo "❌ Сначала выполните: cloudflared tunnel login"
  exit 1
fi

TUNNEL_NAME="private-stack"
TUNNEL_ID=$(cloudflared tunnel list --name "$TUNNEL_NAME" --output json 2>/dev/null | jq -r '.[0].id' || true)

if [[ -z "$TUNNEL_ID" ]]; then
  echo "Создание туннеля '$TUNNEL_NAME'..."
  cloudflared tunnel create "$TUNNEL_NAME"
  TUNNEL_ID=$(cloudflared tunnel list --name "$TUNNEL_NAME" --output json | jq -r '.[0].id')
fi

CRED_FILE="/root/.cloudflared/$TUNNEL_ID.json"

# Остановка старого туннеля
systemctl stop cloudflared
systemctl disable cloudflared

# Новый конфиг
cat > /etc/cloudflared/config.yml <<EOF
tunnel: $TUNNEL_ID
credentials-file: $CRED_FILE

ingress:
  - hostname: xray.$DOMAIN
    service: https://localhost:443
  - hostname: bw.$DOMAIN
    service: http://localhost:8080
  - hostname: search.$DOMAIN
    service: http://localhost:8888
  - service: http_status:404
EOF

cat > /etc/systemd/system/cloudflared.service <<EOF
[Unit]
Description=Cloudflare Tunnel (именованный)
After=network.target

[Service]
Type=simple
ExecStart=/usr/local/bin/cloudflared tunnel run --config /etc/cloudflared/config.yml
Restart=always
RestartSec=10
User=root

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable --now cloudflared

echo
echo "✅ Готово! Добавьте в Cloudflare DNS (Proxied):"
echo "  xray.$DOMAIN    → CNAME → $TUNNEL_ID.cfargotunnel.com"
echo "  bw.$DOMAIN      → CNAME → $TUNNEL_ID.cfargotunnel.com"
echo "  search.$DOMAIN  → CNAME → $TUNNEL_ID.cfargotunnel.com"
