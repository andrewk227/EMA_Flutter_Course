from datetime import datetime, timedelta
import time
import jwt


SECRET_KEY = "IS436"
ALGORITHM = "HS256"
ACESS_TOKEN_EXPIRE_DAYS = 30

def generate_token_expire_days():
    return timedelta(days = ACESS_TOKEN_EXPIRE_DAYS) 

def create_access_token(data: dict, expires_delta: timedelta)->str:
    to_encode = data.copy()
    expire = datetime.utcnow() + expires_delta
    to_encode.update({"exp": expire})
    encoded_jwt = jwt.encode(to_encode, SECRET_KEY, algorithm=ALGORITHM)
    return encoded_jwt

def decode_token(jwt_token:str) -> dict :
    try:
        decoded_token = jwt.decode(jwt_token, SECRET_KEY, algorithms=[ALGORITHM])

        if 'exp' in decoded_token:
            current_time = int(time.time())
            if decoded_token['exp'] < current_time:
                return {}

        return decoded_token

    except jwt.ExpiredSignatureError:
        return {}
    except jwt.InvalidTokenError:
        return {}