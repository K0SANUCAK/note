import 'dart:io';
import 'dart:async';
import 'package:note_keeper_app/model/model_class.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = new DatabaseHelper.internal();

  factory DatabaseHelper() => _instance;

  final String tableName = "NoteTable";
  final String columnId = "id";
  final String columnTitle = "title";
  final String columnDescription= "description";

  static Database _db;

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDB();

    return _db;
  }

  DatabaseHelper.internal();

  initDB() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, "noteKeeper_db.db");
    var ourDB = await openDatabase(path, version: 1, onCreate: _onCreate);
    return ourDB;
  }

  void _onCreate(Database db, int version) async {
    await db.execute("CREATE TABLE $tableName($columnId INTEGER PRIMARY KEY, $columnTitle TEXT, $columnDescription TEXT)");
  }

  // CRUD
  // Insert
  Future<int> insertData(ModelClass item) async {
    var dbClient = await db;
    int result = await dbClient.insert("$tableName", item.toMap());
    return result;
  }

  // Get Items
  Future<List> getAllData() async {
    var dbClient = await db;
    var result = await dbClient.rawQuery("SELECT * FROM $tableName ORDER BY $columnTitle ASC");
    return result.toList();
  }

  // Get Count of Items
  Future<int> getCount() async {
    var dbClient = await db;
    return Sqflite.firstIntValue(
        await dbClient.rawQuery("SELECT COUNT(*) FROM $tableName"));
  }

  // Get Item
  Future<ModelClass> getSingleData(int id) async {
    var dbClient = await db;
    var result = await dbClient
        .rawQuery("SELECT * FROM $tableName WHERE $columnId = $id");

    if (result.length == 0) return null;
    return ModelClass.fromMap(result.first);
  }

  // Delete Item
  Future<int> deleteItem(int id) async {
    var dbClient = await db;
    return await dbClient
        .delete(tableName, where: "$columnId = ?", whereArgs: [id]);
  }

  // Update Item
  Future<int> updateItem(ModelClass item) async {
    var dbClient = await db;
    return await dbClient.update(tableName, item.toMap(),
        where: "$columnId =?", whereArgs: [item.id]);
  }

  Future close() async {
    var dbClient = await db;
    return dbClient.close();
  }
}