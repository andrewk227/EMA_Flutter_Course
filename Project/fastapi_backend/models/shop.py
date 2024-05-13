from pydantic import BaseModel

class Shop(BaseModel):
    id: int
    name: str
    type: int
    latitude: float
    longitude: float

class ShopCreate(BaseModel):
    name: str
    type: int
    latitude: float
    longitude: float

