import 'package:flutter/foundation.dart';
import 'package:notes/Network/network_helper.dart';
import 'package:notes/note_model.dart';

class NotesController extends ChangeNotifier {
  final List<NoteModel> _notes = [];
  Future<void> loadNotes() async {
    await HiveHelper.getNotes();

    _notes.clear();

    for (final note in HiveHelper.myNotes) {
      _notes.add(NoteModel(content: note));
    }

    notifyListeners();
  }

  List<NoteModel> get notes => List.unmodifiable(_notes);

  String? validateNote(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "You should add any content";
    }
    return null;
  }

  Future<void> addNote(String content) async {
    if (validateNote(content) != null) return;
    final note = content.trim();
    _notes.add(NoteModel(content: note));

    await HiveHelper.addNote(note);

    notifyListeners();
  }

  void updateNote(int index, String content) async {
    if (validateNote(content) != null) return;
    final note = content.trim();
    await HiveHelper.updateNote(index, content);
    _notes[index] = _notes[index].copyWith(content: note);
    notifyListeners();
  }

  void deleteNote(int index) async {
    _notes.removeAt(index);
    await HiveHelper.deleteNote(index);
    notifyListeners();
  }

  void clearAll() async {
    _notes.clear();
    await HiveHelper.deleteAllNotes();
    notifyListeners();
  }
}
