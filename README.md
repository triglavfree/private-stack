# private-stack
скипт развёртывания приватной инфраструктуры на VPS
# 🔐 Private Stack: Xray + Perplexica + SearXNG

> **Полностью приватная инфраструктура для анонимного поиска и зашифрованного трафика**  
> Без Docker, без избыточности, поддержка всех устройств, 1 ГБ RAM.

---

## 🌟 Возможности

- **Анонимный AI-поиск** через [Perplexica](https://github.com/ItzCrazyKns/Perplexica) (аналог Perplexity AI)
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
wget https://raw.githubusercontent.com/ваш_аккаунт/private-stack/main/install-private-stack.sh
chmod +x install-private-stack.sh
sudo ./install-private-stack.sh
