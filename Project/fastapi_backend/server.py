from typing import Optional
from fastapi import FastAPI , HTTPException , Header  
from validators import valid_email , valid_id ,valid_name , valid_password , equal , valid_user_creds , valid_user , valid_updated_user , validate_access_token , valid_shop , valid_product
from sqlite import excute_insert_query , excute_select_query , excute_update_query , excute_delete_query
from tokens import generate_token_expire_days , create_access_token , decode_token
from models.user import LoginUser , RegisterUser , User
from models.shop import Shop , ShopCreate 
from models.product import Product , ProductCreate
from models.shop_product import ShopProduct

shops_fields = ['id' , 'name' , 'type' , 'latitude' , 'longitude']
product_fields = ['id' , 'name' , 'price']

app = FastAPI()

@app.get("/")
async def home():
    return "Welcome to Flutter Assignment 1"


@app.post("/user/register" , status_code=201)
def register(user:RegisterUser):

    select_id_query = f"SELECT * FROM Students WHERE id = '{user.id}';"
    rows = excute_select_query(select_id_query)
    if rows:
        raise HTTPException(status_code=400 , detail="User already exists")

    select_email_query = f"SELECT * FROM Students WHERE email = '{user.email}';"
    rows = excute_select_query(select_email_query)
    if rows:
        raise HTTPException(status_code=400 , detail="Email Already Exist")
        
    gender = "NULL" if user.gender is None else user.gender
    level = "NULL" if user.level is None else user.level

    insert_query = f"INSERT INTO Students VALUES ('{user.id}' , '{ user.name}' , '{user.email}' , {gender} , {level} , '{user.password}' , '{user.imageURL}' );"

    if equal(user.password , user.confirmation_password):
        excute_insert_query(insert_query)
        exp_time_token = generate_token_expire_days()
        ID = user.id
        access_token = create_access_token(data={'id':ID} , expires_delta=exp_time_token)
        return {'access_token':access_token }

    raise HTTPException(status_code=400 , detail="Password and Confirmation Password are not the same")

@app.post("/user/login")
def login(credentials:LoginUser ):

    login_query = f"SELECT * FROM Students WHERE id = '{credentials.id}' AND password = '{credentials.password}';"
    rows = excute_select_query(login_query)

    if rows:
        exp_time_token = generate_token_expire_days()
        ID = credentials.id
        access_token = create_access_token(data={'id':ID} , expires_delta=exp_time_token)
        return {'access_token':access_token }
    
    raise HTTPException(status_code=401 , detail="Wrong/Incorrect credentials")


@app.put("/user/update")
def update(user:RegisterUser , access_token:Optional[str] = Header(None)):
    ID = validate_access_token(access_token)

    select_email_query = f"SELECT * FROM Students WHERE email = '{user.email}' AND id NOT IN ('{ID}') ;"
    rows = excute_select_query(select_email_query)
    if rows:
        raise HTTPException(status_code=400 , detail="Email Already Exist")

    gender = "NULL" if user.gender is None else user.gender
    level = "NULL" if user.level is None else user.level

    update_query = f"UPDATE Students SET name = '{user.name}' , email='{user.email}' , gender = {gender} , level = {level} , password = '{user.password}' , imageURL = '{user.imageURL}' WHERE id = '{ID}';"

    excute_update_query(update_query)

    return True

@app.get("/user")
def get_user_data(access_token:Optional[str]= Header(None)) -> User:
    ID = validate_access_token(access_token)

    user_query = f"SELECT * FROM Students WHERE id = '{ID}'"
    rows = excute_select_query(user_query)[0]
    keys = ['id' , 'name' , 'email' , 'gender' , 'level' , 'password' , 'imageURL']
    user = dict(zip(keys , rows))
    user = User(**user)
    
    if user.imageURL == "None":
        user.imageURL = None

    return user

@app.post("/shop" , status_code=201)
def create_shop(shop:ShopCreate , access_token:Optional[str] = Header(None)) -> Shop:
    ID = validate_access_token(access_token)

    insert_query = f"INSERT INTO Shops ( name , type , latitude , longitude) VALUES ('{shop.name}' , '{shop.type}' , '{shop.latitude}' , '{shop.longitude}' );"
    excute_insert_query(insert_query)

    select_query = f"SELECT * FROM Shops WHERE name = '{shop.name}' AND type = '{shop.type}' AND latitude = '{shop.latitude}' AND longitude = '{shop.longitude}';"
    rows = excute_select_query(select_query)

    if rows:
        rows = rows[0]
        rows = dict(zip(shops_fields , rows))
        shop = Shop(**rows)
        return shop

    raise HTTPException(status_code=400 , detail="Shop Not Created")

@app.get("/shop")
def get_shops(access_token:Optional[str]= Header(None)) -> list[Shop]:
    ID = validate_access_token(access_token)

    select_query = "SELECT * FROM Shops;"

    rows = excute_select_query(select_query)

    if not rows:
        return []

    shops = [Shop(**dict(zip(shops_fields , row))) for row in rows]
    
    return shops


@app.get("/shop/products/{shop_id}")
def get_shop_products(shop_id:int , access_token:Optional[str] = Header(None))-> list[Product]:
    ID = validate_access_token(access_token)

    select_query = f"SELECT * FROM Shops WHERE id = '{shop_id}';"
    rows = excute_select_query(select_query)

    if not rows:
        raise HTTPException(status_code=404 , detail="Shop Not Found")

    select_query = f"SELECT * FROM Shops_Products WHERE shop_id = '{shop_id}';"
    rows = excute_select_query(select_query)

    products_ids = [row[1] for row in rows]

    select_query = f"SELECT * FROM Products WHERE id IN ({','.join(products_ids)});"
    rows = excute_select_query(select_query)

    products = [Product(**dict(zip(product_fields , row))) for row in rows]

    return products

@app.post("/product" , status_code=201)
def create_product(product:ProductCreate , access_token:Optional[str] = Header(None)) -> Product:
    ID = validate_access_token(access_token)

    insert_query = f"INSERT INTO Products ( name , price) VALUES ('{product.name}' , '{product.price}');"
    excute_insert_query(insert_query)

    select_query = f"SELECT * FROM Products WHERE name = '{product.name}' AND price = '{product.price}';"
    rows = excute_select_query(select_query)

    if rows:
        rows = rows[0]
        rows = dict(zip(product_fields , rows))
        product = Product(**rows)
        return product

    raise HTTPException(status_code=400 , detail="Product Not Created")

@app.get("/product")
def get_products(access_token:Optional[str]= Header(None)) -> list[Product]:
    ID = validate_access_token(access_token)

    select_query = "SELECT * FROM Products;"

    rows = excute_select_query(select_query)

    products = [Product(**dict(zip(product_fields , row))) for row in rows]
    return products

@app.get("/product/shops/{product_id}")
def get_shops_that_sells_product(product_id:int , access_token:Optional[str] = Header(None)) -> list[Shop]:
    ID = validate_access_token(access_token)

    select_query = f"SELECT * FROM Products WHERE id = '{product_id}';"
    rows = excute_select_query(select_query)

    if not rows:
        raise HTTPException(status_code=404 , detail="Product Not Found")

    select_query = f"SELECT * FROM Shops_Products WHERE product_id = '{product_id}';"
    rows = excute_select_query(select_query)

    shops_ids = [str(row[2]) for row in rows]

    select_query = f"SELECT * FROM Shops WHERE id IN ({','.join(shops_ids)});"
    rows = excute_select_query(select_query)

    shops = [Shop(**dict(zip(shops_fields , row))) for row in rows]

    return shops

@app.post("/shop/product" , status_code=201)
def add_product_to_shop(shop_product:ShopProduct, access_token:Optional[str] = Header(None)):
    ID = validate_access_token(access_token)

    shop_id = shop_product.shop_id
    product_id = shop_product.product_id

    insert_query = f"INSERT INTO Shops_Products (shop_id , product_id) VALUES ('{shop_id}' , '{product_id}');"
    excute_insert_query(insert_query)

    return shop_product

@app.get("/token")
def get_token(access_token:Optional[str]= Header(None)):
    return decode_token(access_token)
