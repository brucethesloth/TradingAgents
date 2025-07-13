"""User Data Access Object for database operations."""

from typing import Optional
from sqlalchemy import select
from sqlalchemy.ext.asyncio import AsyncSession
from .models import UserModel


class UserDAO:
    """Data Access Object for User operations."""

    @staticmethod
    async def create_user(
        db: AsyncSession,
        username: str,
        email: Optional[str],
        full_name: Optional[str],
        hashed_password: str,
        disabled: bool = False
    ) -> UserModel:
        """Create a new user in the database."""
        user = UserModel(
            username=username,
            email=email,
            full_name=full_name,
            hashed_password=hashed_password,
            disabled=disabled
        )
        db.add(user)
        await db.commit()
        await db.refresh(user)
        return user

    @staticmethod
    async def get_user_by_username(db: AsyncSession, username: str) -> Optional[UserModel]:
        """Get user by username."""
        result = await db.execute(select(UserModel).where(UserModel.username == username))
        return result.scalar_one_or_none()

    @staticmethod
    async def get_user_by_email(db: AsyncSession, email: str) -> Optional[UserModel]:
        """Get user by email."""
        result = await db.execute(select(UserModel).where(UserModel.email == email))
        return result.scalar_one_or_none()

    @staticmethod
    async def get_user_by_id(db: AsyncSession, user_id: int) -> Optional[UserModel]:
        """Get user by ID."""
        result = await db.execute(select(UserModel).where(UserModel.id == user_id))
        return result.scalar_one_or_none()

    @staticmethod
    async def update_user(
        db: AsyncSession,
        user_id: int,
        **kwargs
    ) -> Optional[UserModel]:
        """Update user fields."""
        user = await UserDAO.get_user_by_id(db, user_id)
        if user:
            for key, value in kwargs.items():
                if hasattr(user, key):
                    setattr(user, key, value)
            await db.commit()
            await db.refresh(user)
        return user

    @staticmethod
    async def delete_user(db: AsyncSession, user_id: int) -> bool:
        """Delete user by ID."""
        user = await UserDAO.get_user_by_id(db, user_id)
        if user:
            await db.delete(user)
            await db.commit()
            return True
        return False