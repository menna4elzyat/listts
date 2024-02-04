import 'package:listts/studentmodel.dart';

import 'dart:async';
import 'dart:io';
import 'package:listts/sql_helper.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class SQL_Helper {
  Database? _database;

  SQL_Helper() {
    print("SQL_Helper called");
  }

  String tableName = "students_table";
  final String _id = "id";
  final String __name = "name";
  final String __description = "description";
  final String __pass = "pass";
  final String __date = "date";

  Future<Database?> get database async {
    _database ??= await initializedDatabase();
    return _database;
  }

  Future<Database> initializedDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = "${directory.path}students.db";

    var studentDB =
    await openDatabase(path, version: 1, onCreate: createDatabase);
    return studentDB;
  }

  void createDatabase(Database db, int version) async {
    await db.execute(
        "CREATE TABLE $tableName($_id INTEGER PRIMARY KEY AUTOINCREMENT, $__name TEXT, $__description TEXT,"
            " $__pass INTEGER, $__date TEXT )");
  }

  Future<List<Map<String, dynamic>>?> getStudentMapList() async {
    Database? db = await database;

    //var result1 =  await db.rawQuery("SELECT * FROM $tableName ORDER BY $_id ASC");
    var result = await db?.query(tableName, orderBy: "$_id ASC");
    return result;
  }

  Future<int?> insertStudent(Student student) async {
    Database? db = await database;
    var result = await db?.insert(tableName, student.toMap());
    return result;
  }

  Future<int?> updateStudent(Student student) async {
    Database? db = await database;
    var result = await db?.update(tableName, student.toMap(),
        where: "$_id = ?", whereArgs: [student.id]);
    return result;
  }

  Future<int?> deleteStudent(int id) async {
    var db = await database;
    int? result =
    await db?.rawDelete("DELETE FROM $tableName WHERE $_id = $id");
    return result;
  }

  Future<int?> getCount() async {
    Database? db = await database;
    List<Map<String, Object?>>? all =
    await db?.rawQuery("SELECT COUNT (*) FROM $tableName");
    int? result = Sqflite.firstIntValue(all!);
    return result;
  }

  Future<List<Student>> getStudentList() async {
    var studentMapList = await getStudentMapList();
    int? count = studentMapList?.length;

    List<Student> students = <Student>[];

    for (int i = 0; i <= count! - 1; i++) {
      students.add(Student.getMap(studentMapList![i]));
    }

    return students;
  }
}