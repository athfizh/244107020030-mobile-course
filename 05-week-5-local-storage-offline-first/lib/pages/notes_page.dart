import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../data/local/note.dart';
import '../data/repositories/note_repository.dart';
import '../widgets/note_tile.dart';
import '../data/sync.dart';
import 'settings_page.dart';

final noteRepositoryProvider = Provider((ref) => NoteRepository());

final notesProvider =
    AsyncNotifierProvider<NotesNotifier, List<Note>>(NotesNotifier.new);

final dirtyCountProvider = FutureProvider<int>((ref) async {
  ref.watch(notesProvider);
  return ref.read(noteRepositoryProvider).countDirty();
});

class NotesNotifier extends AsyncNotifier<List<Note>> {
  @override
  Future<List<Note>> build() async {
    final repo = ref.watch(noteRepositoryProvider);
    final notes = await repo.fetchNotes();
    return notes;
  }

  Future<void> add(String title, String body) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(noteRepositoryProvider).addNote(title: title, body: body);
      return ref.read(noteRepositoryProvider).fetchNotes();
    });
  }

  Future<void> remove(int id) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(noteRepositoryProvider).deleteNote(id);
      return ref.read(noteRepositoryProvider).fetchNotes();
    });
  }

  /// Simulasi sync: tandai semua dirty jadi synced
  Future<void> simulateSync() async {
    final isOffline = ref.read(forceOfflineProvider).value ?? false;
    if (isOffline) {
       return;
    }
    await SyncService.syncNotes(ref.read(noteRepositoryProvider));
    ref.invalidateSelf(); // Invalidasi provider di repository caller, bukan di widget acak
  }
}

class NotesPage extends ConsumerWidget {
  const NotesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notesAsync = ref.watch(notesProvider);
    final dirtyAsync = ref.watch(dirtyCountProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Catatan Offline'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          dirtyAsync.when(
            loading: () => const SizedBox.shrink(),
            error: (_, stackTrace) => const SizedBox.shrink(),
            data: (count) => count == 0
                ? const SizedBox.shrink()
                : Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: TextButton.icon(
                      onPressed: () =>
                          ref.read(notesProvider.notifier).simulateSync(),
                      icon: const Icon(Icons.cloud_upload_outlined, size: 18),
                      label: Text(
                        '$count belum sync',
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                  ),
          ),
        ],
      ),
      body: notesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 8),
              Text('Gagal memuat catatan: $e'),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                onPressed: () => ref.invalidate(notesProvider),
                icon: const Icon(Icons.refresh),
                label: const Text('Coba lagi'),
              ),
            ],
          ),
        ),
        data: (notes) => notes.isEmpty
            ? Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.note_alt_outlined,
                        size: 64,
                        color: Theme.of(context).colorScheme.outlineVariant),
                    const SizedBox(height: 8),
                    Text(
                      'Belum ada catatan',
                      style: TextStyle(
                          color:
                              Theme.of(context).colorScheme.onSurfaceVariant),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Tekan + untuk mulai menulis',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              )
            : ListView.separated(
                padding: const EdgeInsets.all(16),
                separatorBuilder: (context, i) =>
                    const Divider(height: 1),
                itemCount: notes.length,
                itemBuilder: (context, i) {
                  final note = notes[i];
                  return NoteTile(
                    note: note,
                    onDelete: () =>
                        ref.read(notesProvider.notifier).remove(note.id!),
                    onTap: () => context.push('/note/${note.id}'),
                  );
                },
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddNoteDialog(context, ref),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddNoteDialog(BuildContext context, WidgetRef ref) {
    final titleCtrl = TextEditingController();
    final bodyCtrl = TextEditingController();
    showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Catatan baru'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleCtrl,
              decoration: const InputDecoration(
                labelText: 'Judul',
                border: OutlineInputBorder(),
              ),
              autofocus: true,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: bodyCtrl,
              decoration: const InputDecoration(
                labelText: 'Isi catatan',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () {
              if (titleCtrl.text.trim().isEmpty) return;
              ref.read(notesProvider.notifier).add(
                    titleCtrl.text.trim(),
                    bodyCtrl.text.trim(),
                  );
              Navigator.pop(context);
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }
}
