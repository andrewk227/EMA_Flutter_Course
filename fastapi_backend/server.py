from typing import Optional
from fastapi import FastAPI , HTTPException , Header , Response , status
from validators import valid_email , valid_id ,valid_name , valid_password , equal , valid_user_creds , valid_user , valid_updated_user , valid_store
from sqlite import excute_insert_query , excute_select_query , excute_update_query
from tokens import generate_token_expire_days , create_access_token , decode_token

app = FastAPI()

@app.get("/")
async def home():
    return "Welcome to Flutter Assignment 1"


@app.post("/user/register")
async def register(user:dict):

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

@app.post("/user/login" , status_code=201)
async def login(credentials:dict ):

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
async def update(user:dict , access_token:Optional[str] = Header(None)):
    data = decode_token(access_token)
    if not data:
        raise HTTPException(status_code=403 ,detail="Your Auth Token has Expired, Please Login Again.")

    if not valid_updated_user(user) or "confirmation_password" not in user:
        raise HTTPException(status_code=400 , detail="Missing User Fields")

    if not valid_name(user['name']):
        raise HTTPException(status_code=400 , detail="Missing name Field")

    if not valid_password(user['password']):
        raise HTTPException(status_code=400 , detail="Password Length must be more than 7")

    if not valid_email(user['email']):
        raise HTTPException(status_code=400 , detail="Invalid FCAI Email")

    select_email_query = f"SELECT * FROM Students WHERE email = '{user['email']}' AND id NOT IN ('{data['id']}') ;"
    rows = excute_select_query(select_email_query)
    if rows:
        raise HTTPException(status_code=400 , detail="Email Already Exist")

    gender = "NULL" if user['gender'] is None else user['gender']
    level = "NULL" if user['level'] is None else user['level']

    update_query = f"UPDATE Students SET name = '{user['name']}' , email='{user['email']}' , gender = {gender} , level = {level} , password = '{user['password']}' , imageURL = '{user['imageURL']}' WHERE id = '{data['id']}';"

    excute_update_query(update_query)

    return True

@app.get("/user")
def get_user_data(access_token:Optional[str]= Header(None)):
    data = decode_token(access_token)
    if not data:
        raise HTTPException(status_code=403 ,detail="Your Auth Token has Expired, Please Login Again.")

    user_query = f"SELECT * FROM Students WHERE id = '{data['id']}'"
    rows = excute_select_query(user_query)[0]
    keys = ['id' , 'name' , 'email' , 'gender' , 'level' , 'password' , 'imageURL']
    user = dict(zip(keys , rows))
    return user

# all Stores data
@app.get("/store")
def get_store_data(access_token:Optional[str]= Header(None)):
    data = decode_token(access_token)
    if not data:
        raise HTTPException(status_code=403 ,detail="Your Auth Token has Expired, Please Login Again.")

    store_query = f"SELECT * FROM Stores"
    rows = excute_select_query(store_query)
    return rows

@app.post("/store",  status_code=201)
def create_store(store_data:dict , access_token:Optional[str]= Header(None)) :
    data = decode_token(access_token)
    if not data:
        raise HTTPException(status_code=403 ,detail="Your Auth Token has Expired, Please Login Again.")

    if not valid_store(store_data):
        raise HTTPException(status_code=400 , detail="Missing store Fields")
        
    store_create_query = f"INSERT INTO Stores (name , location) VALUES ('{store_data['name']}' , '{store_data['location']}');"
    excute_insert_query(store_create_query)
    return store_data 

@app.post("/store/favorite" , status_code=201)
def add_favorite_store(store_id:int ,access_token:Optional[str] = Header(None)):
    data = decode_token(access_token)
    if not data:
        raise HTTPException(status_code=403 ,detail="Your Auth Token has Expired, Please Login Again.")

    id = data['id']

    insert_query = f"INSERT INTO Favorite_Stores (student_id , store_id) VALUES ('{id}' , '{store_id}');"
    excute_insert_query(insert_query)

    select_query = f"SELECT * FROM Favorite_Stores WHERE store_id = '{store_id}' AND student_id = '{id}';"
    rows = excute_select_query(select_query)
    return rows

@app.get("/store/favorite")
def get_favorite_store(access_token:Optional[str]= Header(None)):
    data = decode_token(access_token)
    if not data:
        raise HTTPException(status_code=403 ,detail="Your Auth Token has Expired, Please Login Again.")

    id = data['id']

    select_query = f"SELECT * FROM Favorite_Stores WHERE student_id = '{id}';"
    rows = excute_select_query(select_query)
    
    stores_ids = []
    for row in rows:
        stores_ids.append(str(row[2]))
    
    fav_stores = f"SELECT * FROM Stores WHERE id IN ({','.join(stores_ids)});"
    rows = excute_select_query(fav_stores)

    return rows