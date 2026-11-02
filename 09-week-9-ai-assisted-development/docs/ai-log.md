# AI Log - Minggu 9: AI-Assisted Development

**Nama:** Athaulla Hafizh
**NIM:** 244107020030
**Tanggal:** 2 November 2026

---

## 1. Prompt yang Digunakan (Formula 5 Slot)

```text
Peran: senior Flutter developer.
Konteks: project feature-first Clean Architecture (presentation -> domain <- data),
Riverpod, SQLite + Dio. Fitur notes sudah punya GetNotes dan AddNote.
Tugas: tambah pencarian judul dan isi catatan, lengkap dengan empty state
       saat kata kunci tidak cocok.
Batas: jangan ubah arsitektur, jangan panggil SQLite dari widget,
       maksimal 80 baris kode baru.
Output: kode + 3 test case + cara uji manual.
```

Konteks yang ditempel: struktur folder `lib/features/notes/`, isi `note.dart`, `note_repository.dart`, `get_notes.dart`, dan `notes_providers.dart`. Tidak ada token, API key, atau data pribadi yang disertakan.

## 2. Output Awal AI

AI mengusulkan tiga perubahan:

1. Fungsi `searchNotes(List<Note> notes, String query)` di dalam file `notes_page.dart`.
2. Filter memakai `note.title.contains(query)` tanpa normalisasi huruf.
3. `ListView` langsung membaca hasil filter dari variabel lokal di dalam `build`.

Contoh potongan yang diusulkan AI:

```dart
final filtered = notes
    .where((note) => note.title.contains(query))
    .toList();
```

## 3. Verifikasi Enam Langkah

| Langkah | Hasil |
|---|---|
| 1. Baca tiap baris | Ditemukan dua masalah: filter tidak *case-insensitive*, dan logika berada di *Presentation* sehingga tidak bisa diuji tanpa widget |
| 2. Cek import | Usulan AI tetap membuat `domain/` steril, tetapi menempatkan logika di tempat yang salah |
| 3. Cek API nyata | `String.contains` memang ada, tetapi tidak menerima parameter *case sensitivity*, sehingga perlu `toLowerCase()` manual |
| 4. `flutter analyze` | Nol isu setelah refactor |
| 5. Test sukses dan gagal | `test/search_filter_test.dart` berisi 6 test, termasuk query kosong, tidak cocok, dan pencocokan isi |
| 6. Uji manual | Query `belanja`, `BELANJA`, `zzz`, dan query kosong diuji di emulator Pixel 8 |

## 4. Halusinasi dan Kesalahan Logika yang Ditemukan

**Kesalahan logika:** AI mengklaim `contains` sudah "cukup pintar" menangani huruf besar dan kecil. Klaim itu salah. `'Belanja Bulanan'.contains('belanja')` bernilai `false`, sehingga query huruf kecil gagal menemukan judul berhuruf kapital.

**Bukti:** test pertama yang ditulis berdasarkan usulan AI berwarna merah:

```text
Expected: length of 2
  Actual: []
```

Setelah `toLowerCase()` ditambahkan pada kedua sisi, test menjadi hijau. Bukti visual tersedia pada `screenshots/Praktikum 2 - Filter Case-Insensitive.png` yang menampilkan query `BELANJA` tetap menemukan `Belanja Bulanan`.

**Kesalahan penempatan:** AI menaruh filter di dalam widget. Ini melanggar pemisahan lapisan Minggu 7 karena aturan bisnis tidak bisa diuji tanpa membangun UI.

## 5. Tabel Keputusan

| Usulan AI | Keputusan | Alasan Teknis |
|---|---|---|
| Fungsi `searchNotes` di `notes_page.dart` | **Tolak + tulis ulang** | Dipindah ke `domain/usecases/search_notes.dart` agar murni Dart dan bisa diuji tanpa widget |
| Filter tanpa `toLowerCase()` | **Tolak** | Terbukti gagal pada test `belanja` vs `Belanja Bulanan` |
| Filter hanya pada judul | **Tolak + perluas** | Pengguna sering mengingat isi catatan, bukan judulnya. Filter diperluas ke `title` dan `body` |
| `ListView` membaca variabel lokal di `build` | **Tolak + refactor** | Diganti `filteredNotesProvider` agar state pencarian tunggal dan bisa di-*watch* banyak widget |
| Query kosong mengembalikan daftar kosong | **Tolak** | Perilaku yang benar adalah menampilkan seluruh catatan ketika kata kunci kosong |
| `StateProvider` untuk kata kunci | **Terima** | Cukup ringan dan idiomatis untuk satu nilai teks |

## 6. Refactor yang Dilakukan

1. Membuat `SearchNotes` di *Domain Layer* dengan 12 baris logika murni.
2. Menambah `searchNotesProvider`, `notesQueryProvider`, dan `filteredNotesProvider` di *Presentation*.
3. Memindahkan kotak pencarian dan *empty state* ke widget terpisah (`_EmptyState`) agar `build` halaman tetap pendek.
4. Menambah `SearchController` pada `State` dan membuangnya di `dispose()`.

## 7. Bukti Mesin

```text
PS> flutter analyze
No issues found! (ran in 3.8s)

PS> dart format --set-exit-if-changed lib test
Formatted 42 files (0 changed) in 0.09 seconds.

PS> flutter test
00:01 +27: All tests passed!
```

Bukti *grep* sterilisasi:

```text
Domain (0 hasil)      : tidak ada import Flutter/Dio/SQLite/Firebase
Presentation (0 hasil): tidak ada pemanggilan noteRepositoryProvider langsung
```

## 8. Keputusan yang Paling Sulit

Keputusan tersulit adalah memperluas pencarian ke `body`, bukan hanya `title`. AI hanya mengusulkan judul sesuai instruksi, dan instruksi awal saya juga menyebut "pencarian judul". Setelah dicoba manual, mencari kata "telur" pada catatan `Belanja Bulanan` tidak menemukan apa pun, padahal kata itu ada di isi. Saya memilih memperluas cakupan karena perilaku itu lebih sesuai harapan pengguna, dan tetap menjaga kontrak `SearchNotes` tetap sederhana.
