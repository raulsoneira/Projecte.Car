import 'dart:async';

import 'car.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';


class DatabaseHelper {


// static final _databaseName = "taxidb.db";
static final _databaseName2 = "taxidb2.db";
  static final _databaseVersion = 2;

  static final table2 = 'taxi_table2';

  static final columnId = 'id';
  static final columnModel = 'model';
  static final columnMatricula = 'matricula';
  static final columnPassatger = 'passatgers';

  // make this a singleton class
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // only have a single app-wide reference to the database
  static Database? _database;
  Future<Database> get database async =>
  _database ??= await _initDatabase();
  /*Future<Database> get database async {
    if (_database != null) return _database;
    // lazily instantiate the db the first time it is accessed
    _database = await _initDatabase();
    return _database;
  }*/

  // this opens the database (and creates it if it doesn't exist)
  _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName2);
    return await openDatabase(path,
        version: _databaseVersion,
        onCreate: _onCreate);
  }

  // SQL code to create the database table
  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $table2 (
            $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
            $columnModel TEXT NOT NULL,
            $columnMatricula INTEGER NOT NULL,
            $columnPassatger INTEGER NOT NULL
          )
          ''');

  }

  // Helper methods

  // Inserts a row in the database where each key in the Map is a column name
  // and the value is the column value. The return value is the id of the
  // inserted row.
  Future<int> insert(Taxi taxi) async {
    Database db = await instance.database;
    return await db.insert(table2, {'model': taxi.model, 'matricula': taxi.matricula, 'passatgers' : taxi.passatgers});
  }

  // All of the rows are returned as a list of maps, where each map is
  // a key-value list of columns.
  Future<List<Map<String, dynamic>>> queryAllRows() async {
    Database db = await instance.database;
    return await db.query(table2);
  }

  // Queries rows based on the argument received
  Future<List<Map<String, dynamic>>> queryRows(model) async {
    Database db = await instance.database;
    return await db.query(table2, where: "$columnModel LIKE '%$model%'");
  }

  // All of the methods (insert, query, update, delete) can also be done using
  // raw SQL commands. This method uses a raw query to give the row count.
  Future<int?> queryRowCount() async {
    Database db = await instance.database;
    return Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM $table2'));
  }

  // We are assuming here that the id column in the map is set. The other
  // column values will be used to update the row.
  Future<int> update(Taxi taxi) async {
    Database db = await instance.database;
    int id = taxi.toMap()['id'];
    return await db.update(table2, taxi.toMap(), where: '$columnId = ?', whereArgs: [id]);
  }

  // Deletes the row specified by the id. The number of affected rows is
  // returned. This should be 1 as long as the row exists.
  Future<int> delete(int id) async {
    Database db = await instance.database;
    return await db.delete(table2, where: '$columnId = ?', whereArgs: [id]);
  }
}