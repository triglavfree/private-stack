# 🛡️ Private Stack
скипт развёртывания приватной инфраструктуры на VPS

> **Полностью приватная инфраструктура для анонимного поиска и зашифрованного трафика**  
> Без Docker • Работает на 1 ГБ RAM

##  ✅ Возможности
- **Xray в режиме Xray (REALITY + Vision)** — обход DPI, совместим с **Shadowrocket (App Store)**, v2rayNG, v2rayN
- **Анонимный поиск** через [SearXNG](https://github.com/searxng/searxng) (локально, без логов, с Wolfram Alpha)
- **Автоматический TLS** через **Let’s Encrypt** (с использованием IP.sslip.io)
- **Скрытие IP** через **Cloudflare Tunnel** (бесплатный поддомен *.trycloudflare.com)
- **Защита от брутфорса**: ufw + fail2ban
- **Заглушка-сай**т (nginx-light) — сервер выглядит как обычный HTTPS-сайт
- **Управление пользователями**: создание, удаление, генерация ссылок и QR-кодов
- **Автоматическое обновление** всех компонентов одной командой

## 📦 Требования
- VPS с Ubuntu 22.04 или 24.04
- 1 CPU, 1 ГБ RAM, 10+ ГБ NVMe
- Открытые порты: 80 (HTTP) и 443 (HTTPS)
- Публичный IPv4 (для sslip.io и Let’s Encrypt)
> 💡 Swap на 2 ГБ создаётся автоматически при необходимости.

## 🚀 Установка

```bash
curl -sL https://raw.githubusercontent.com/triglavfre/private-stack/main/install | bash
```
Скрипт автоматически:

- Создаст swap (если нужно)
- Установит и настроит Xray (REALITY + Vision)
- Получит валидный сертификат Let’s Encrypt для IP.sslip.io
- Установит SearXNG через сверхбыстрый менеджер пакетов uv
- Настроит nginx-light с HTTP → HTTPS редиректом
- Запустит временный Cloudflare Tunnel (без браузера, без домена)
- Настроит ufw + fail2ban
- Выведет VLESS + REALITY + Vision -ссылку и QR-код

## 📱 Клиенты для устройств

| Платформа     | Клиент   | Где взять                     |
|---------------|----------|-------------------------------|
| **iOS/macOS** | Hiddify  | [GitHub Releases](https://github.com/hiddify/hiddify-app/releases)|
| **Android**   | Hiddify  | [GitHub Releases](https://github.com/hiddify/hiddify-app/releases) |
| **Windows**   | Hiddify  | [GitHub Releases](https://github.com/hiddify/hiddify-app/releases) |

## 🔐 Приватность и безопасность
Все запросы к SearXNG идут через ваш VPS → **ваш IP скрыт**
Vless-трафик шифруется через **валидный TLS-сертификат**
SearXNG локально привязан к `127.0.0.1` — **недоступен извне**
Cloudflare Tunnel скрывает ваш IP даже от провайдера
Нет Docker, нет логов, нет облачных зависимостей

## 🛠 Управление пользователями

После установки доступны команды:
```
mainuser    # показать ссылку и QR-код основного пользователя
newuser     # создать нового пользователя
rmuser      # удалить пользователя
sharelink   # выбрать пользователя и получить ссылку/QR
```
## 🔄 Обновление компонентов

```bash
private-stack-update
```
## 🔒 Дополнительная безопасность (рекомендуется)

Ограничьте SSH по IP:
```bash
ufw delete allow 22
ufw allow from ВАШ_IP to any port 22
```
## 🔑 Менеджер паролей: Vaultwarden
Vaultwarden доступен по уникальному URL вида:
```
https://<random>.trycloudflare.com
```
- Работает через **Cloudflare Tunnel** (ваш IP скрыт)
- TLS от Cloudflare — **без Let’s Encrypt**
- Полная совместимость с **официальными Bitwarden-клиентами**

## 🔗 Как подключить браузер:
1. Установите **LibreWolf** (приватный Firefox-форк):
👉 (https://librewolf.net/installation/)
2. Установите расширение Bitwarden:
👉(https://addons.mozilla.org/firefox/addon/bitwarden-password-manager/)
3. В расширении нажмите ⚙️ → **«Settings»** → **«Self-hosted installation»**
4. Введите URL вашего Vaultwarden (например: `https://vivid-sun-1234.trycloudflare.com`)
5. Сохраните и войдите в аккаунт
> ✅ Теперь все пароли синхронизируются с вашим сервером.
6. Используйте **SearXNG** для поиска:
```bash
https://127.0.0.1:8888`
```

## 📜 Лицензия [MIT](LICENSE)
>MIT — используйте свободно, но на свой страх и риск.
