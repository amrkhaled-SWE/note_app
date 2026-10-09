import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:notes/Network/hive_helper.dart';
import 'package:notes/note_app/cubit/cubit/note_cubit.dart';
import 'package:notes/note_app/view/note_screen.dart';

void main() async {
  await Hive.initFlutter();
  await Hive.openBox(HiveHelper.noteBox);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: BlocProvider(
        create: (context) => NoteCubit()..getNotes(),
        child: NotesScreen(),
      ),
    );
  }
}
