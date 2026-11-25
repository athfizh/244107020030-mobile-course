import '../entities/note.dart';

/// Aturan pencarian catatan.
///
/// Fungsi ini murni: tidak menyentuh database, jaringan, maupun widget.
/// Pencocokan dilakukan pada judul dan isi, tidak membedakan huruf besar
/// maupun kecil, dan mengabaikan spasi di awal serta akhir kata kunci.
class SearchNotes {
  const SearchNotes();

  List<Note> call(List<Note> notes, String query) {
    final keyword = query.trim().toLowerCase();
    if (keyword.isEmpty) return notes;

    return notes
        .where(
          (note) =>
              note.title.toLowerCase().contains(keyword) ||
              note.body.toLowerCase().contains(keyword),
        )
        .toList();
  }
}
