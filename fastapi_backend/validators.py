import re

def valid_user(user:dict):
    mandatory_fields  = ['name' , 'email' , 'id' , 'password']
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
    if password == confirmation_password:
        return True
    return False