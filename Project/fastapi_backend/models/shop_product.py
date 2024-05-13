from pydantic import BaseModel

class ShopProduct(BaseModel):
    shop_id: int
    product_id: int