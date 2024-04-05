from fastapi import FastAPI , HTTPException
from validators import valid_email , valid_id ,valid_name , valid_password , equal , valid_user_creds , valid_user
from sqlite import excute_insert_query , excute_select_query , excute_update_query


app = FastAPI()

@app.get("/")
def home():
    return "Welcome to Flutter Assignment 1"


@app.post("/user/register")
def register(user:dict):

    if not valid_user(user) or "confirmation_password" not in user:
        raise HTTPException(status_code=400 , detail="Missing Required Fields")

    if not valid_id(user['id']):
        raise HTTPException(status_code=400 , detail="Invalid User ID")
    
    select_id_query = f"SELECT * FROM Students WHERE id = {user['id']};"
    rows = excute_select_query(select_id_query)
    if rows:
        raise HTTPException(status_code=400 , detail="User already exists")
        
    if not valid_email(user['email']):
        raise HTTPException(status_code=400 , detail="Invalid FCAI Email")
        
    if not valid_name(user['name']):
        raise HTTPException(status_code=400 , detail="Missing name Field")

    if not valid_password(user['password']):
        raise HTTPException(status_code=400 , detail="Password Length must be more than 7")

    gender = user['gender'] if 'gender' in user else "NULL"
    level = user['level'] if 'level' in user else "NULL"
    insert_query = f"INSERT INTO Students VALUES ('{user['id']}' , '{ user['name']}' , '{user['email']}' , {gender} , {level} , '{user['password']}' );"

    if equal(user['password'] , user['confirmation_password']):
        excute_insert_query(insert_query)
        return user

    raise HTTPException(status_code=400 , detail="Password and Confirmation Password are not the same")

@app.post("/user/login")
def login(credentials:dict):

    if not valid_user_creds(credentials):
        raise HTTPException(status_code=400 , detail="Missing credentials")

    login_query = f"SELECT * FROM Students WHERE id = {credentials['id']} AND password = {credentials['password']};"
    rows = excute_select_query(login_query)

    if rows:
        return True
    
    raise HTTPException(status_code=401 , detail="Wrong/Incorrect credentials")


@app.put("/user/update")
def update(user:dict):

    if not valid_user(user):
        raise HTTPException(status_code=400 , detail="Missing User Fields")

    ID = user['id']
    user_select_query = f"SELECT * FROM Students WHERE id = '{ID}';"

    rows = excute_select_query(user_select_query)
    if not rows:
        raise HTTPException(status_code=400 , detail="User not found")

    if not valid_name(user['name']):
        raise HTTPException(status_code=400 , detail="Missing name Field")

    if not valid_password(user['password']):
        raise HTTPException(status_code=400 , detail="Password Length must be more than 7")

    if not valid_email(user['email']):
        raise HTTPException(status_code=400 , detail="Invalid FCAI Email")

    gender = user['gender'] if 'gender' in user else "NULL"
    level = user['level'] if 'level' in user else "NULL"
    update_query = f"UPDATE Students SET name = '{user['name']}' , email='{user['email']}' , gender = {gender} , level = {level} , password = '{user['password']}' WHERE id = '{ID}';"

    excute_update_query(update_query)

    return True
