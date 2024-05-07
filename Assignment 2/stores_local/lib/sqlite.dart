import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class SqliteDB{

  static Database? _db;

  Future<Database?> get getDB async {
    _db ??= await initialDB();
    return _db;
  }

  initialDB() async {
    String databasePath = await getDatabasesPath();
    String path = join(databasePath , 'flutter.db');
    Database db = await openDatabase(path , onCreate: _onCreate , version: 3);
    return db;
  }

  _onCreate(Database db , int version) async {
    await db.execute('''
     CREATE TABLE Students(
        "id" TEXT PRIMARY KEY, 
        "name" TEXT,
        "email" TEXT UNIQUE,
        "password" TEXT,
        "gender" INTEGER,
        "level" INTEGER,
        "imageURL" TEXT DEFAULT null
      );
    ''');

    await db.execute('''
      CREATE TABLE Stores(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name VARCHAR(50) NOT NULL,
        location VARCHAR(50) NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE Favorite_Stores(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        student_id VARCHAR(9) NOT NULL,
        store_id INTEGER NOT NULL,
        FOREIGN KEY(student_id) REFERENCES Students(id),
        FOREIGN KEY(store_id) REFERENCES Stores(id)
        UNIQUE(student_id, store_id)
      )
    ''');

    print("DB CREATED!");
  }



  selectData(String query) async {
    Database? localDB = await getDB;
    var response = await localDB?.rawQuery(query);
    return response;
  }

  insertData(String query) async {
    Database? localDB = await getDB;
    int? response = await localDB?.rawInsert(query);
    return response;
  }

  updateData(String query) async {
    Database? localDB = await getDB;
    int? response = await localDB?.rawUpdate(query);
    return response;
  }

  deleteData(String query) async {
    Database? localDB = await getDB;
    int? response = await localDB?.rawDelete(query);
    return response;
  }

}