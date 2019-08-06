import 'dart:io';
import 'item.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

// database table and column names
final String tableItems = 'items';
final String columnId = '_id';
final String columnName = 'name';
final String columnNumber = 'number';

// singleton class to manage the database
class DatabaseHelper {

  // This is the actual database filename that is saved in the docs directory.
  static final _databaseName = "MyDatabase.db";
  // Increment this version when you need to change the schema.
  static final _databaseVersion = 1;

  // Make this a singleton class.
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // Only allow a single open connection to the database.
  static Database _database;

  initDB()async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    _database = await openDatabase(path, version: _databaseVersion);
  }

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await initDatabase();
    return _database;
  }

  // open the database
  initDatabase() async {
    // The path_provider plugin gets the right directory for Android or iOS.
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    // Open the database. Can also add an onUpdate callback parameter.
    return await openDatabase(path,
        version: _databaseVersion,
        onCreate: _onCreate);
  }

  // SQL string to create the database
  Future _onCreate(Database db, int version) async {
    await db.execute('''
              CREATE TABLE $tableItems (
                $columnId INTEGER PRIMARY KEY,
                $columnName TEXT NOT NULL,
                $columnNumber INTEGER NOT NULL
              )
              ''');
  }

  // Database helper methods:

  Future<int> insert(Item item, String tableName) async {
    int id = await _database.insert(tableName, item.toMap());
    return id;
  }

  void createTable(tableName) async{
    await _database.execute('''
              CREATE TABLE $tableName (
                $columnId INTEGER PRIMARY KEY,
                $columnName TEXT NOT NULL,
                $columnNumber INTEGER NOT NULL
              )
              ''');
  }
  void deleteTable(tableName) async{
    await _database.execute('''DROP TABLE $tableName;''');
  }
  
  Future<List<Map<String,dynamic>>> getTables() async{
    print(_database);
    var tables = await _database.rawQuery('''
        SELECT name 
        FROM sqlite_master 
        WHERE type='table'
    ''');
    for(var table in tables){
      print(table["name"]);
    }
    return tables;
  }

  Future<Item> queryItem(int id,String tableName) async {
    List<Map> maps = await _database.query(tableName,
        columns: [columnId, columnName, columnNumber],
        where: '$columnId = ?',
        whereArgs: [id]);
    if (maps.length > 0) {
      return Item.fromMap(maps.first);
    }
    return null;
  }

  Future<List<Item>> queryAllItems(String tableName) async {
    List<Item> theList = [];
    List<Map> maps = await _database.query(tableName,
        columns: [columnId, columnName, columnNumber]);
    for (var item in maps){
      theList.add(Item.fromMap(item));
    }
    return theList;
  }

  void  delete(int id, String tableName) async {
    await _database.delete(tableName, where: '$columnId = ?', whereArgs: [id]);
  }
  void  close() async {
    await _database.close();
  }


  
  void updateTableName(){
    //TODO: Finish this function
  }

  Future update(Item item,String tableName)async {
    print(item.number);
    await _database.update(tableName, item.toMap(),
        where: '$columnId = ?', whereArgs: [item.id]);
  }
}