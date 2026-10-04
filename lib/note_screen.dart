import 'package:flutter/material.dart';
import 'package:notes/note_controller.dart';
import 'package:notes/note_dialog.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  static const Color backgroundColor = Color(0xFFE0E0E0);
  static const Color titleColor = Colors.black;

  final NotesController _controller = NotesController();
  
  @override
  void initState() {
    super.initState();

    _controller.loadNotes();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _showAddDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => NoteDialog(
        title: 'Add Note',
        actionText: 'Add',
        validator: _controller.validateNote,
        onSubmit: _controller.addNote,
      ),
    );
  }

  void _showUpdateDialog(int index) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => NoteDialog(
        title: 'Update Note',
        actionText: 'Update',
        initialText: _controller.notes[index].content,
        validator: _controller.validateNote,
        onSubmit: (text) => _controller.updateNote(index, text),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _controller,
      builder: (context, _) {
        final notes = _controller.notes;

        return Scaffold(
          backgroundColor: backgroundColor,
          appBar: AppBar(
            backgroundColor: backgroundColor,
            actions: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextButton(
                  onPressed: _controller.clearAll,
                  child: const Text(
                    "Clear All",
                    style: TextStyle(color: titleColor, fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Notes",
                  style: TextStyle(fontSize: 48, color: titleColor),
                ),
                const SizedBox(height: 6),
                Expanded(
                  child: ListView.separated(
                    itemCount: notes.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) => Stack(
                      children: [
                        InkWell(
                          onTap: () => _showUpdateDialog(index),
                          child: Container(
                            height: 100,
                            width: 380,
                            decoration: BoxDecoration(
                              color: backgroundColor,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.15),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                left: 18,
                                right: 15,
                                top: 12,
                              ),
                              child: Center(child: Text(notes[index].content)),
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () => _controller.deleteNote(index),
                          icon: const Icon(Icons.delete, color: Colors.red),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: backgroundColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50),
            ),
            onPressed: _showAddDialog,
            child: const Icon(Icons.add, color: Colors.black),
          ),
        );
      },
    );
  }
}
