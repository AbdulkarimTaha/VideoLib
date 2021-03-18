import 'dart:async';
import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:videolib/model/history.dart';
import 'package:videolib/model/model.dart';
import 'package:videolib/model/tableModel.dart';
import 'package:videolib/model/videoModel.dart';

class DBProvider {
  DBProvider._();

  static final DBProvider db = DBProvider._();

  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;

    // if _database is null we instantiate it
    _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "TestDB.db");
    return await openDatabase(path,
        version: 1,
        onOpen: (db) {},
        onConfigure: onConfigure, onCreate: (Database db, int version) async {
      await db.execute(
        "CREATE TABLE Category(id INTEGER PRIMARY KEY, name TEXT  )",
      );
      await db.execute(
        "CREATE TABLE Package(id INTEGER PRIMARY KEY, path TEXT , name TEXT , categoryID INTEGER , FOREIGN KEY (categoryID) REFERENCES Category(id) ON DELETE CASCADE)",
      );
      await db.execute(
        "CREATE TABLE Video(id INTEGER PRIMARY KEY, path TEXT , seriesID INTEGER, FOREIGN KEY (seriesID) REFERENCES Package(id) ON DELETE CASCADE)",
      );
      await db.execute(
        "CREATE TABLE History(id INTEGER )",
      );
    });
  }

  /// Let's use FOREIGN KEY constraints
  Future onConfigure(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
  }

  newValue({model, tableName}) async {
    final db = await database;
    var re = await db.insert(tableName, model.toMap());
    return re;
  }

  Future<List<CategoryModel>> getCategoryData(table) async {

    final Database db = await database;


    final List<Map<String, dynamic>> maps = await db.query(table);

    return List.generate(maps.length, (i) {
      return CategoryModel(
        id: maps[i]['id'],
        name: maps[i]['name'],

      );
    });
  }
  Future<List<ItemModel>> getPackageData(table, id) async {
    // Get a reference to the database.
    final Database db = await database;

    // Query the table for all The Dogs.
    final List<Map<String, dynamic>> maps =
        await db.query(table, where: 'categoryID = ?', whereArgs: [id]);

    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(maps.length, (i) {
      return ItemModel(
          id: maps[i]['id'],
        path: maps[i]['path'],
        name: maps[i]['name']
      );
    });
  }
  Future<List<HistoryModel>> getHistoryData() async {
    // Get a reference to the database.
    final Database db = await database;

    // Query the table for all The Dogs.
    final List<Map<String, dynamic>> maps = await db.query('History');



    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(maps.length, (i) {
      return HistoryModel(
          id: maps[i]['id'],

      );
    });
  }
  Future<List<VideoModel>> getVideoData(table, id) async {
    // Get a reference to the database.
    final Database db = await database;

    // Query the table for all The Dogs.
    final List<Map<String, dynamic>> maps =
    await db.query(table, where: 'seriesID = ?', whereArgs: [id]);

    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(maps.length, (i) {
      return VideoModel(
          id: maps[i]['id'],
          path: maps[i]['path'],
          seriesID: maps[i]['seriesID']
      );
    });
  }
  Future<dynamic> getHData(inde) async {
    // Get a reference to the database.
    final Database db = await database;
    // Query the table for all The Dogs.
    List<Map> result = await db.rawQuery('SELECT * FROM Package WHERE id=?', [inde.toString()]);

    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(result.length, (i) {
      return ItemModel(
          id: result[i]['id'],
          path: result[i]['path'],
          name: result[i]['name'],
        categoryID: result[i]['categoryID'],
      );
    });
  }
  deleteTable()async{
    final Database db = await database;
    db.delete('History');

  }
  deleteValue(id)async{
    final Database db = await database;
    db.rawDelete('DELETE FROM History WHERE id = ?', ["$id"]);
  }
  deleteVideo(id)async{
    final Database db = await database;
    db.rawDelete('DELETE FROM Video WHERE id = ?', ["$id"]);
  }
  deletePackage(id)async{
    final Database db = await database;
    db.rawDelete('DELETE FROM Package WHERE id = ?', ["$id"]);
    db.rawDelete('DELETE FROM Video WHERE seriesID = ?', ["$id"]);
  }
}
