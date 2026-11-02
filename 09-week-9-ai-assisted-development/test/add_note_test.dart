import 'package:flutter_test/flutter_test.dart';
import 'package:week9_ai_assisted/core/failures.dart';
import 'package:week9_ai_assisted/features/notes/domain/entities/note.dart';
import 'package:week9_ai_assisted/features/notes/domain/repositories/note_repository.dart';
import 'package:week9_ai_assisted/features/notes/domain/usecases/add_note.dart';

class FakeNoteRepository implements NoteRepository {
  FakeNoteRepository();

  final List<Note> saved = <Note>[];

  @override
  Future<({List<Note> notes, Failure? failure})> fetchNotes() async {
    return (notes: saved, failure: null);
  }

  @override
  Future<({Note? note, Failure? failure})> addNote({
    required String title,
    String body = '',
  }) async {
    final note = Note(
      id: saved.length + 1,
      title: title,
      body: body,
      updatedAt: DateTime(2026, 11, 2),
      dirty: true,
    );
    saved.add(note);
    return (note: note, failure: null);
  }
}

void main() {
  group('AddNote', () {
    test('judul kosong ditolak tanpa menyentuh repository', () async {
      final repo = FakeNoteRepository();
      final result = await AddNote(repo).call(title: '');

      expect(result.failure, isA<ValidationFailure>());
      expect(result.note, isNull);
      expect(repo.saved, isEmpty);
    });

    test('judul berisi spasi saja tetap ditolak', () async {
      final repo = FakeNoteRepository();
      final result = await AddNote(repo).call(title: '   ');

      expect(result.failure, isA<ValidationFailure>());
      expect(repo.saved, isEmpty);
    });

    test('judul valid disimpan dan spasinya dipangkas', () async {
      final repo = FakeNoteRepository();
      final result = await AddNote(repo)
          .call(title: '  Rencana Belajar  ', body: '  Bab 1  ');

      expect(result.failure, isNull);
      expect(result.note?.title, 'Rencana Belajar');
      expect(result.note?.body, 'Bab 1');
      expect(repo.saved, hasLength(1));
    });
  });
}
