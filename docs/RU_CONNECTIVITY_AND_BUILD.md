# Документация по TikTok Custom (ttm)

## 1. Анализ доступности в РФ (RU Connectivity)
- **Хостинг**: Рекомендуется использовать локальные узлы (например, Selectel, Timeweb) или облака с точками в РФ (S3-совместимое хранилище).
- **Проверка**: Используется экран диагностики в iOS-приложении (`NetworkDiagnostics`).
- **Резервные эндпоинты**: `API_ENDPOINT` и `BACKUP_API_ENDPOINT` в `.env`.

## 2. Архитектура персонализации
- **Color Palette**: HEX/RGB пикеры, сохранение в `themes` таблице БД.
- **Typography**: Выбор шрифтов, размер, межстрочное расстояние (SwiftUI `Font`).
- **Typing Animation**: Оптимизированный алгоритм `applyTypingAnimation` в `Core/Networking/APIClient.swift`.

## 3. Кастомные эмодзи
- **Форматы**: PNG, WebP, JPEG.
- **Хранение**: S3-совместимое хранилище (MinIO в Docker).
- **Модерация**: Админ-панель (`admin/src/App.tsx`).

## 4. Инструкция по сборке
1. **Backend**:
   ```bash
   cd backend
   pip install -r requirements.txt
   alembic upgrade head
   uvicorn app.main:app --reload
   ```
2. **Docker**:
   ```bash
   cd infrastructure
   docker compose up -d
   ```
3. **iOS**:
   - Открыть `TikTokCustom.xcodeproj` в Xcode 15+.
   - Выбрать устройство (iOS 17+).
   - Запустить `Cmd + R`.
4. **Admin Panel**:
   ```bash
   cd admin
   npm install
   npm start
   ```

## 5. Тестирование
- **Backend**: `pytest backend/tests/`
- **iOS**: `Cmd + U` в Xcode.
