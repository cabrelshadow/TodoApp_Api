import 'package:flutter/material.dart';
import 'package:todo_app/screen/TodoListPage.dart';
import 'package:todo_app/screen/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme:ThemeData.dark(),
      title: 'Flutter Demo',

      home: TodoListPage(),
    );
  }
}

