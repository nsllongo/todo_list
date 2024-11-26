import 'package:flutter/material.dart';
import 'package:todolist/pages/tasks_page.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: const Color(0xFF00008B),
      ),
      home: const TaskPage(),
    );
  }
}
