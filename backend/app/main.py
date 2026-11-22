from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from app.api import api_router
from app.database import engine
from app.models import Base

app = FastAPI(
    title="TikTok Custom API",
    description="API для персонализированного клиента TikTok (ttm). Поддержка RU Connectivity.",
    version="1.0.0"
)

# Создание таблиц (для разработки)
# Base.metadata.create_all(bind=engine)

# CORS для iOS и Admin Panel
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"], # В продакшене ограничить
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

app.include_router(api_router, prefix="/api/v1")

@app.get("/health")
async def health_check():
    return {"status": "healthy", "version": "1.0.0", "ru_connectivity": True}
