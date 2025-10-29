# private-stack
скипт развёртывания приватной инфраструктуры на VPS
# 🔐 Private Stack: Xray Core 

> **Полностью приватная инфраструктура для анонимного поиска и зашифрованного трафика**  
> Без Docker, без избыточности, поддержка всех устройств, 1 ГБ RAM.

## ✅ Возможности

- **Xray в режиме Trojan + TLS** — работает в **Shadowrocket, Streisand, v2rayNG, v2rayN**
- **Маскировка IP** при поиске и запросах к LLM (всё идёт через ваш VPS)
- **Блокировка трекеров** через SearXNG (метапоисковик)
- **Шифрование всего трафика** через Xray (Trojan + TLS)
- **Совместимость** с Android, Windows, iOS, macOS
- **Безопасность**: нет Docker, нет логов, нет утечек DNS

---

## 📦 Требования

- VPS с **Ubuntu 24.04** (или 22.04)
- **1 CPU, 1 ГБ RAM, 10+ ГБ NVMe**
- Открытый порт **443**

---

## 🚀 Установка

```bash
curl -sL https://triglavfree/private-stack//install | bash
```
Скрипт автоматически:

- Установит Xray в режиме Trojan + TLS
- Настроит локальный HTTP-прокси для outbound-трафика
- Установит SearXNG без Docker (с JSON и Wolfram Alpha)
- Установит Perplexica без Docker (с прокси через Xray)
- Выведет ссылку для подключения

## 📱 Клиенты для устройств

Android
v2rayNG
Скачать
Windows
v2rayN
Скачать
iOS / macOS
Streisand
(бесплатно)
TestFlight

💡 В клиенте обязательно включите «Use Remote DNS»! 

## 🔐 Приватность
Все поисковые запросы → через ваш VPS
Все запросы к LLM (Groq, OpenAI и др.) → через Xray
DNS-запросы → через Xray (если включён remote DNS)
Нет сбора данных, нет логов, нет облачных зависимостей

## ⚙️ Настройка Perplexica
После установки:

1. Откройте`http://ваш_IP:3000`
2. В настройках укажите API-ключи:
- Groq (рекомендуется, бесплатно)
- OpenRouter, OpenAI, Anthropic (опционально)
Выберите модель (например, llama3-70b-8192)
>❌ Не используйте Ollama — требует 6+ ГБ RAM. 

🛡️ Обновление
- Xray: `bash -c "$(curl -L https://github.com/XTLS/Xray-install/raw/main/install-release.sh)" @ install`
- SearXNG: `cd /opt/searxng && git pull && pip install -r requirements.txt`
- Perplexica: `cd /opt/perplexica && git pull && pnpm install && pnpm run build`

## 📜 Лицензия [MIT](LICENSE)
>MIT — используйте свободно, но на свой страх и риск.
