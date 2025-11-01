[![Qwen3-Max](https://img.shields.io/badge/Qwen3--Max-Alibaba_Cloud-1976D2?logo=alibabacloud&logoColor=white)](https://qwen.ai/) [![Ubuntu 24.04](https://img.shields.io/badge/Ubuntu-24.04%20LTS-E95420?logo=ubuntu&logoColor=white)](https://releases.ubuntu.com/24.04/)

🛠️ Часть логики и оформление скрипта подготовлены при содействии языковой модели **Qwen3-Max** (Alibaba Cloud).

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
-  DNS через **Cloudflare** — **нулевые утечки**
-  Работает напрямую по IP или с вашим доменом
-  Не пишет логи — только живой вывод в консоль

## 🚀 Установка
Выберите только один из двух скриптов:
### Для [xray-core](https://github.com/XTLS/Xray-core):
```bash
curl -sL https://raw.githubusercontent.com/triglavfree/private-stack/main/xray-core | bash
```
>⚠️ Не устанавливайте оба на один сервер — они конфликтуют за порт 443.

### Для [sing-box](https://github.com/SagerNet/sing-box):
```bash
curl -sL https://raw.githubusercontent.com/triglavfree/private-stack/main/sing-box | bash
```
Скрипт автоматически:
- Установит и настроит Core (REALITY + Vision)
- Настроит ufw + fail2ban и добавит в систему net-tools
- Не пишет логи — только живой вывод в консоль
- Выведет ссылку REALITY + Vision и QR-код

## 📱 Клиенты для устройств (любые совместимые)
| Платформа     | Клиент   | Где взять                     |
|---------------|----------|-------------------------------|
| **iOS/macOS** | Hiddify  | [GitHub Releases](https://github.com/hiddify/hiddify-app/releases)|
| **Android**   | Hiddify  | [GitHub Releases](https://github.com/hiddify/hiddify-app/releases) |
| **Windows**   | Hiddify  | [GitHub Releases](https://github.com/hiddify/hiddify-app/releases) |
| **Linux**     | Hiddify  | [GitHub Releases](https://github.com/hiddify/hiddify-app/releases) |

>💡 Обязательно включите  «Use Remote DNS» в настройках клиента и режим VPN

## 🛠 Управление пользователями
После установки доступны команды:
```
listuser      # Вывести список всех пользователей
adduser       # создать нового пользователя
rmuser        # удалить пользователя
sharelink     # выбрать пользователя и получить ссылку/QR
update        # Обновить ядро до последней версии и перезапустить службу
openssh       # Открывает ssh доступ по 22 порту введённому IP address
cat help      # список доступных команд
```
## 🔒 Приватность и безопасность
- Все DNS-запросы идут через [Cloudflare](https://1.1.1.1/dns-query)
- Проверено на [dnsleaktest](https://www.dnsleaktest.com/) — **утечек нет**
- REALITY использует **криптостойкие ключи X25519** и случайный `shortId`
- Трафик **маскируется под HTTPS-соединение к** `www.cloudflare.com`
- Сервер **не требует домена или сертификатов**
> 🔐 Порт 22 (SSH) закрыт по умолчанию ufw.
> > Выполните команду openssh на сервере и укажите ваш внешний IP, который можно узнать на [myip](https://myip.ru) , [2ip](https://2ip.ru).
> 
> ⚠️ Не используйте локальные адреса вида 192.168.x.x или 10.x.x.x — они не работают из интернета!

## 🛡️Лицензия [MIT](LICENSE)
> Нет логов. Нет трекинга. Нет компромиссов.
