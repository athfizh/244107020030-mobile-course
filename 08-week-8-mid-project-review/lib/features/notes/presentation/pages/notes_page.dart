import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/notes_providers.dart';
import '../../domain/entities/note.dart';

class NotesPage extends ConsumerWidget {
  const NotesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(notesProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Catatan Pribadi')),
      body: state.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Error: $e'),
              TextButton(
                onPressed: () => ref.invalidate(notesProvider),
                child: const Text('Coba Lagi'),
              ),
            ],
          ),
        ),
        data: (notes) => notes.isEmpty
            ? const Center(child: Text('Belum ada catatan.'))
            : ListView.separated(
                itemCount: notes.length,
                separatorBuilder: (context, index) => const Divider(),
                itemBuilder: (context, index) {
                  final Note note = notes[index];
                  return ListTile(
                    title: Text(
                      note.title,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      note.body,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: const Icon(Icons.note),
                  );
                },
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _handleAddNote(context, ref),
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _handleAddNote(BuildContext context, WidgetRef ref) async {
    final result = await showDialog<({String title, String body})>(
      context: context,
      builder: (_) => const _AddNoteDialog(),
    );

    if (result == null) return;

    final saved = await ref
        .read(addNoteProvider)
        .call(title: result.title, body: result.body);

    if (saved.failure != null) {
      if (context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(saved.failure!.message)));
      }
      return;
    }

    ref.invalidate(notesProvider);
  }
}

class _AddNoteDialog extends StatefulWidget {
  const _AddNoteDialog();

  @override
  State<_AddNoteDialog> createState() => _AddNoteDialogState();
}

class _AddNoteDialogState extends State<_AddNoteDialog> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _bodyController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      Navigator.of(context)
          .pop((title: _titleController.text, body: _bodyController.text));
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Catatan Baru'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Judul'),
              textInputAction: TextInputAction.next,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Judul tidak boleh kosong.';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _bodyController,
              decoration: const InputDecoration(labelText: 'Isi'),
              maxLines: 3,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Batal'),
        ),
        FilledButton(onPressed: _submit, child: const Text('Simpan')),
      ],
    );
  }
}
