import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:week13_ci/core/failures.dart';
import 'package:week13_ci/features/notes/domain/entities/note.dart';
import 'package:week13_ci/features/notes/domain/repositories/note_repository.dart';
import 'package:week13_ci/features/notes/presentation/pages/notes_page.dart';
import 'package:week13_ci/features/notes/presentation/providers/notes_providers.dart';

class _FakeNoteRepository implements NoteRepository {
  final List<Note> saved = <Note>[];

  @override
  Future<({List<Note> notes, Failure? failure})> fetchNotes() async {
    return (notes: List<Note>.of(saved), failure: null);
  }

  @override
  Future<({Note? note, Failure? failure})> addNote({
    required String title,
    String body = '',
  }) async {
    final note = Note(
      id: saved.length + 1,
      title: title.trim(),
      body: body.trim(),
      updatedAt: DateTime(2026, 11, 25),
      dirty: true,
    );
    saved.add(note);
    return (note: note, failure: null);
  }
}

Widget _app(_FakeNoteRepository repository) {
  return ProviderScope(
    overrides: [noteRepositoryProvider.overrideWithValue(repository)],
    child: const MaterialApp(home: NotesPage()),
  );
}

void main() {
  group('NotesPage - dialog catatan baru', () {
    testWidgets('menolak judul kosong dan menampilkan pesan validasi', (
      tester,
    ) async {
      final repository = _FakeNoteRepository();
      await tester.pumpWidget(_app(repository));
      await tester.pumpAndSettle();

      expect(find.text('Belum ada catatan.'), findsOneWidget);

      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      expect(find.text('Catatan Baru'), findsOneWidget);

      await tester.tap(find.text('Simpan'));
      await tester.pumpAndSettle();

      expect(find.text('Judul tidak boleh kosong.'), findsOneWidget);
      expect(repository.saved, isEmpty);
    });

    testWidgets('menyimpan catatan valid dan menampilkannya di daftar', (
      tester,
    ) async {
      final repository = _FakeNoteRepository();
      await tester.pumpWidget(_app(repository));
      await tester.pumpAndSettle();

      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      await tester.enterText(
        find.byType(TextFormField).first,
        'Rencana Belajar',
      );
      await tester.enterText(find.byType(TextFormField).last, 'Bab 12');
      await tester.tap(find.text('Simpan'));
      await tester.pumpAndSettle();

      expect(repository.saved.single.title, 'Rencana Belajar');
      expect(find.text('Rencana Belajar'), findsOneWidget);
    });
  });
}
