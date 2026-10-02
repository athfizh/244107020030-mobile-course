import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../data/local/note.dart';
import 'notes_page.dart';

final noteDetailProvider = FutureProvider.family<Note?, int>((ref, id) {
  final repo = ref.watch(noteRepositoryProvider);
  return repo.getNoteById(id);
});

class NoteDetailPage extends ConsumerWidget {
  final int id;
  const NoteDetailPage({super.key, required this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final noteAsync = ref.watch(noteDetailProvider(id));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Catatan'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/');
            }
          },
        ),
      ),
      body: noteAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (note) {
          if (note == null) {
            return const Center(child: Text('Catatan tidak ditemukan.'));
          }
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(note.title, style: Theme.of(context).textTheme.headlineMedium),
                const SizedBox(height: 8),
                Text('Diperbarui: ${note.updatedAt.toString()}', style: Theme.of(context).textTheme.bodySmall),
                const Divider(),
                const SizedBox(height: 8),
                Text(note.body, style: Theme.of(context).textTheme.bodyLarge),
              ],
            ),
          );
        },
      ),
    );
  }
}
