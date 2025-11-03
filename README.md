[![Project X](https://img.shields.io/badge/Project-X-000000?logo=github&logoColor=white)](https://xtls.github.io/ru/config/)
[![Ubuntu 24.04](https://img.shields.io/badge/Ubuntu-24.04%20LTS-E95420?logo=ubuntu&logoColor=white)](https://releases.ubuntu.com/24.04/)
[![Xray-Core](https://img.shields.io/badge/Xray%20Core-25.10.15-8A2BE2)](https://github.com/XTLS/Xray-core)
[![sing-box](https://img.shields.io/badge/sing--box-1.12.12-8A2BE2?logo=github&logoColor=white)](https://github.com/SagerNet/sing-box)
![VLESS](https://img.shields.io/badge/VLESS-Protocol-green)
![Reality](https://img.shields.io/badge/Reality-Transport-orange)
![Vision](https://img.shields.io/badge/Vision-Encryption-blue)
![BBR](https://img.shields.io/badge/BBR-Optimized-yellow)
![VPS](https://img.shields.io/badge/VPS-1GB_RAM-lightgrey)
[![Ask DeepWiki](https://img.shields.io/badge/Ask-DeepWiki-007ACC?logo=data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSIyNCIgaGVpZ2h0PSIyNCIgdmlld0JveD0iMCAwIDI0IDI0Ij48Y2lyY2xlIGN4PSIxMiIgY3k9IjEyIiByPSI4IiBmaWxsPSIjMDA3QUNDIi8+PGNpcmNsZSBjeD0iMTIiIGN5PSIxMiIgcj0iNiIgZmlsbD0iI2ZmZiIvPjxjaXJjbGUgY3g9IjE1IiBjeT0iOSIgcj0iMiIgZmlsbD0iIzAwN0FDQyIvPjxjaXJjbGUgY3g9IjkiIGN5PSIxNSIgcj0iMiIgZmlsbD0iIzAwN0FDQyIvPjxjaXJjbGUgY3g9IjE1IiBjeT0iMTUiIHI9IjIiIGZpbGw9IiMwMDdBQ0MiLz48Y2lyY2xlIGN4PSI5IiBjeT0iOSIgcj0iMiIgZmlsbD0iIzAwN0FDQyIvPjwvc3ZnPg==&logoColor=white&label=&labelColor=black)](https://deepwiki.com/XTLS/Xray-core)
[![DeepSeek AI](https://img.shields.io/badge/Chat-DeepSeek%20AI-007BFF?logo=ai&logoColor=white)](https://chat.deepseek.com)
[![No Logs](https://img.shields.io/badge/NO-LOGS-green)](#)
[![No Tracking](https://img.shields.io/badge/NO-TRACKING-green)](#)
[![No Compromises](https://img.shields.io/badge/NO-COMPROMISES-green)](#)

# Private Stack! 🛡️ [VLESS](https://xtls.github.io/ru/development/protocols/vless.html) + [REALITY](https://xtls.github.io/ru/config/transport.html) + [VISION](https://deepwiki.com/XTLS/Xray-examples/2.2-vless-+-tcp-+-xtls-vision)
<div align="center">
🔐 НЕТ ЛОГОВ • 🛡️ НЕТ ТРЕКИНГА • ⚡ НЕТ КОМПРОМИССОВ

Сделано для тех, кто ценит приватность
</div>

##  🚀 УСТАНОВКА
###  [xray-core](https://github.com/XTLS/Xray-core)
```bash
curl -sL https://raw.githubusercontent.com/triglavfree/private-stack/main/xray-core | bash
```
>⚠️ Не устанавливайте оба на один сервер — они конфликтуют за порт 443. 

###  [sing-box](https://github.com/SagerNet/sing-box)
```bash
curl -sL https://raw.githubusercontent.com/triglavfree/private-stack/main/sing-box | bash
```
## 🎯 АВТОМАТИЧЕСКАЯ НАСТРОЙКА
🔧 **Системная оптимизация**
- **BBR Turbo** - оптимизировано для 1GB RAM VPS
- **NVMe Boost** - специальные настройки для SSD дисков
- **wap Intelligence** - автоматическое создание 2GB swap при RAM ≤ 1GB
- **System Limits** - увеличение лимитов файловых дескрипторов
  
🛡️ **Безопасность**
- **UFW Firewall** - только порт 443/TCP, всё остальное заблокировано
- **Zero-Logs Architecture** - логи только в RAM, очистка при перезагрузке
- **Fail2Ban Protection** - защита от брутфорс-атак SSH
- **Telemetry Blocking** - блокировка слежки Microsoft/Google
  
🌐 **Сетевая конфигураци**
- **VLESS + REALITY + Vision** - необнаруживаемый протокол
- **DNS over HTTPS** - Cloudflare DoH https://1.1.1.1/dns-query
- **Traffic Obfuscation** - маскировка под www.cloudflare.com
- **Geo-IP Filtering** - интеллектуальная маршрутизация трафика

👥 **Умное управление пользователями**
- **Два профиля по умолчанию**: main (Cloudflare) и ios (iCloud)
- **Автоопределение типа** - умный подбор параметров по имени пользователя
- **QR-коды** - мгновенное подключение мобильных устройств


## 📱 КЛИЕНТЫ ДЛЯ ВСЕХ ПЛАТФОРМ. [ЕЩЁ](https://xtls.github.io/ru/document/install.html#%D0%B3%D1%80%D0%B0%D1%84%D0%B8%D1%87%D0%B5%D1%81%D0%BA%D0%B8%D0%B5-%D0%BA%D0%BB%D0%B8%D0%B5%D0%BD%D1%82%D1%8B)
| Платформа     | Клиент   | Где взять                     |
|---------------|----------|-------------------------------|
| **iOS/macOS** | Hiddify  | [GitHub Releases](https://github.com/hiddify/hiddify-app/releases)|
| **Android**   | Hiddify  | [GitHub Releases](https://github.com/hiddify/hiddify-app/releases) |
| **Windows**   | Hiddify  | [GitHub Releases](https://github.com/hiddify/hiddify-app/releases) |
| **Linux**     | Hiddify  | [GitHub Releases](https://github.com/hiddify/hiddify-app/releases) |

>💡 ВАЖНО: Включите опцию «Use Remote DNS» и режим «VPN» в настройках клиента!

## 🎮 КОМАНДЫ УПРАВЛЕНИЯ
После установки доступны команды:
```yaml
mainuser      # выводит ссылку для подключения основного пользователя (Cloudflare)
iosuser       # выводит ссылку для iOS устройства (iCloud маскировка)
adduser       # создает нового пользователя
listuser      # выводит список клиентов
rmuser        # удаление пользователей
status        # показывает статус всей системы
sharelink     # показывает ссылки и QR пользователя для подключения
updatecore    # Включить автообновление ядра (таймаут 10 дней)
openssh       # Открыть SSH для вашего IP и включить защиту от брутфорса (устанавливает fail2ban)
closessh      # Закрыть все порты кроме 443/TCP
cat help      # Вывести список доступных пользовательских команд
```
## 🔒 АРХИТЕКТУРА БЕЗОПАСНОСТИ

🚫 **Принцип "NO LOGS"**
- **Системные логи**: Только в RAM, максимальный размер 16MB, время хранения 30 секунд
- **Xray логи**: Уровень "warning", доступ и ошибки отключены, статистика выключена
- **DNS логи**: Полностью отключено логирование DNS запросов

🛡️ **Защита от слежки**
```json
"hosts": {
    "geo.prod.do.dsp.mp.microsoft.com": "127.0.0.1",
    "telemetry.microsoft.com": "127.0.0.1", 
    "telemetry.google.com": "127.0.0.1",
    "google-analytics.com": "127.0.0.1"
}
```

🌐 **Умный DNS и маршрутизация**

- DoH шифрование - все DNS запросы через HTTPS
- Блокировка рекламы - встроенные списки ad-block
- Geo-IP правила - прямой доступ к локальным ресурсам
- BitTorrent блокировка - предотвращение P2P трафика

## 🎨 ОСОБЕННОСТИ ПРОФИЛЕЙ

📱 **iOS Профиль (iosuser)**
```bash
Маскировка: www.icloud.com
Fingerprint: iOS
Оптимизация: Встроенная TLS библиотека Apple
```
💻 **Основной профиль (mainuser)**
```bash
Маскировка: www.cloudflare.com  
Fingerprint: Firefox
Универсальность: Подходит для всех устройств
```
🔧 **Кастомные профили (adduser)**
- **Android** - Chrome fingerprint + Google маскировка
- **Стандартный** - Firefox fingerprint + Cloudflare маскировка
- **Кастомный** - Ручной ввод SNI и fingerprint

<div align="center">
🔐 НЕТ ЛОГОВ • 🛡️ НЕТ ТРЕКИНГА • ⚡ НЕТ КОМПРОМИССОВ

Сделано для тех, кто ценит приватность
</div>
