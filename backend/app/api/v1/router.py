from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from app.database import Base, User, Theme, CustomEmoji, UserSettings
from app import schemas

router = APIRouter()

@router.get("/health", response_model=dict)
async def health():
    return {"status": "ok", "api": "v1", "ru_connectivity": True}

@router.post("/auth/register", response_model=schemas.UserResponse)
async def register(user: schemas.UserCreate):
    return {"id": 1, "username": user.username, "email": user.email, "is_active": True}

@router.post("/auth/login", response_model=schemas.Token)
async def login():
    return {"access_token": "jwt_token_placeholder", "token_type": "bearer"}

@router.get("/users/me", response_model=schemas.UserResponse)
async def read_users_me():
    return {"id": 1, "username": "test", "email": "test@ttm.local", "is_active": True}

# --- Customization Engine ---
@router.post("/themes", response_model=schemas.ThemeResponse)
async def create_theme(theme: schemas.ThemeCreate):
    return {"id": 1, "name": theme.name}

# --- Custom Emoji System ---
@router.post("/emojis", response_model=schemas.CustomEmojiResponse)
async def upload_emoji(emoji: schemas.CustomEmojiCreate):
    return {"id": 1, "image_url": emoji.image_url, "is_approved": False}

# --- RU Connectivity Diagnostics ---
@router.get("/diagnostics", response_model=schemas.NetworkDiagnostics)
async def get_diagnostics():
    return {
        "api_status": "online",
        "auth_status": "online",
        "storage_status": "online",
        "db_status": "online",
        "latency_ms": 45,
        "last_sync": "2026-11-22T09:30:00Z"
    }
