# Learning Journal - Semester Mobile Development

**Athaulla Hafizh | NIM: 244107020030**

---

## Minggu 8 - Mid Project Review & Code Review

**Tanggal:** 2 November 2026

### Yang Dipelajari
- Model *branching* Git Flow: `main` yang selalu bisa dirilis, `develop` sebagai integrasi mingguan, `feature/*` untuk kerja harian, dan `fix/*` untuk perbaikan cepat yang wajib disertai test.
- Anatomi commit yang baik: satu commit sama dengan satu perubahan logis yang bisa direview dan di-revert, dengan format `tipe(scope): deskripsi`.
- Syarat *Pull Request* siap review: ukuran di bawah 300 baris, judul satu fitur, serta bagian Masalah, Solusi, Cara uji, dan tautan issue.
- Pola komentar review yang bisa ditindaklanjuti: observasi, dampak, lalu usulan konkret.
- Penegakan mutu lewat mesin: `flutter analyze`, `dart format --set-exit-if-changed`, `flutter test`, dan GitHub Actions.
- Peran AI sebagai reviewer awal yang tetap wajib diverifikasi dengan `grep`, tes gagal, atau reproduksi manual.

### Yang Dikerjakan
- [x] Audit riwayat Git dan penulisan ulang tiga pesan commit lama ke format konvensional.
- [x] Membuat branch `develop` dari `main` lalu menjadikannya target default Pull Request.
- [x] Mengerjakan empat branch: `chore/week8-scaffold`, `style/week8-format`, `feat/notes-validation`, dan `fix/announcement-route`.
- [x] Menambah *Use Case* `AddNote` beserta `ValidationFailure` dan tiga unit test.
- [x] Memperbaiki route detail pengumuman yang salah escape dan memusatkan konfigurasi `Dio`.
- [x] Menyusun `docs/review-checklist.md`, `docs/ai-review-vs-keputusan.md`, `docs/pr-notes.md`, dan `docs/issue-pr-map.md`.
- [x] Menambahkan workflow CI GitHub Actions untuk analyze, format, dan test.
- [x] Menjalankan seluruh pemeriksaan mesin sampai hijau dan mengambil bukti screenshot di emulator Pixel 8.

### Kendala & Solusi
- **Masalah:** `dart format --set-exit-if-changed .` gagal di Windows karena direktori `build/` memiliki path terlalu panjang.
- **Solusi:** Membatasi cakupan ke `lib test`, lalu menyamakan perintah pada workflow CI agar konsisten antara lokal dan server.
- **Masalah:** Saat uji manual, menyimpan catatan memicu `'_dependents.isEmpty': is not true` karena `TextEditingController` di-*dispose* ketika dialog masih beranimasi keluar.
- **Solusi:** Memindahkan controller ke dalam `StatefulWidget` dialog dan membuangnya pada `dispose()` milik State tersebut.
- **Masalah:** `gh` CLI tidak tersedia sehingga tidak bisa membuat issue dan PR dari terminal.
- **Solusi:** Branch di-push lebih dulu, lalu issue dan Pull Request dibuat melalui antarmuka web GitHub.

### Key Takeaway
> Review bukan upacara persetujuan, melainkan satu-satunya kesempatan menangkap bug sebelum menyentuh pengguna. Dua dari tiga bug Minggu 8 tidak akan pernah terlihat lewat `analyze` maupun `test`, karena hanya muncul saat alur aplikasi benar-benar dijalankan.
