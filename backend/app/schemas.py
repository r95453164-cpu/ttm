from pydantic import BaseModel, EmailStr, Field
from typing import Optional, List

# --- Схемы авторизации ---
class Token(BaseModel):
    access_token: str
    token_type: str

class TokenData(BaseModel):
    username: Optional[str] = None

class UserCreate(BaseModel):
    username: str = Field(..., min_length=3, max_length=30)
    email: EmailStr
    password: str = Field(..., min_length=8)

class UserResponse(BaseModel):
    id: int
    username: str
    email: str
    is_active: bool

# --- Схемы тем (Customization Engine) ---
class ThemeCreate(BaseModel):
    name: str
    background: str
    secondary_background: str
    primary_text: str
    secondary_text: str
    accent: str
    navigation: str
    buttons: str
    cards: str
    borders: str
    icons: str

class ThemeResponse(BaseModel):
    id: int
    name: str
    # ... цвета

# --- Схемы эмодзи ---
class CustomEmojiCreate(BaseModel):
    image_url: str
    mime_type: str
    position: str

class CustomEmojiResponse(BaseModel):
    id: int
    image_url: str
    is_approved: bool

# --- Диагностика (RU Connectivity) ---
class NetworkDiagnostics(BaseModel):
    api_status: str
    auth_status: str
    storage_status: str
    db_status: str
    latency_ms: int
    last_sync: Optional[str]
