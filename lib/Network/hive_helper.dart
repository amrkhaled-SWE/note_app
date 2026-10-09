import 'package:hive_flutter/hive_flutter.dart';

class HiveHelper {
  static const String noteBox = 'Note_Box';
  static const String noteKey = 'Note_Key';

  static Box get _box => Hive.box(noteBox);

  static List<String> _myNotes = [];

  static List<String> get myNotes => List.unmodifiable(_myNotes);

  static Future<void> getNotes() async {
    final savedNotes = _box.get(noteKey, defaultValue: <String>[]);

    _myNotes = List<String>.from(savedNotes);
  }

  static Future<void> addNote(String note) async {
    final updatedNotes = List<String>.from(_myNotes)..add(note);

    await _saveNotes(updatedNotes);
  }

  static Future<void> updateNote(int index, String note) async {
    _checkIndex(index);

    final updatedNotes = List<String>.from(_myNotes);
    updatedNotes[index] = note;

    await _saveNotes(updatedNotes);
  }

  static Future<void> deleteNote(int index) async {
    _checkIndex(index);

    final updatedNotes = List<String>.from(_myNotes);
    updatedNotes.removeAt(index);

    await _saveNotes(updatedNotes);
  }

  static Future<void> deleteAllNotes() async {
    await _saveNotes([]);
  }

  static Future<void> _saveNotes(List<String> notes) async {
    await _box.put(noteKey, notes);
    _myNotes = List<String>.from(notes);
  }

  static void _checkIndex(int index) {
    if (index < 0 || index >= _myNotes.length) {
      throw RangeError.index(index, _myNotes, 'index');
    }
  }
}