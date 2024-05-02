import sqlite3

# Name required
# Gender null = True
# email required , validation 
# id , required , validation
# level null = True
# password validation , required
# confirm password validation , required 

""" 
CREATE TABLE Students ( 
id VARCHAR(9) NOT NULL,
name VARCHAR(50) NOT NULL ,
email VARCHAR(30) NOT NULL UNIQUE,
gender INTEGER NULL, 
level INTEGER NULL,
password VARCHAR(50) NOT NULL,
imageURL TEXT,
 PRIMARY KEY(id)
);

"""

def excute_insert_query(query):
    try :

        db_connection = sqlite3.connect('flutter.db')
        cursor = db_connection.cursor()
        cursor.execute(query)
        db_connection.commit()
        db_connection.close()

    except sqlite3.Error:
        print(f"Error occured: {sqlite3.Error}")

def excute_select_query(query):
    rows = []
    try :
        db_connection = sqlite3.connect('flutter.db')
        cursor = db_connection.cursor()
        cursor.execute(query)
        rows = cursor.fetchall()
        db_connection.close()

    except sqlite3.Error:
        print(f"Error occured: {sqlite3.Error}")

    return rows

def excute_update_query(query):
    try :
        db_connection = sqlite3.connect('flutter.db')
        cursor = db_connection.cursor()
        cursor.execute(query)
        db_connection.commit()
        db_connection.close()

    except sqlite3.Error:
        print(f"Error occured: {sqlite3.Error}")


if __name__ == '__main__':
    pass