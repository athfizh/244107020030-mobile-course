# Learning Journal - Semester Mobile Development

**Athaulla Hafizh | NIM: 244107020030**

---

## Minggu 9 - AI-Assisted Development / Vibe Coding

**Tanggal:** 2 November 2026

### Yang Dipelajari
- Siklus kerja *AI-assisted development*: prompt, generate, verify, test, refactor, lalu explain tanpa membuka AI.
- Formula prompt lima slot: peran, konteks, tugas, batas, dan format output.
- Tiga pola halusinasi pada Flutter: method fiktif, API *package* kedaluwarsa, dan logika yang terdengar yakin tetapi salah.
- Prinsip verifikasi: klaim AI adalah hipotesis sampai terbukti lewat `grep`, `flutter analyze`, dan test hijau.
- Pentingnya memberi batas eksplisit pada prompt, termasuk larangan mengubah arsitektur dan jumlah baris maksimum.

### Yang Dikerjakan
- [x] Menyusun prompt lima slot dengan konteks struktur folder dan kontrak *Use Case* yang sudah ada.
- [x] Menyimpan prompt dan output awal AI ke `docs/ai-log.md`.
- [x] Menemukan kesalahan logika pada `contains` tanpa `toLowerCase()` dan membuktikannya lewat test merah.
- [x] Membuat `SearchNotes` di *Domain Layer* sebagai fungsi murni.
- [x] Menambah `notesQueryProvider` dan `filteredNotesProvider` agar state pencarian tunggal.
- [x] Membangun kotak pencarian, tombol hapus, dan *empty state* kontekstual pada halaman Catatan.
- [x] Menulis 6 unit test untuk `SearchNotes` dan 2 widget test untuk *empty state* serta pencarian.
- [x] Memverifikasi *Domain* tetap steril lewat `grep` dan menjalankan seluruh pemeriksaan mesin.

### Kendala & Solusi
- **Masalah:** Usulan AI menaruh logika filter di dalam `notes_page.dart`, sehingga tidak bisa diuji tanpa membangun widget.
- **Solusi:** Memindahkannya ke `domain/usecases/search_notes.dart` dan menguji lewat enam unit test.
- **Masalah:** Test pencarian `belanja` gagal menemukan `Belanja Bulanan` karena perbandingan bersifat *case-sensitive*.
- **Solusi:** Menambahkan `toLowerCase()` pada kata kunci dan pada judul serta isi catatan.
- **Masalah:** Saat uji manual, mencari kata "telur" pada catatan `Belanja Bulanan` tidak menemukan apa pun.
- **Solusi:** Memperluas cakupan pencarian dari hanya judul menjadi judul dan isi catatan.

### Key Takeaway
> AI sangat cepat menghasilkan kode yang terlihat benar, tetapi justru kesalahan yang terlihat wajar paling berbahaya. Test merah adalah satu-satunya cara jujur membuktikan bahwa klaim AI memang salah, dan itu lebih berharga daripada sepuluh prompt perbaikan tanpa bukti.
