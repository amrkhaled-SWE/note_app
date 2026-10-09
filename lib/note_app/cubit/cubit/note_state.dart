part of 'note_cubit.dart';

sealed class NoteState {}

final class NoteInitial extends NoteState {}

final class NoteLoadingState extends NoteState {}

final class NoteSuccessState extends NoteState {}

final class NoteEmptyState extends NoteState {}

final class NoteAddedState extends NoteState {}

final class NoteDeleteAllState extends NoteState {}

final class NoteDeleteNoteState extends NoteState {}
