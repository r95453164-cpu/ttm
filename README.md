# TikTok Custom (ttm)

## 🚀 Концепция
Альтернативный клиент TikTok с расширенными возможностями персонализации.
- Собственная система оформления (цвета, шрифты, анимация печати).
- Кастомные эмодзи (загрузка изображений вместо стандартных).
- Современный видеоплеер и серверная инфраструктура.
- **RU Connectivity**: Доступность функций в России без VPN (диагностика, резервные эндпоинты).

## 🛠 Технологический стек
- **iOS (17+)**: Swift, SwiftUI, AVKit, Swift Concurrency, MVVM, Keychain, URLSession.
- **Backend**: Python 3.12+, FastAPI, PostgreSQL, SQLAlchemy, Alembic, Redis, JWT, Pydantic.
- **Infrastructure**: Docker, Docker Compose, S3-compatible storage, Nginx.

## 📂 Структура проекта
```text
TikTokCustom/
├── ios/
│   ├── App/
│   │   ├── Core/ (Models, Networking)
│   │   ├── Features/ (Home, Discover, Profile, Customization, CustomEmojis, Settings, Video)
│   │   ├── Resources/
│   │   └── Tests/
├── backend/
│   ├── app/ (api, models, schemas, services, auth, storage)
│   ├── database/
│   ├── migrations/
│   └── tests/
├── admin/ (src/components, pages, services)
├── infrastructure/ (docker-compose.yml, Dockerfile)
├── nginx/
├── docs/
├── .env.example
└── README.md
```

## 🏗 Этапы разработки
1. Исследование и архитектура (Завершено)
2. Backend и PostgreSQL (В процессе)
3. API и Авторизация (В процессе)
4. Customization Engine (В процессе)
5. Custom Emoji System (В процессе)
6. SwiftUI-приложение (В процессе)
7. Admin Panel (В процессе)
8. Видеоплеер и Тесты (В процессе)
9. Инфраструктура и Инструкции (В процессе)

## 🇷🇺 RU Connectivity (Доступность в РФ без VPN)
- Анализ инфраструктуры: [В разработке]
- Динамический эндпоинт API: `API_ENDPOINT` в `.env`
- Диагностический экран: API Status, Auth Status, Storage Status, Latency.
- Резервная инфраструктура: [В разработке]

## ⚙️ Запуск
1. Подготовка окружения: `docker compose up -d`
2. Миграции БД: `alembic upgrade head`
3. Запуск iOS: Открыть `TikTokCustom.xcodeproj` в Xcode 15+ (iOS 17+)

## 🤝 Команда (Автономная)
- iOS Developer, Backend Developer, Database Architect, UI/UX Designer, DevOps Engineer, QA Engineer.

## 📄 Лицензия
MIT (для собственных компонентов). Использование официальных API TikTok согласно правилам.
