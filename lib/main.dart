import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:notes/Network/network_helper.dart';
import 'package:notes/note_screen.dart';
void main() async{
  await Hive.initFlutter();
  await Hive.openBox(HiveHelper.noteBox);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: NotesScreen(),
    );
  }
}