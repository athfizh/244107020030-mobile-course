import 'package:flutter_test/flutter_test.dart';
import 'package:week9_ai_assisted/features/notes/domain/entities/note.dart';
import 'package:week9_ai_assisted/features/notes/domain/usecases/search_notes.dart';

Note _note(String title, [String body = '']) =>
    Note(title: title, body: body, updatedAt: DateTime(2026, 11, 2));

void main() {
  const search = SearchNotes();

  final notes = [
    _note('Belanja Bulanan', 'Beras, telur, minyak'),
    _note('Rencana Belajar', 'Bab 1 dan Bab 3'),
    _note('belanja kampus', 'ATK dan print'),
  ];

  group('SearchNotes', () {
    test('query kosong mengembalikan seluruh catatan', () {
      expect(search(notes, ''), hasLength(3));
      expect(search(notes, '   '), hasLength(3));
    });

    test('pencocokan mengabaikan huruf besar dan kecil', () {
      expect(search(notes, 'belanja'), hasLength(2));
      expect(search(notes, 'BELANJA'), hasLength(2));
    });

    test('query tidak cocok mengembalikan daftar kosong', () {
      expect(search(notes, 'zzz-tak-ada'), isEmpty);
    });

    test('pencocokan juga berlaku pada isi catatan', () {
      final result = search(notes, 'telur');

      expect(result, hasLength(1));
      expect(result.first.title, 'Belanja Bulanan');
    });

    test('spasi di awal dan akhir kata kunci diabaikan', () {
      expect(search(notes, '  rencana  '), hasLength(1));
    });

    test('daftar asli tidak dimutasi', () {
      final original = List<Note>.from(notes);
      search(notes, 'belanja');

      expect(notes, original);
    });
  });
}
