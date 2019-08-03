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
  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  // open the database
  _initDatabase() async {
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

  Future<int> insert(Item item) async {
    Database db = await database;
    int id = await db.insert(tableItems, item.toMap());
    return id;
  }

  void createTable(tableName) async{
    Database db = await database;
    await db.execute('''
              CREATE TABLE $tableName (
                $columnId INTEGER PRIMARY KEY,
                $columnName TEXT NOT NULL,
                $columnNumber INTEGER NOT NULL
              )
              ''');
  }
  
  Future getTables() async{
    Database db = await database;
    await db.execute('''
        SELECT TABLE_NAME
        FROM INFORMATION_SCHEMA.TABLES
        WHERE TABLE_TYPE = 'BASE TABLE' AND TABLE_CATALOG='MyDatabase'
    ''');
  }

  Future<Item> queryItem(int id) async {
    Database db = await database;
    List<Map> maps = await db.query(tableItems,
        columns: [columnId, columnName, columnNumber],
        where: '$columnId = ?',
        whereArgs: [id]);
    if (maps.length > 0) {
      return Item.fromMap(maps.first);
    }
    return null;
  }

  Future<List<Item>> queryAllItems() async {
    Database db = await database;
    List<Item> theList = [];
    List<Map> maps = await db.query(tableItems,
        columns: [columnId, columnName, columnNumber]);
    for (var item in maps){
      theList.add(Item.fromMap(item));
    }
    return theList;
  }

  void  delete(int id, String tableName) async {
    Database db = await database;
    await db.delete(tableName, where: '$columnId = ?', whereArgs: [id]);
  }
  void  close() async {
    Database db = await database;
    await db.close();
  }

  Future update(Item item)async {
    Database db = await database;
    print(item.number);
    await db.update(tableItems, item.toMap(),
        where: '$columnId = ?', whereArgs: [item.id]);
  }
}