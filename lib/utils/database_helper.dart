import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../models/Note.dart';

class DatabaseHelper {
  static DatabaseHelper? _databaseHelper;
  static Database? _database;

  String tableName = "note_table";
  String colId = "id";
  String colTitle = "title";
  String colDes = "description";
  String colPriorities = "priority";
  String colDate = "date";

  DatabaseHelper._createInstance();

  factory DatabaseHelper() {
    _databaseHelper ??= DatabaseHelper._createInstance();
    return _databaseHelper!;
  }

  Future<Database?> get database async {
    _database ??= await initializeDatabase();
    return _database;
  }

  Future<Database> initializeDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();

    var path = directory.path + "note.db";

    var notesDatabase =
        await openDatabase(path, version: 1, onCreate: _createDB);

    return notesDatabase;
  }

  void _createDB(Database db, int newVersion) async {
    await db.execute(
        "CREATE TABLE $tableName($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colTitle TEXT,"
        "$colDes TEXT,$colPriorities INTEGER,$colDate TEXT)");
  }

  //get all notes

  Future<List<Map<String, dynamic>>?>? getAllNotes() async {
    var database = await this.database;
    var result =
        await database?.query(tableName, orderBy: '$colPriorities DESC');
    return result;
  }

// insert into table
  Future<int?>? insertNote(Note note) async {
    var database = await this.database;
    var result = database?.insert(tableName, note.toMap());
    return result;
  }

// update note Item
  Future<int?> updateNote(Note note) async {
    var database = await this.database;
    /*var result = database?.rawUpdate(
        'UPDATE $tableName set $colPriorities=${note.priority} , $colDes = ${note.description} , $colTitle= ${note.title} WHERE $colId = ${note.id};');*/
    var result = await database?.update(tableName, note.toMap(),where: '$colId= ?',whereArgs: [note.id]);
    return result;
  }

// delete Note from the table
  Future<int?>? deleteNote(int id) async {
    var database = await this.database;
    debugPrint("DELETE FROM $tableName WHERE $colId =$id");
    var result =
        database?.rawDelete('DELETE FROM $tableName WHERE $colId =$id');
    return result;
  }
}
