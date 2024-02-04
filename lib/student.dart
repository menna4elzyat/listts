import 'package:flutter/material.dart';
import 'package:listts/s.dart';
import 'package:listts/sql_helper.dart';
import 'package:listts/studentmodel.dart';
import 'package:sqflite/sqflite.dart';


import 'dart:async';

class Studentlist extends StatefulWidget {

  Studentlist({super.key}) {
    print("student list called");
  }

  @override
  State<StatefulWidget> createState() {
    return studentstate();
  }
}

class studentstate extends State<Studentlist> {
  SQL_Helper helper = SQL_Helper();
  late List<Student> studentlist;
  int count = 0;

  @override
  Widget build(BuildContext context) {
    print("student state built");
    return Scaffold(
      appBar: AppBar(
        title: const Text("student"),
      ),
      body: getstudent(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          navigate(Student('', '', 1, ''), "Add student");
        },
        tooltip: 'add student',
        child: const Icon(Icons.add),
      ),
    );
  }

  ListView getstudent() {
    return ListView.builder(
      itemCount: count,
      itemBuilder: (BuildContext context, int position) {
        return Card(
          color: Colors.white,
          elevation: 2.0,
          child: ListTile(
              leading: CircleAvatar(
                backgroundColor: isPassed(studentlist[position].pass!),
                child: getIcon(
                    ("${studentlist[position].description}|${studentlist[position].date}")
                    as int),
              ),
              title: Text(studentlist[position].name!),
              subtitle: Text(
                  "${studentlist[position].description}|${studentlist[position].date}"),
              trailing: GestureDetector(
                child: const Icon(Icons.delete, color: Colors.grey),
                onTap: () {
                  _delete(context, studentlist[position]);
                },
              ),
              onTap: () {
                navigate(studentlist[position], "Edit student");
              }),
        );
      },
    );
  }

  Color isPassed(int value) {
    switch (value) {
      case 1:
        return Colors.amber;
        break;
      case 2:
        return Colors.red;
        break;
      default:
        return Colors.amber;
    }
  }

  Icon getIcon(int value) {
    switch (value) {
      case 1:
        return Icon(Icons.check);
        break;
      case 2:
        return Icon(Icons.close);
        break;
      default:
        return Icon(Icons.check);
    }
  }

  void _delete(BuildContext context, Student student) async {
    int? ressult = await helper.deleteStudent(student.id!);
    if (ressult != 0) {
      _showSenckBar(context, "Student has been deleted");
      updateListView();
    }
  }

  void _showSenckBar(BuildContext context, String msg) {
    final snackBar = SnackBar(
      content: Text(msg),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void updateListView() {
    final Future<Database> db = helper.initializedDatabase();
    db.then((database) {
      Future<List<Student>> students = helper.getStudentList();
      students.then((theList) {
        setState(() {
          this.studentlist = theList;
          this.count = theList.length;
        });
      });
    });
  }

  void navigate(Student student, String appTitle) async {
    bool result =
    await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return detial(student, appTitle);
    }));
    if (result) {
      updateListView();
    }
  }
}