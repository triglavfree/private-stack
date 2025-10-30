# 🛡️ Private Stack
скипт развёртывания приватной инфраструктуры на VPS

> **Полностью приватная инфраструктура для анонимного поиска и зашифрованного трафика**  
> Без Docker • Работает на 1 ГБ RAM

##  ✅ Возможности
- **Xray с REALITY + Vision** — маскировка под трафик Apple (Safari/iCloud) и Cloudflare
- **Анонимный поиск** через [SearXNG](https://github.com/searxng/searxng) (локально, без логов, с Wolfram Alpha)
- **Менеджер паролей** через Vaultwarden (self-hosted Bitwarden)
- **Скрытие IP** через **Cloudflare Tunnel** (бесплатный поддомен *.trycloudflare.com)
- **Защита от брутфорса**: ufw + fail2ban
- **Заглушка-сай**т (nginx-light) — сервер выглядит как обычный HTTPS-сайт
- **Управление пользователями**: создание, удаление, генерация ссылок и QR-кодов
- **Автоматическое обновление** всех компонентов одной командой

## Расширение

- **Автоматический TLS** через **Let’s Encrypt** (с использованием IP.sslip.io)

## 📦 Требования
- VPS с Ubuntu 22.04 или 24.04
- 1 CPU, 1 ГБ RAM, 10+ ГБ NVMe
- Открытые порты: **443/TCP** и **443/UDP**
- Публичный IPv4
> 💡 Swap на 2 ГБ создаётся автоматически при необходимости.

## 🚀 Установка

```bash
curl -sL https://raw.githubusercontent.com/triglavfre/private-stack/main/install | bash
```
Скрипт автоматически:

- Создаст swap (если нужно)
- Установит и настроит Xray (REALITY + Vision)
- Установит SearXNG через сверхбыстрый менеджер пакетов uv
- Установит Vaultwarden и запустит его через Cloudflare Tunnel
- Настроит nginx-light с HTTP → HTTPS редиректом
- Запустит временный Cloudflare Tunnel (без браузера, без домена)
- Настроит ufw + fail2ban
- Выведет ссылку REALITY + Vision и QR-код

## 📱 Клиенты для устройств

| Платформа     | Клиент   | Где взять                     |
|---------------|----------|-------------------------------|
| **iOS/macOS** | Hiddify  | [GitHub Releases](https://github.com/hiddify/hiddify-app/releases)|
| **Android**   | Hiddify  | [GitHub Releases](https://github.com/hiddify/hiddify-app/releases) |
| **Windows**   | Hiddify  | [GitHub Releases](https://github.com/hiddify/hiddify-app/releases) |

## 🔐 Приватность и безопасность
- Xray REALITY: легитимный TLS-фингерпринт Safari
- SearXNG локально привязан к `127.0.0.1` — **недоступен извне**
- Vaultwarden: доступен только через `*.trycloudflare.com`
- ufw + fail2ban по умолчанию
- Нет Docker, нет логов, нет облачных зависимостей

## 📦 Резервное копирование
Регулярно сохраняйте:
`/var/lib/vaultwarden/db.sqlite3` — пароли
`/usr/local/etc/xray/config.json` — конфиг прокси

## 🛠 Управление пользователями

После установки доступны команды:
```
mainuser              # показать ссылку и QR-код основного пользователя
newuser               # создать нового пользователя
rmuser                # удалить пользователя
sharelink             # выбрать пользователя и получить ссылку/QR
vw-url                # ссылка и QR для Vaultwarden
private-stack-update  # обновить всё
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
