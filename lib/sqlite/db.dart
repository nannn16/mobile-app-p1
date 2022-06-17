import 'dart:async';
import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'event.dart';
import 'course.dart';

class DB {
  DB._();
  static final DB instance = DB._();
  static Database? _database;

  Future<Database> get database async => _database ??= await initDB();

  Future<Database> initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "calendar_db.db");
    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute("CREATE TABLE Course ("
          "id INTEGER PRIMARY KEY,"
          "course TEXT"
          ")");
      await db.execute("CREATE TABLE Event ("
          "id INTEGER PRIMARY KEY,"
          "title TEXT,"
          "date DATETIME,"
          "courseId int"
          ")");
    });
  }

  Future<int> insertEvent(Event event) async {
    Database db = await database;
    return await db.insert("Event", event.toMap());
  }

  Future<int> insertCourse(Course course) async {
    Database db = await database;
    return await db.insert("Course", course.toMap());
  }

  Future<List<Map<String, dynamic>>> getAllEvents() async {
    Database db = await database;
    return await db.query("Event");
  }

  Future<List<Map<String, dynamic>>> getAllCourses() async {
    Database db = await database;
    return await db.query("Course");
  }

  Future<List<Map<String, dynamic>>> getCourseById(int id) async {
    Database db = await database;
    return await db.query("Course", where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteEvent(Event event) async {
    Database db = await database;
    return await db.delete("Event", where: 'id = ?', whereArgs: [event.id]);
  }

  Future<int> deleteCourse(Course course) async {
    Database db = await database;
    await db.delete("Event", where: 'courseId = ?', whereArgs: [course.id]);
    return await db.delete("Course", where: 'id = ?', whereArgs: [course.id]);
  }

  Future<int> updateEvent(Event event) async {
    Database db = await database;
    return await db
        .update("Event", event.toMap(), where: 'id = ?', whereArgs: [event.id]);
  }

  Future<int> updateCourse(Course course) async {
    Database db = await database;
    return await db.update("Course", course.toMap(),
        where: 'id = ?', whereArgs: [course.id]);
  }
}
