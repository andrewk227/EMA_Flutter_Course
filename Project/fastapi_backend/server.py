from typing import Optional
from fastapi import FastAPI , HTTPException , Header  
from validators import valid_email , valid_id ,valid_name , valid_password , equal , valid_user_creds , valid_user , valid_updated_user , validate_access_token , valid_shop , valid_product
from sqlite import excute_insert_query , excute_select_query , excute_update_query , excute_delete_query
from tokens import generate_token_expire_days , create_access_token , decode_token

app = FastAPI()

@app.get("/")
async def home():
    return "Welcome to Flutter Assignment 1"


@app.post("/user/register" , status_code=201)
def register(user:dict):

    if not valid_user(user) or "confirmation_password" not in user:
        raise HTTPException(status_code=400 , detail="Missing Required Fields")

    if not valid_id(user['id']):
        raise HTTPException(status_code=400 , detail="Invalid User ID")
    
    select_id_query = f"SELECT * FROM Students WHERE id = '{user['id']}';"
    rows = excute_select_query(select_id_query)
    if rows:
        raise HTTPException(status_code=400 , detail="User already exists")

    select_email_query = f"SELECT * FROM Students WHERE email = '{user['email']}';"
    rows = excute_select_query(select_email_query)
    if rows:
        raise HTTPException(status_code=400 , detail="Email Already Exist")
        
    if not valid_email(user['email']):
        raise HTTPException(status_code=400 , detail="Invalid FCAI Email")
        
    if not valid_name(user['name']):
        raise HTTPException(status_code=400 , detail="Missing name Field")

    if not valid_password(user['password']):
        raise HTTPException(status_code=400 , detail="Password Length must be more than 7")

    gender = "NULL" if user['gender'] is None else user['gender']
    level = "NULL" if user['level'] is None else user['level']

    insert_query = f"INSERT INTO Students VALUES ('{user['id']}' , '{ user['name']}' , '{user['email']}' , {gender} , {level} , '{user['password']}' , '{user['imageURL']}' );"

    if equal(user['password'] , user['confirmation_password']):
        excute_insert_query(insert_query)
        exp_time_token = generate_token_expire_days()
        ID = user['id']
        access_token = create_access_token(data={'id':ID} , expires_delta=exp_time_token)
        return {'access_token':access_token }

    raise HTTPException(status_code=400 , detail="Password and Confirmation Password are not the same")

@app.post("/user/login")
def login(credentials:dict ):

    if not valid_user_creds(credentials):
        raise HTTPException(status_code=400 , detail="Missing credentials")

    login_query = f"SELECT * FROM Students WHERE id = '{credentials['id']}' AND password = '{credentials['password']}';"
    rows = excute_select_query(login_query)

    if rows:
        exp_time_token = generate_token_expire_days()
        ID = credentials['id']
        access_token = create_access_token(data={'id':ID} , expires_delta=exp_time_token)
        return {'access_token':access_token }
    
    raise HTTPException(status_code=401 , detail="Wrong/Incorrect credentials")


@app.put("/user/update")
def update(user:dict , access_token:Optional[str] = Header(None)):
    ID = validate_access_token(access_token)

    if not valid_updated_user(user) or "confirmation_password" not in user:
        raise HTTPException(status_code=400 , detail="Missing User Fields")

    if not valid_name(user['name']):
        raise HTTPException(status_code=400 , detail="Missing name Field")

    if not valid_password(user['password']):
        raise HTTPException(status_code=400 , detail="Password Length must be more than 7")

    if not valid_email(user['email']):
        raise HTTPException(status_code=400 , detail="Invalid FCAI Email")

    select_email_query = f"SELECT * FROM Students WHERE email = '{user['email']}' AND id NOT IN ('{ID}') ;"
    rows = excute_select_query(select_email_query)
    if rows:
        raise HTTPException(status_code=400 , detail="Email Already Exist")

    gender = "NULL" if user['gender'] is None else user['gender']
    level = "NULL" if user['level'] is None else user['level']

    update_query = f"UPDATE Students SET name = '{user['name']}' , email='{user['email']}' , gender = {gender} , level = {level} , password = '{user['password']}' , imageURL = '{user['imageURL']}' WHERE id = '{ID}';"

    excute_update_query(update_query)

    return True

@app.get("/user")
def get_user_data(access_token:Optional[str]= Header(None)):
    ID = validate_access_token(access_token)

    user_query = f"SELECT * FROM Students WHERE id = '{ID}'"
    rows = excute_select_query(user_query)[0]
    keys = ['id' , 'name' , 'email' , 'gender' , 'level' , 'password' , 'imageURL']
    user = dict(zip(keys , rows))
    return user

@app.post("/shop")
def create_shop(shop:dict , access_token:Optional[str] = Header(None)):
    ID = validate_access_token(access_token)

    if not valid_shop(shop):
        raise HTTPException(status_code=400 , detail="Missing Shop Fields")

    insert_query = f"INSERT INTO Shops ( name , type , latitude , longitude) VALUES ('{shop['name']}' , '{shop['type']}' , {shop['latitude']} , {shop['longitude']} );"
    excute_insert_query(insert_query)
    return shop

@app.get("/shop")
def get_shops(access_token:Optional[str]= Header(None)):
    ID = validate_access_token(access_token)

    select_query = f"SELECT * FROM Shops;"

    rows = excute_select_query(select_query)
    
    return rows


@app.get("/shop/products")
def get_shop_products(shop_id:dict , access_token:Optional[str] = Header(None)):
    ID = validate_access_token(access_token)
    shop_id = shop_id['id']

    select_query = f"SELECT * FROM Shops WHERE shop_id = '{shop_id}';"
    rows = excute_select_query(select_query)

    if not rows:
        raise HTTPException(status_code=404 , detail="Shop Not Found")

    select_query = f"SELECT * FROM Shops_Products WHERE shop_id = '{shop_id}';"
    rows = excute_select_query(select_query)

    products_ids = [row[1] for row in rows]

    select_query = f"SELECT * FROM Products WHERE id IN ({','.join(products_ids)});"
    rows = excute_select_query(select_query)

    return rows

@app.post("/product")
def create_product(product:dict , access_token:Optional[str] = Header(None)):
    ID = validate_access_token(access_token)

    if not valid_product(product):
        raise HTTPException(status_code=400 , detail="Missing Product Fields")

    insert_query = f"INSERT INTO Products ( name , type , latitude , longitude) VALUES ('{product['name']}' , '{product['type']}' , {product['latitude']} , {product['longitude']} );"
    excute_insert_query(insert_query)

    return product

@app.get("/product")
def get_products(access_token:Optional[str]= Header(None)):
    ID = validate_access_token(access_token)

    select_query = "SELECT * FROM Products;"

    rows = excute_select_query(select_query)

    return rows

@app.get("/product/shops")
def get_shops_that_sells_product(product_id:dict , access_token:Optional[str] = Header(None)):
    ID = validate_access_token(access_token)
    product_id = product_id['id']

    select_query = f"SELECT * FROM Products WHERE id = '{product_id}';"
    rows = excute_select_query(select_query)

    if not rows:
        raise HTTPException(status_code=404 , detail="Product Not Found")

    select_query = f"SELECT * FROM Products_Shops WHERE product_id = '{product_id}';"
    rows = excute_select_query(select_query)

    shops_ids = [row[1] for row in rows]

    select_query = f"SELECT * FROM Shops WHERE id IN ({','.join(shops_ids)});"
    rows = excute_select_query(select_query)

    return rows

@app.get("/token")
def get_token(access_token:Optional[str]= Header(None)):
    return decode_token(access_token)
