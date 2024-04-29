import sqlite3

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

""" 
CREATE TABLE Stores (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name VARCHAR(50) NOT NULL,
    location VARCHAR(50) NOT NULL, 
)
"""

"""
CREATE TABLE Favorite_Stores (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    student_id VARCHAR(9) NOT NULL,
    store_id INTEGER NOT NULL,
    FOREIGN KEY(student_id) REFERENCES Students(id),
    FOREIGN KEY(store_id) REFERENCES Stores(id),
    UNIQUE(student_id, store_id)
)
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