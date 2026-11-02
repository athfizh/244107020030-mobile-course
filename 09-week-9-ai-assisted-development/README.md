# Minggu 9 AI-Assisted Development / Vibe Coding

**Nama:** Athaulla Hafizh  
**NIM:** 244107020030  

---

## Tujuan

Praktikum ini menambahkan satu fitur kecil ke project hasil Minggu 8 dengan bantuan AI, lalu membuktikan bahwa hasilnya benar-benar dipahami dan diuji. Fokusnya bukan pada banyaknya kode yang dihasilkan AI, melainkan pada kualitas verifikasi: membaca tiap baris, memeriksa API nyata, menjalankan `flutter analyze`, menulis test sukses dan gagal, lalu me-refactor hasilnya ke *Clean Architecture*.

---

## Fitur Utama

| Fitur | Keterangan |
|---|---|
| Pencarian Catatan | Mencari pada judul dan isi catatan tanpa membedakan huruf besar dan kecil |
| Empty State Kontekstual | Pesan berbeda untuk "belum ada catatan" dan "tidak ada hasil untuk kata kunci tertentu" |
| Tombol Hapus Pencarian | Ikon `close` muncul saat kata kunci tidak kosong untuk mengembalikan daftar penuh |
| Logika di Domain | Aturan pencarian berada di `SearchNotes` yang murni Dart dan bisa diuji tanpa widget |
| State Tunggal | `notesQueryProvider` dan `filteredNotesProvider` menjaga satu sumber kebenaran untuk kata kunci |

---

## Stack Teknologi
1. Bahasa Dart 3.13.2
2. Framework Flutter SDK 3.47.2
3. Package `flutter_riverpod` 2.6.1, `go_router` 14.8.1, `dio` 5.8.0, `flutter_secure_storage` 9.2.4, `sqflite` 2.4.4, `path` 1.9.1, `intl` 0.20.3
4. Tools Android Studio, Git, Flutter CLI
5. Pengujian menggunakan `flutter_test`

---

## Cara Menjalankan
```bash
cd 09-week-9-ai-assisted-development

flutter pub get

flutter run

flutter test
```

Keterangan alur aplikasi:
1. Masuk melalui halaman Login, lalu pilih menu Catatan Pribadi.
2. Ketik kata kunci pada kotak pencarian. Daftar langsung tersaring tanpa menekan tombol apa pun.
3. Tekan ikon `close` untuk mengosongkan kata kunci dan menampilkan seluruh catatan.
4. Tambahkan catatan lewat tombol `+` untuk menguji pencarian pada data baru.

---

## Hasil yang Dicapai

Fitur pencarian berjalan dengan pencocokan pada judul dan isi, tidak membedakan huruf besar maupun kecil, serta mengabaikan spasi di awal dan akhir kata kunci. *Empty state* membedakan kondisi "belum ada catatan" dan "tidak ada hasil". Logika pencarian berada di *Domain Layer* sehingga 27 tes lulus tanpa menyentuh widget untuk jalur logika. `flutter analyze` bersih dan `dart format` tidak mengubah satu file pun. Satu kesalahan logika dari AI berhasil dibuktikan lewat test merah sebelum diperbaiki.

---

## Tahapan Praktikum

### Praktikum 1: Generate dan Verifikasi Fitur Pencarian
<img src="screenshots/Praktikum 1 - Halaman Catatan Kosong.png" width="250" alt="Halaman Catatan Kosong"> <img src="screenshots/Praktikum 1 - Halaman Catatan Sebelum Pencarian.png" width="250" alt="Sebelum Pencarian"> <img src="screenshots/Praktikum 1 - Pencarian Judul Cocok.png" width="250" alt="Pencarian Cocok">

> **Keterangan gambar**
> - Kondisi awal menampilkan *empty state* dengan ikon catatan dan pesan `Belum ada catatan.`
> - Setelah dua catatan ditambahkan, kotak pencarian muncul di atas daftar.
> - Mengetik `belanja` menyaring daftar menjadi satu item tanpa menekan tombol apa pun.

<img src="screenshots/Praktikum 1 - Pencarian Tanpa Hasil.png" width="250" alt="Pencarian Tanpa Hasil">

> **Keterangan gambar**
> - Kata kunci `zzz` tidak menemukan apa pun, sehingga muncul ikon `search_off` dan pesan `Tidak ada catatan yang cocok dengan "zzz".`
> - Pesan ini berbeda dari *empty state* awal, sehingga pengguna tahu bahwa daftar memang tersaring, bukan kosong.

### Praktikum 2: Bukti Test dan Verifikasi Mesin
<img src="screenshots/Praktikum 2 - Filter Case-Insensitive.png" width="250" alt="Filter Case-Insensitive"> <img src="screenshots/Praktikum 2 - Hasil Flutter Analyze.png" width="500" alt="Flutter Analyze">

> **Keterangan gambar**
> - Kata kunci `BELANJA` tetap menemukan catatan `Belanja Bulanan`, membuktikan pencocokan tidak membedakan huruf besar dan kecil.
> - `flutter analyze` selesai tanpa satu pun isu pada seluruh project Week 9.

<img src="screenshots/Praktikum 2 - Hasil Flutter Test.png" width="500" alt="Flutter Test"> <img src="screenshots/Refactoring - Hasil Flutter Format.png" width="400" alt="Flutter Format">

> **Keterangan gambar**
> - Seluruh 27 tes lulus, mencakup 6 test `SearchNotes` dan 2 widget test untuk *empty state* serta pencarian.
> - `dart format --set-exit-if-changed lib test` melaporkan nol file berubah.

### Praktikum 3: Refactor ke Clean Architecture
<img src="screenshots/Praktikum 3 - Struktur File Search.png" width="500" alt="Struktur File Search"> <img src="screenshots/Praktikum 3 - Bukti Domain Steril.png" width="500" alt="Bukti Domain Steril">

> **Keterangan gambar**
> - `search_notes.dart` diletakkan di `domain/usecases/`, bukan di dalam widget seperti usulan awal AI.
> - Alur data berjalan satu arah: widget membaca `filteredNotesProvider`, provider memanggil `SearchNotes`, lalu `SearchNotes` bekerja pada data dari `notesProvider`.
> - Hasil `grep` menunjukkan *Domain* bebas dari impor Flutter, Dio, SQLite, dan Firebase, sedangkan *Presentation* tidak memanggil repository secara langsung.

### Refactoring & Testing
<img src="screenshots/AI Challenge - Log Prompt dan Output.png" width="600" alt="AI Log">

> **Keterangan gambar**
> - Prompt lima slot, output awal AI, dan tabel keputusan tercatat lengkap di `docs/ai-log.md`.
> - Kesalahan logika AI pada `contains` tanpa `toLowerCase()` dibuktikan lewat test merah sebelum diperbaiki.
> - Cakupan pencarian diperluas ke isi catatan setelah uji manual menunjukkan kata "telur" tidak ditemukan.

---

## AI Prompt Challenge

Seluruh prompt, output awal AI, tabel keputusan terima/tolak, dan bukti test dicatat pada dokumen terpisah.

👉 [**Lihat Pembahasan AI Log (ai-log.md)**](docs/ai-log.md)

---

## Refleksi

**1. Satu halusinasi AI apa yang Anda temukan dan bagaimana membuktikannya?**

AI mengklaim `String.contains` sudah cukup untuk pencarian tanpa memedulikan huruf besar dan kecil. Klaim itu salah. Saya membuktikannya dengan menulis test yang mencari `belanja` pada daftar berisi `Belanja Bulanan`; test tersebut gagal dengan `Expected: length of 2, Actual: []`. Setelah `toLowerCase()` ditambahkan pada kedua sisi, test menjadi hijau. Bukti visualnya ada pada `screenshots/Praktikum 2 - Filter Case-Insensitive.png`.

**2. Prompt mana yang paling membantu dan apa yang Anda ubah?**

Prompt yang paling membantu adalah versi lima slot dengan batas eksplisit "jangan ubah arsitektur, maksimal 80 baris, jangan panggil SQLite dari widget". Batas itu membuat AI tidak melebar ke fitur lain. Yang saya ubah adalah bagian tugas: awalnya hanya "pencarian judul", lalu saya perluas menjadi "judul dan isi" setelah uji manual menunjukkan pencarian isi lebih berguna.

**3. Satu refactor apa yang Anda lakukan pada kode AI?**

Saya memindahkan fungsi filter dari `notes_page.dart` ke `domain/usecases/search_notes.dart`. Dampaknya besar: aturan pencarian kini bisa diuji dengan enam unit test tanpa membangun widget, dan file halaman kembali fokus pada tampilan.

**4. Keputusan terima/tolak mana yang paling sulit?**

Keputusan tersulit adalah memperluas pencarian ke `body`. AI hanya mengusulkan judul sesuai instruksi awal, dan instruksi saya juga menyebut judul. Setelah mencoba mencari kata "telur" pada catatan `Belanja Bulanan`, tidak ada hasil padahal kata itu ada di isi. Saya memilih memperluas cakupan karena lebih sesuai harapan pengguna, sambil menjaga `SearchNotes` tetap sederhana.

---

## Referensi

- [Slide Week 9: AI-Assisted Development / Vibe Coding](https://jti-polinema.github.io/flutter-codelab/00-slides/Week_09_AI_Assisted_Development.html)
- [Flutter: Using IDEs and static analysis](https://docs.flutter.dev/tools/analysis)
- [Dart: Linter rules](https://dart.dev/tools/linter-rules)
- [Riverpod: Getting started](https://riverpod.dev/docs/introduction/getting_started)
- [GitHub Copilot: Best practices](https://docs.github.com/en/copilot/using-github-copilot/coding-agent/best-practices-for-using-copilot-to-work-on-tasks)
- [Learn Dart in Y Minutes](https://learnxinyminutes.com/dart/)
- [Dart Language Tour](https://dart.dev/language)
