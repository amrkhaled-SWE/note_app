import 'package:hive/hive.dart';

class HiveHelper {
  static const noteBox = "Note_Box";
  static const noteKey = "Note_Key";
  static List<String> myNotes = [];

  static Future<void> getNotes() async {
    await Future.delayed(Duration(seconds: 1));
    myNotes = List<String>.from(Hive.box(noteBox).get(noteKey) ?? []);
  }

  static Future<void> addNote(String note) async {
    myNotes.add(note);
    await Hive.box(noteBox).put(noteKey, myNotes);
  }

  static Future<void> deleteNote(int index) async {
    myNotes.removeAt(index);
    await Hive.box(noteBox).put(noteKey, myNotes);
  }

  static Future<void> deleteAllNotes() async {
    myNotes.clear();
    await Hive.box(noteBox).put(noteKey, myNotes);
  }

  static Future<void> updateNote(int index, String content) async {
    myNotes[index] = content;
    await Hive.box(noteBox).put(noteKey, myNotes);
  }
}
