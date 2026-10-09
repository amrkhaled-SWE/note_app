import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes/Network/hive_helper.dart';
import 'package:notes/note_app/cubit/cubit/note_cubit.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  static const Color backgroundColor = Color(0xFFF5F6FA);
  static const Color primaryColor = Color(0xFF5B67F1);
  static const Color titleColor = Color(0xFF202124);
  static const Color cardColor = Colors.white;

  final TextEditingController _textController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  String? _validateNote(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Note can't be empty";
    }
    return null;
  }

  void _showNoteDialog({
    required String title,
    required String actionText,
    String initialText = '',
    required void Function(String text) onSubmit,
  }) {
    _textController.text = initialText;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: Colors.white,
        elevation: 12,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: titleColor,
          ),
        ),
        content: Form(
          key: _formKey,
          child: TextFormField(
            controller: _textController,
            validator: _validateNote,
            autofocus: true,
            maxLines: 5,
            minLines: 3,
            decoration: InputDecoration(
              hintText: 'Write your note here...',
              filled: true,
              fillColor: backgroundColor,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: Colors.red),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(
                  color: primaryColor,
                  width: 1.5,
                ),
              ),
            ),
          ),
        ),
        actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.grey),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                onSubmit(_textController.text.trim());
                Navigator.of(dialogContext).pop();
              }
            },
            child: Text(actionText),
          ),
        ],
      ),
    );
  }

  void _showAddDialog() {
    _showNoteDialog(
      title: 'Add Note',
      actionText: 'Add Note',
      onSubmit: (text) => context.read<NoteCubit>().addNote(text),
    );
  }

  void _showUpdateDialog(int index) {
    _showNoteDialog(
      title: 'Edit Note',
      actionText: 'Save Changes',
      initialText: HiveHelper.myNotes[index],
      onSubmit: (text) => context.read<NoteCubit>().updateNote(index, text),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NoteCubit, NoteState>(
      builder: (context, state) {
        final notes = HiveHelper.myNotes;

        return Scaffold(
          backgroundColor: backgroundColor,
          appBar: AppBar(
            backgroundColor: backgroundColor,
            elevation: 0,
            scrolledUnderElevation: 0,
            title: const Row(
              children: [
                Icon(
                  Icons.sticky_note_2,
                  color: primaryColor,
                  size: 28,
                ),
                SizedBox(width: 10),
                Text(
                  'My Notes',
                  style: TextStyle(
                    color: titleColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ),
                ),
              ],
            ),
            actions: [
              if (notes.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: TextButton.icon(
                    onPressed: _showClearAllDialog,
                    icon: const Icon(
                      Icons.delete_outline,
                      color: Colors.redAccent,
                      size: 20,
                    ),
                    label: const Text(
                      'Clear All',
                      style: TextStyle(
                        color: Colors.redAccent,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Stay Organized',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: titleColor,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Keep your thoughts in one place.',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    const Text(
                      'Your Notes',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: titleColor,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: primaryColor.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '${notes.length}',
                        style: const TextStyle(
                          color: primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: notes.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(24),
                                decoration: BoxDecoration(
                                  color: primaryColor.withOpacity(0.08),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.note_add_outlined,
                                  size: 60,
                                  color: primaryColor,
                                ),
                              ),
                              const SizedBox(height: 20),
                              const Text(
                                'No notes yet!',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: titleColor,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Tap the + button to create your first note.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView.separated(
                          itemCount: notes.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 14),
                          itemBuilder: (context, index) {
                            return Container(
                              decoration: BoxDecoration(
                                color: cardColor,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.04),
                                    blurRadius: 12,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(20),
                                onTap: () => _showUpdateDialog(index),
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                    18,
                                    18,
                                    10,
                                    18,
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 4,
                                        height: 48,
                                        decoration: BoxDecoration(
                                          color: primaryColor,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                      ),
                                      const SizedBox(width: 14),
                                      Expanded(
                                        child: Text(
                                          notes[index],
                                          maxLines: 3,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            height: 1.5,
                                            color: titleColor,
                                          ),
                                        ),
                                      ),
                                      IconButton(
                                        tooltip: 'Edit note',
                                        onPressed: () =>
                                            _showUpdateDialog(index),
                                        icon: const Icon(
                                          Icons.edit_outlined,
                                          color: primaryColor,
                                          size: 21,
                                        ),
                                      ),
                                      IconButton(
                                        tooltip: 'Delete note',
                                        onPressed: () => context
                                            .read<NoteCubit>()
                                            .deleteNote(index),
                                        icon: const Icon(
                                          Icons.delete_outline_rounded,
                                          color: Colors.redAccent,
                                          size: 22,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: _showAddDialog,
            backgroundColor: primaryColor,
            foregroundColor: Colors.white,
            elevation: 4,
            icon: const Icon(Icons.add),
            label: const Text(
              'Add Note',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        );
      },
    );
  }

  void _showClearAllDialog() {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Text('Clear All Notes?'),
        content: const Text(
          'Are you sure you want to delete all your notes?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              context.read<NoteCubit>().deleteAllNotes();
              Navigator.pop(dialogContext);
            },
            child: const Text('Delete All'),
          ),
        ],
      ),
    );
  }
}