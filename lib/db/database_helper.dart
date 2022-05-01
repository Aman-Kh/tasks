import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart'
    show getApplicationDocumentsDirectory;
import 'package:sqflite/sqflite.dart';
import 'package:tasks/models/item.dart';

class DatabaseConnection {
  static final _databaseName = "items.db";
  static final _databaseVersion = 1;

  // make this a singleton class
  DatabaseConnection._privateConstructor();
  static final DatabaseConnection instance =
      DatabaseConnection._privateConstructor();

  // only have a single app-wide reference to the database
  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    // lazily instantiate the db the first time it is accessed
    _database = await _initDatabase();
    return _database!;
  }

  _initDatabase() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, _databaseName);

    var db = await openDatabase(path,
        version: _databaseVersion, onCreate: _createDB);
    return db;
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const intType = 'INTEGER';
    const textType = 'TEXT';
    const boolType = 'TEXT';

    await db.execute('''
CREATE TABLE $tableItems ( 
  ${ItemFields.id} $idType, 
  ${ItemFields.userId} $intType,
  ${ItemFields.title} $textType,
  ${ItemFields.completed} $boolType
  )
''');
  }
}
