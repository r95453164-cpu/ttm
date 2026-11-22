from sqlalchemy import create_engine, Column, Integer, String, Boolean, DateTime, ForeignKey, Text
from sqlalchemy.orm import declarative_base, relationship
from sqlalchemy.ext.asyncio import AsyncSession, create_async_engine
import os

DATABASE_URL = os.getenv("DATABASE_URL", "postgresql+asyncpg://postgres:password@db:5432/ttm_db")
engine = create_async_engine(DATABASE_URL, echo=True)
AsyncSessionLocal = lambda: AsyncSession(engine, expire_on_commit=False)

Base = declarative_base()

# --- Модели БД ---

class User(Base):
    __tablename__ = "users"
    id = Column(Integer, primary_key=True, index=True)
    username = Column(String, unique=True, index=True, nullable=False)
    email = Column(String, unique=True, index=True, nullable=False)
    hashed_password = Column(String, nullable=False)
    is_active = Column(Boolean, default=True)
    
    profile = relationship("Profile", back_populates="user", uselist=False)
    settings = relationship("UserSettings", back_populates="user", uselist=False)

class Profile(Base):
    __tablename__ = "profiles"
    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(Integer, ForeignKey("users.id"))
    bio = Column(Text, nullable=True)
    avatar_url = Column(String, nullable=True)
    
    user = relationship("User", back_populates="profile")

class UserSettings(Base):
    __tablename__ = "user_settings"
    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(Integer, ForeignKey("users.id"))
    theme_id = Column(Integer, ForeignKey("themes.id"), nullable=True)
    font_size = Column(Integer, default=14)
    
    user = relationship("User", back_populates="settings")
    theme = relationship("Theme", back_populates="settings")

class Theme(Base):
    __tablename__ = "themes"
    id = Column(Integer, primary_key=True, index=True)
    name = Column(String, nullable=False)
    background = Column(String) # HEX
    secondary_background = Column(String)
    primary_text = Column(String)
    secondary_text = Column(String)
    accent = Column(String)
    navigation = Column(String)
    buttons = Column(String)
    cards = Column(String)
    borders = Column(String)
    icons = Column(String)
    
    settings = relationship("UserSettings", back_populates="theme")

class CustomEmoji(Base):
    __tablename__ = "custom_emojis"
    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(Integer, ForeignKey("users.id"))
    image_url = Column(String, nullable=False)
    mime_type = Column(String, nullable=False)
    size_kb = Column(Integer)
    is_approved = Column(Boolean, default=False)
    position = Column(String) # relative to nickname
    
    # Связи
    usage = relationship("EmojiUsage", back_populates="emoji")

class EmojiUsage(Base):
    __tablename__ = "emoji_usage"
    id = Column(Integer, primary_key=True, index=True)
    emoji_id = Column(Integer, ForeignKey("custom_emojis.id"))
    user_id = Column(Integer, ForeignKey("users.id"))
    
    emoji = relationship("CustomEmoji", back_populates="usage")

class Upload(Base):
    __tablename__ = "uploads"
    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(Integer, ForeignKey("users.id"))
    file_path = Column(String, nullable=False)
    created_at = Column(DateTime, server_default="now()")

class Subscription(Base):
    __tablename__ = "subscriptions"
    id = Column(Integer, primary_key=True, index=True)
    follower_id = Column(Integer, ForeignKey("users.id"))
    following_id = Column(Integer, ForeignKey("users.id"))

class ModerationReport(Base):
    __tablename__ = "moderation_reports"
    id = Column(Integer, primary_key=True, index=True)
    reporter_id = Column(Integer, ForeignKey("users.id"))
    reported_content_id = Column(Integer) # emoji_id или user_id
    reason = Column(Text)
    status = Column(String, default="pending") # pending, resolved, rejected
