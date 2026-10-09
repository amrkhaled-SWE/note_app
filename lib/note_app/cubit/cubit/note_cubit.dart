import 'package:bloc/bloc.dart';
import 'package:notes/Network/hive_helper.dart';

part 'note_state.dart';

class NoteCubit extends Cubit<NoteState> {
  NoteCubit() : super(NoteInitial());

  Future<void> getNotes() async {
    emit(NoteLoadingState());
    await HiveHelper.getNotes();
    if (HiveHelper.myNotes.isEmpty) {
      emit(NoteEmptyState());
    } else {
      emit(NoteSuccessState());
    }
  }

  Future<void> addNote(String text) async {
    await HiveHelper.addNote(text);
    emit(NoteAddedState());
  }

  Future<void> updateNote(int index, String text) async {
    await HiveHelper.updateNote(index, text);
    emit(NoteAddedState());
  }

  Future<void> deleteNote(int index) async {
    await HiveHelper.deleteNote(index);
    emit(NoteDeleteNoteState());
  }

  Future<void> deleteAllNotes() async {
    await HiveHelper.deleteAllNotes();
    emit(NoteDeleteAllState());
  }
}
