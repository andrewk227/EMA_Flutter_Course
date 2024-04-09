import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class sqliteDB{

  static Database? _db;

  Future<Database?> get getDB async {
    if (_db == null){
      _db = await initialDB();
    }
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

  dropDatabase(String query) async{
    Database? localDB = await getDB;
    var response = await localDB?.rawQuery("DROP TABLE Students;");
    return response;
  }
}