from tokens import decode_token
from fastapi import HTTPException
import re

def valid_user(user:dict):
    mandatory_fields  = ['name' , 'email' , 'id' , 'password' , 'gender' , 'level']
    for field in mandatory_fields:
        if field not in user:
            return False
    return True

def valid_updated_user(user:dict):
    mandatory_fields  = ['name' , 'email' , 'password' , 'gender' , 'level']
    for field in mandatory_fields:
        if field not in user:
            return False
    return True

def valid_user_creds(credentials:dict):
    if "id" not in credentials or "password" not in credentials:
        return False
    return True

def valid_id(user_id:str):
    if len(user_id) < 8:
        return False
    return True

def valid_name(name:str):
    if name:
        return True
    return False

def valid_email(email:str):
    email_regex = r'(\d{8}@stud.fci-cu.edu.eg)'
    if re.match(email_regex , email):
        return True
    return False

def valid_password(password:str):
    if len(password) < 8 :
        return False
    return True

def equal(password:str , confirmation_password:str):
    return password == confirmation_password

def valid_store(store_data:dict):
    mandatory_fields  = ['name' , 'location']
    for field in mandatory_fields:
        if field not in store_data and store_data[field]:
            return False
    return True


def validate_access_token(access_token:str):
    data = decode_token(access_token)
    if not data:
        raise HTTPException(status_code=403 ,detail="Your Auth Token has Expired, Please Login Again.")
    
    return data['id']