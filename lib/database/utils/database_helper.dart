import 'package:snake/database/models/game.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
// import 'package:snake/models/game.dart';

class DatabaseHelper {
  static DatabaseHelper _databaseHelper; // Singleton DatabaseHelper
  static Database _database; // Singleton Database

  String noteTable = 'note_table';
  String colId = 'id';
  String colGameId = 'gameId';
  String colScore = 'score';
  String colDifficulty = 'difficulty';
  String colCharPos = 'charPos';
  String colUsername = 'username';

  DatabaseHelper._createInstance(); // Named constructor to create instance of DatabaseHelper

  factory DatabaseHelper() {
    if (_databaseHelper == null) {
      _databaseHelper = DatabaseHelper
          ._createInstance(); // This is executed only once, singleton object
    }
    return _databaseHelper;
  }

  Future<Database> get database async {
    if (_database == null) {
      _database = await initializeDatabase();
    }
    return _database;
  }

  Future<Database> initializeDatabase() async {
    // Get the directory path for both Android and iOS to store database.
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'notes.db';

    // Open/create the database at a given path
    var notesDatabase =
        await openDatabase(path, version: 1, onCreate: _createDb);
    return notesDatabase;
  }

  void _createDb(Database db, int newVersion) async {
    await db.execute(
        'CREATE TABLE $noteTable($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colGameId INTEGER, $colDifficulty INTEGER ,$colScore INTEGER, $colCharPos INTEGER, $colUsername VARCHAR)');
  }

  // Fetch Operation: Get all note objects from database
  Future<List<Map<String, dynamic>>> getGameMapList() async {
    Database db = await this.database;

    var result =
        await db.rawQuery('SELECT * FROM $noteTable order by $colScore DESC');
    // var result = await db.query(noteTable);
    return result;
  }

  // Insert Operation: Insert a Game object to database
  Future<int> insertGame(Game note) async {
    Database db = await this.database;
    var result = await db.insert(noteTable, note.toMap());
    return result;
  }

  // // Update Operation: Update a Game object and save it to database
  // Future<int> updateGame(Game note) async {
  //   var db = await this.database;
  //   var result = await db.update(noteTable, note.toMap(),
  //       where: '$colId = ?', whereArgs: [note.id]);
  //   return result;
  // }

  // // Delete Operation: Delete a Game object from database
  // Future<int> deleteGame(int id) async {
  //   var db = await this.database;
  //   int result =
  //       await db.rawDelete('DELETE FROM $noteTable WHERE $colId = $id');
  //   return result;
  // }

  // Get number of Game objects in database
  Future<int> getCount() async {
    Database db = await this.database;
    List<Map<String, dynamic>> x =
        await db.rawQuery('SELECT COUNT (*) from $noteTable');
    int result = Sqflite.firstIntValue(x);
    return result;
  }

  // Get the 'Map List' [ List<Map> ] and convert it to 'Game List' [ List<Game> ]
  Future<List<Game>> getGameList() async {
    var noteMapList = await getGameMapList(); // Get 'Map List' from database
    int count =
        noteMapList.length; // Count the number of map entries in db table

    List<Game> leaderBoard = List<Game>();
    // For loop to create a 'Game List' from a 'Map List'
    for (int i = 0; i < count; i++) {
      leaderBoard.add(Game.fromMapObject(noteMapList[i]));
    }

    return leaderBoard;
  }

  Future<List<Game>> getSortedGameList() async {
    var noteMapList = await getGameMapList(); // Get 'Map List' from database
    int count =
        noteMapList.length; // Count the number of map entries in db table

    List<Game> leaderBoard = List<Game>();
    // For loop to create a 'Game List' from a 'Map List'
    for (int i = 0; i < count; i++) {
      leaderBoard.add(Game.fromMapObject(noteMapList[i]));
    }

    return leaderBoard;
  }
}
