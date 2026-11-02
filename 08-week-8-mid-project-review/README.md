# Minggu 8 Mid Project Review & Code Review

**Nama:** Athaulla Hafizh  
**NIM:** 244107020030  

---

## Tujuan

Praktikum ini berfokus pada disiplin kolaborasi, bukan penambahan fitur. Materi yang dibahas mencakup Git Flow dan strategi *branching*, penulisan commit konvensional, anatomi *Pull Request* yang layak direview, *peer code review* dengan checklist terstruktur, serta penegakan *static analysis* dan *formatter* sampai bersih. Codelab ini me-review project hasil Minggu 5-7, bukan membuat project baru.

---

## Fitur Utama

| Fitur | Keterangan |
|---|---|
| Git Flow | Branch `main`, `develop`, `feature/*`, dan `fix/*` dengan aturan satu branch satu tujuan |
| Commit Konvensional | Format `tipe(scope): deskripsi` untuk `feat`, `fix`, `refactor`, `test`, `docs`, `chore`, dan `style` |
| Pull Request Kecil | Tujuh PR (#3 sampai #9) dengan bagian Masalah, Solusi, Cara uji, dan `Closes #<issue>` |
| Validasi Judul Catatan | `AddNote` pada *Domain Layer* menolak judul kosong dengan `ValidationFailure` |
| Perbaikan Route | `AppRoutes.announcementDetailPath()` menggantikan string literal yang salah escape |
| Konfigurasi Dio Tunggal | `connectTimeout` dan `receiveTimeout` dipusatkan pada `dio_client.dart` |
| Continuous Integration | GitHub Actions menjalankan `flutter analyze`, `dart format`, dan `flutter test` pada setiap PR, dengan matriks untuk Week 8 sampai Week 11 |

---

## Stack Teknologi
1. Bahasa Dart 3.13.2
2. Framework Flutter SDK 3.47.2
3. Package `flutter_riverpod` 2.6.1, `go_router` 14.8.1, `dio` 5.8.0, `flutter_secure_storage` 9.2.4, `sqflite` 2.4.4, `path` 1.9.1, `intl` 0.20.3
4. Tools Android Studio, Git, Flutter CLI, GitHub Actions
5. Pengujian menggunakan `flutter_test`

---

## Cara Menjalankan
```bash
cd 08-week-8-mid-project-review

flutter pub get

flutter run

flutter test
```

Keterangan alur aplikasi:
1. Masuk melalui halaman Login. Sesi disimpan pada `flutter_secure_storage`.
2. Halaman Home menyediakan pintu masuk ke Pengumuman dan Catatan Pribadi.
3. Halaman Pengumuman memuat daftar dari REST API, lalu ketuk salah satu item untuk membuka halaman detail.
4. Halaman Catatan menampilkan daftar dari SQLite. Tombol tambah membuka dialog dengan validasi judul.

---

## Hasil yang Dicapai

Status paruh semester: **lolos**. Aplikasi berjalan identik dengan akhir Minggu 7, dengan dua perbaikan yang lahir dari proses review. Tiga pemeriksaan mesin hijau: `flutter analyze` tanpa isu, `dart format` nol perubahan, dan 19 tes lulus. Minimal satu PR kecil di-merge melalui proses review, dan seluruh temuan review sudah ditindaklanjuti.

---

## Peta Issue dan Pull Request

| Issue | Judul | Branch | PR | Status |
|:--:|---|---|:--:|---|
| #1 | Judul catatan bisa kosong saat disimpan | `feat/notes-validation` | #5 | Merged |
| #2 | Halaman detail pengumuman gagal dibuka | `fix/announcement-route` | #6 | Merged |
| - | Folder Week 8 belum berisi project | `chore/week8-scaffold` | #3 | Merged |
| - | Format kode belum seragam | `style/week8-format` | #4 | Merged |
| - | Dokumen review dan CI belum ada | `docs/week8-review` | #7 | Merged |
| - | Hasil Week 8 belum masuk `main` | `develop` | #8 | Merged |
| - | Root README masih menandai Week 8 *Coming Soon* | `docs/week8-root` | #9 | Merged |

Tautan lengkap setiap issue dan PR, beserta alasan tiap keputusan, ada di
[`docs/issue-pr-map.md`](docs/issue-pr-map.md) dan [`docs/pr-notes.md`](docs/pr-notes.md).

---

## Tahapan Praktikum

### Praktikum 1: Audit Riwayat Git dan Commit Konvensional
<img src="screenshots/Praktikum 1 - Git Log dan Branch.png" width="600" alt="Git Log dan Branch"> <img src="screenshots/Praktikum 1 - Commit Sebelum dan Sesudah.png" width="400" alt="Commit Sebelum dan Sesudah">

> **Keterangan gambar**
> - Audit menemukan bahwa seluruh commit lama langsung masuk ke `main` tanpa branch integrasi dan tanpa format konvensional.
> - Branch `develop` dibuat dari `main` satu kali, lalu dijadikan target default seluruh Pull Request.
> - Tiga pesan commit lama ditulis ulang ke format `tipe(scope): deskripsi` beserta alasannya.

### Praktikum 2: Pull Request dan Peer Review
<img src="screenshots/Praktikum 1 - Halaman Login.png" width="250" alt="Halaman Login"> <img src="screenshots/Praktikum 1 - Halaman Home.png" width="250" alt="Halaman Home"> <img src="screenshots/Praktikum 1 - Halaman Pengumuman.png" width="250" alt="Halaman Pengumuman">

> **Keterangan gambar**
> - Alur aplikasi tetap utuh setelah perombakan struktur branch: Login, Home, lalu daftar Pengumuman.
> - Review menemukan tiga masalah nyata pada alur ini: route detail yang salah escape, widget yang memanggil repository langsung, dan tidak adanya validasi judul.

<img src="screenshots/Praktikum 2 - Detail Pengumuman (Route Fix).png" width="250" alt="Detail Pengumuman">

> **Keterangan gambar**
> - Halaman detail pengumuman berhasil dibuka dengan id yang benar setelah `\$` pada route diganti `AppRoutes.announcementDetailPath()`.
> - Sebelum perbaikan, rute menjadi string literal `/pengumuman/${item.id}` sehingga halaman detail tidak pernah terbuka.

### Praktikum 3: Static Analysis, Format, Test, dan CI
<img src="screenshots/Praktikum 3 - Flutter Analyze Bersih.png" width="500" alt="Flutter Analyze Bersih"> <img src="screenshots/Praktikum 3 - Dart Format Bersih.png" width="400" alt="Dart Format Bersih">
<br><img src="screenshots/Praktikum 3 - Flutter Test Hijau.png" width="400" alt="Flutter Test Hijau"> <img src="screenshots/Praktikum 3 - CI Workflow Hijau.png" width="500" alt="CI Workflow Hijau">

> **Keterangan gambar**
> - `flutter analyze` selesai tanpa satu pun isu.
> - `dart format --set-exit-if-changed lib test` melaporkan nol file berubah.
> - Seluruh 19 tes lulus, mencakup Use Case, validasi, dan route.
> - Workflow `ci` pada GitHub Actions berjalan sukses, menjalankan analyze, verifikasi format, dan test sebelum PR dibaca manusia.
> - Workflow yang sama kini memakai matriks sehingga Week 8, 9, 10, dan 11 diverifikasi sekaligus pada setiap push.

<img src="screenshots/Praktikum 3 - Halaman Catatan Kosong.png" width="250" alt="Halaman Catatan Kosong"> <img src="screenshots/Praktikum 3 - Dialog Catatan Baru.png" width="250" alt="Dialog Catatan Baru"> <img src="screenshots/Praktikum 3 - Halaman Catatan Validasi Judul.png" width="250" alt="Validasi Judul">

> **Keterangan gambar**
> - Kondisi awal halaman Catatan menampilkan *empty state*.
> - Tombol tambah membuka dialog `Catatan Baru` dengan kolom Judul dan Isi.
> - Menekan Simpan tanpa judul memunculkan pesan `Judul tidak boleh kosong.` sebelum data menyentuh SQLite.

<img src="screenshots/Praktikum 3 - Dialog Catatan Terisi.png" width="250" alt="Dialog Catatan Terisi"> <img src="screenshots/Praktikum 3 - Halaman Catatan Terisi.png" width="250" alt="Halaman Catatan Terisi">

> **Keterangan gambar**
> - Dialog terisi judul `Rencana Belajar` dan isi `Bab 1 dan Bab 3`.
> - Setelah disimpan, catatan muncul di daftar dengan judul tebal dan isi terpotong dua baris.

### Refactoring & Testing
<img src="screenshots/Refactoring - Git Graph Akhir.png" width="600" alt="Git Graph Akhir">

> **Keterangan gambar**
> - Grafik commit memperlihatkan setiap branch fitur yang di-merge dengan `--no-ff` ke `develop`.
> - Jejak branch tetap terlihat sehingga riwayat mudah ditelusuri dan di-revert per fitur.
> - Branch fitur dihapus setelah merge agar daftar branch tetap pendek.

---

## AI Prompt Challenge

Prompt review yang dipakai, output awal AI, tabel usulan versus keputusan final, serta bukti penolakan dan penerimaan dicatat pada dokumen terpisah.

<img src="screenshots/AI Challenge - Review AI vs Keputusan.png" width="600" alt="Review AI vs Keputusan">

👉 [**Lihat Pembahasan AI Review vs Keputusan (ai-review-vs-keputusan.md)**](docs/ai-review-vs-keputusan.md)

---

## Refleksi

**1. Apa beda LGTM buta dengan approve yang bertanggung jawab? Apa risikonya bagi tim?**

LGTM buta berarti menyetujui tanpa membuka kode, tanpa menjalankan tes, dan tanpa mencoba alurnya. Approve yang bertanggung jawab berarti reviewer benar-benar membuka diff, memeriksa jalur *error*, menjalankan `flutter analyze` dan `flutter test`, lalu menguji manual di perangkat. Risikonya nyata: pada praktikum ini, kalau review dilakukan asal setuju, route detail yang salah escape akan lolos ke `develop` dan halaman detail pengumuman tetap tidak bisa dibuka tanpa ada yang menyadari.

**2. Kapan komentar wajib berstatus request changes, dan kapan cukup saran?**

Komentar wajib `request changes` ketika temuannya menyangkut kebenaran yang terlihat pengguna, pelanggaran *dependency rule*, atau tidak adanya tes pada jalur gagal. Contohnya route yang salah escape dan validasi judul yang tidak ada. Saran cukup dipakai untuk hal yang tidak mengubah perilaku, misalnya preferensi penamaan variabel atau struktur folder yang masih dapat diterima. Temuan gaya berulang tidak perlu dikomentari satu per satu, cukup diserahkan ke `dart format` dan CI.

**3. Bagian mana dari review AI yang Anda tolak atau sederhanakan, dan mengapa?**

Saya menolak dua saran AI. Pertama, usulan mengganti `ref.read` pada `redirect` GoRouter menjadi `refreshListenable` karena GoRouter sudah mengevaluasi `redirect` pada setiap navigasi, sehingga perubahan itu hanya menambah kompleksitas tanpa memperbaiki bug. Kedua, usulan mengubah `notesProvider` menjadi `AsyncNotifier` dengan *optimistic update* karena untuk CRUD satu tabel `ref.invalidate` sudah cukup. Saya juga menyederhanakan temuan *trailing comma* dan panjang baris dengan mengalihkannya ke `dart format`, bukan menyunting manual.

**4. Satu hal konkret yang Anda perbaiki setelah review sejawat, apa dampaknya?**

Saya memindahkan validasi judul dari widget ke *Use Case* `AddNote` pada *Domain Layer*. Dampaknya, aturan bisnis bisa diuji tanpa membangun widget, terbukti lewat tiga tes baru di `test/add_note_test.dart`. Efek sampingnya juga positif: `FloatingActionButton` tidak lagi memanggil `noteRepositoryProvider` langsung, sehingga *Dependency Rule* Minggu 7 tetap utuh. Bug tambahan juga ditemukan saat uji manual, yaitu controller dialog yang di-*dispose* terlalu cepat dan memicu kegagalan assertion; perbaikannya adalah memindahkan controller ke `StatefulWidget` dialog.

---

## Referensi

- [Slide Week 8: Mid Project Review & Code Review](https://jti-polinema.github.io/flutter-codelab/00-slides/Week_08_Mid_Project_Review_Code_Review.html)
- [Atlassian: GitFlow workflow](https://www.atlassian.com/git/tutorials/comparing-workflows/gitflow-workflow)
- [GitHub: About pull request reviews](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/reviewing-changes-in-pull-requests/about-pull-request-reviews)
- [Conventional Commits](https://www.conventionalcommits.org/)
- [Flutter: Static analysis & IDE integration](https://docs.flutter.dev/testing/overview)
- [Dart: Linter rules](https://dart.dev/tools/linter-rules)
- [GitHub Actions documentation](https://docs.github.com/en/actions)
- [Learn Dart in Y Minutes](https://learnxinyminutes.com/dart/)
