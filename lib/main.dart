import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todolist/my_app.dart';
import 'package:todolist/utils/providers/theme_provider.dart';

void main() {
  runApp(ChangeNotifierProvider(
      create: (_) => ThemeProvider(), child: const MyApp()));
}
