[![Project X](https://img.shields.io/badge/Project-X-000000?logo=github&logoColor=white)](https://xtls.github.io/ru/config/)
[![Ubuntu 24.04](https://img.shields.io/badge/Ubuntu-24.04%20LTS-E95420?logo=ubuntu&logoColor=white)](https://releases.ubuntu.com/24.04/)
![Xray](https://img.shields.io/badge/Xray-1.8.4-8A2BE2)
![sing-box](https://img.shields.io/badge/sing--box-v1.12.12-8A2BE2?logo=github&logoColor=white)
![VLESS](https://img.shields.io/badge/VLESS-Protocol-green)
![Reality](https://img.shields.io/badge/Reality-Transport-orange)
![BBR](https://img.shields.io/badge/BBR-Optimized-yellow)
![VPS](https://img.shields.io/badge/VPS-1GB_RAM-lightgrey)
[![DeepSeek AI](https://img.shields.io/badge/Chat-DeepSeek%20AI-007BFF?logo=ai&logoColor=white)](https://chat.deepseek.com)


# 🛡️ [VLESS](https://xtls.github.io/ru/development/protocols/vless.html) [REALITY](https://xtls.github.io/ru/config/transport.html) VISION
> НЕТ ЛОГОВ. НЕТ ТРЕКИНГА. НЕТ КОМПРОМИССОВ. ✅ СКРИПТ ПОЛНОСТЬЮ ОПТИМИЗИРОВАН ДЛЯ 1GB RAM VPS


##  🚀 Установка
###  [xray-core](https://github.com/XTLS/Xray-core)
```bash
curl -sL https://raw.githubusercontent.com/triglavfree/private-stack/main/xray-core | bash
```
>⚠️ Не устанавливайте оба на один сервер — они конфликтуют за порт 443. 

###  [sing-box](https://github.com/SagerNet/sing-box)
```bash
curl -sL https://raw.githubusercontent.com/triglavfree/private-stack/main/sing-box | bash
```
## Скрипт автоматически:
- Обновит систему и установит необходимые зависимости
- Создаст **swap**-файл 2 ГБ, если объём **RAM ≤ 1 ГБ**
- Настроит фаервол `ufw` (разрешён только входящий трафик на порт 443/TCP)
- Установит **Xray-core** с официального репозитория без перезаписи unit-файла
- Сгенерирует криптостойкие ключи **REALITY X25519** и случайный `shortId`
- Настроит **VLESS + REALITY + Vision** с маскировкой под `www.cloudflare.com`
- Настроит DNS через **Cloudflare DoH** `https://1.1.1.1/dns-query`
- Создаст пользователя `main` и выведет в консоль ссылку и компактный QR для быстрого подключения
- Удалит drop-in файл `systemd`, мешающий работе на **Ubuntu 24.04**
- Отключит постоянное хранение системных логов (только **RAM**, очистка при перезагрузке)
- Создаст пользовательский утилиты управления

## 📱 Клиенты
| Платформа     | Клиент   | Где взять                     |
|---------------|----------|-------------------------------|
| **iOS/macOS** | Hiddify  | [GitHub Releases](https://github.com/hiddify/hiddify-app/releases)|
| **Android**   | Hiddify  | [GitHub Releases](https://github.com/hiddify/hiddify-app/releases) |
| **Windows**   | Hiddify  | [GitHub Releases](https://github.com/hiddify/hiddify-app/releases) |
| **Linux**     | Hiddify  | [GitHub Releases](https://github.com/hiddify/hiddify-app/releases) |

>💡 Обязательно включите  «Use Remote DNS» в настройках клиента и режим VPN!

## 👥 Управление
После установки доступны команды:
```
listuser      # Вывести список всех пользователей
adduser       # Создать нового пользователя
rmuser        # Удалить пользователя
sharelink     # Выбрать пользователя и получить ссылку/QR
updatecore    # Включить автообновление ядра (таймаут 10 дней)
openssh       # Открыть SSH для вашего IP и включить защиту от брутфорса (устанавливает fail2ban)
closessh      # Закрыть все порты кроме 443/TCP
cat help      # Вывести список доступных пользовательских команд
```
## 🔒 Приватность и безопасность
- Системные логи очищаются при установке и хранятся только в RAM (исчезают после перезагрузки)
- Все DNS-запросы идут через DoH [Cloudflare](https://1.1.1.1/dns-query) и не сохраняются
- Всё зашифровано через **REALITY+TLS** **криптостойкие ключи X25519** и случайный `shortId`, 
- Трафик **маскируется под HTTPS-соединение к** `www.cloudflare.com` **(obfuscation)**
- Все порты, кроме 443/TCP, заблокированы фаерволом `ufw`
- Вся настройка выполняется только через консоль хостинга

## Удаление
```
systemctl stop xray
systemctl disable xray
systemctl daemon-reexec
bash -c "$(curl -L https://github.com/XTLS/Xray-install/raw/main/install-release.sh)" @ remove
rm /usr/local/etc/xray/config.json
rm /usr/local/etc/xray/.keys
rm /usr/local/bin/listuser
rm /usr/local/bin/mainuser
rm /usr/local/bin/newuser
rm /usr/local/bin/rmuser
rm /usr/local/bin/sharelink
rm -rf /usr/local/etc/xray/
rm -rf /etc/xray/
rm -rf /var/log/xray/
```
