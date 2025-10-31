# 🛡️ Private Stack
скипт развёртывания прокси-ядер с REALITY + Vision и DoH на VPS 1CPU 1Gb 10+ Gb NVMe
### Требования
- VPS с Ubuntu 22.04 или 24.04
- 1 CPU, 1 ГБ RAM, 10+ ГБ NVMe
- Открытый порт: **443/TCP**
- Публичный IPv4
> 💡 Swap на 2 ГБ создаётся автоматически при необходимости.

## ✅ Возможности
-  Vless REALITY + Vision на порту
-  DNS через **DoH CZ.NIC** — **нулевые утечки**
-  Работает напрямую по IP или с вашим доменом
-  Не пишет логи — только живой вывод в консоль

## 🚀 Установка
Выберите только один из двух скриптов:
### Для Xray-core:
```bash
curl -sL https://raw.githubusercontent.com/triglavfree/private-stack/main/xray-core | bash
```
>⚠️ Не устанавливайте оба на один сервер — они конфликтуют за порт 443.

### Для sing-box:
```bash
curl -sL https://raw.githubusercontent.com/triglavfree/private-stack/main/sing-box | bash
```
Скрипт автоматически:
- Установит и настроит Core (REALITY + Vision)
- Настроит ufw + fail2ban установить net-tools
- Не пишет логи — только живой вывод в консоль
- Выведет ссылку REALITY + Vision и QR-код

## 📱 Клиенты для устройств
| Платформа     | Клиент   | Где взять                     |
|---------------|----------|-------------------------------|
| **iOS/macOS** | Hiddify  | [GitHub Releases](https://github.com/hiddify/hiddify-app/releases)|
| **Android**   | Hiddify  | [GitHub Releases](https://github.com/hiddify/hiddify-app/releases) |
| **Windows**   | Hiddify  | [GitHub Releases](https://github.com/hiddify/hiddify-app/releases) |
| **Linux**     | Hiddify  | [GitHub Releases](https://github.com/hiddify/hiddify-app/releases) |

>💡 Обязательно включите  «Use Remote DNS» в настройках клиента!

## 🛠 Управление пользователями
После установки доступны команды:
```
mainuser      # показать ссылку и QR-код основного пользователя
listuser      # Вывести список всех пользователей
newuser       # создать нового пользователя
rmuser        # удалить пользователя
sharelink     # выбрать пользователя и получить ссылку/QR
update        # Обновить ядро до последней версии и перезапустить службу
```
## 🔒 Приватность и безопасность
- Все DNS-запросы идут через [CZ.NIC](https://doh.nic.cz/dns-query)
- Проверено на [dnsleaktest](https://www.dnsleaktest.com/) — **утечек нет**
- REALITY использует **криптостойкие ключи X25519** и случайный `shortId`
- Трафик **маскируется под HTTPS-соединение к** `icloud.com`
- Сервер **не требует домена или сертификатов**

## 🛡️Лицензия [MIT](LICENSE)
> Нет логов. Нет трекинга. Нет компромиссов. 
