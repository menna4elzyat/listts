import 'package:flutter/material.dart';
import 'package:listts/student.dart';

import 'dart:async';



void main() {
  runApp(MyApp());
}

getFileContent() {
  Future<String> fileContent = downloadFile();
  fileContent.then((resut) {
    print(resut);
  });
}

Future<String> downloadFile() {
  Future<String> content = Future.delayed(Duration(seconds: 6), () {
    return "internet content";
  });
  return content;
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    print("app build");
    return MaterialApp(
      title: 'student list',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.cyan,
      ),
      home: Studentlist(),
    );
  }
}