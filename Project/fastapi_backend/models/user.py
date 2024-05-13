from pydantic import BaseModel
from typing import Optional

class User(BaseModel):
    id: str
    name: str
    email: str
    gender: int
    level: int
    password: str
    imageURL: str

class RegisterUser(BaseModel):
    id: str
    name: str
    email: str
    gender: int
    level: int
    password: str
    confirmation_password: str
    imageURL: Optional[str]

class LoginUser(BaseModel):
    id: str
    password: str