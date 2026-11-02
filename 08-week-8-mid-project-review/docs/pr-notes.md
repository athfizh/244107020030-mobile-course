# Catatan Pull Request - Minggu 8

**Nama:** Athaulla Hafizh
**NIM:** 244107020030
**Tanggal:** 2 November 2026

---

## 1. Model Branching

```text
main      -> selalu bisa dirilis, tidak menerima commit langsung
develop   -> integrasi fitur mingguan, target default Pull Request
feature/* -> kerja harian satu fitur, umur pendek
fix/*     -> perbaikan cepat disertai test
```

Branch `develop` dibuat dari `main` satu kali, lalu dijadikan target default seluruh Pull Request Minggu 8.

## 2. Daftar Pull Request

### PR #3 - Scaffold project

- **Branch:** `chore/week8-scaffold` -> `develop`
- **Judul:** `chore(week8): salin project Minggu 7 sebagai baseline Minggu 8`
- **Masalah:** Folder `08-week-8-mid-project-review` masih kosong sehingga belum bisa direview.
- **Solusi:** Menyalin project Minggu 7, mengganti `name` pada `pubspec.yaml` menjadi `week8_mid_review`, dan menyesuaikan import pada `test/`.
- **Cara uji:** `flutter pub get`, lalu `flutter analyze` dan `flutter test` pada folder Week 8.
- **Catatan:** PR mekanis (salinan), tidak ada logika baru yang perlu dinilai.

### PR #4 - Format seragam

- **Branch:** `style/week8-format` -> `develop`
- **Judul:** `style(week8): terapkan dart format pada seluruh project`
- **Masalah:** Kode hasil salinan belum seragam format, dan temuan gaya berulang tidak efisien diselesaikan manual satu per satu di review.
- **Solusi:** Menerapkan `dart format` pada satu commit khusus.
- **Cara uji:** `dart format --set-exit-if-changed lib test` harus melaporkan 0 file berubah.

### PR #5 - Validasi judul catatan

- **Branch:** `feat/notes-validation` -> `develop`
- **Judul:** `feat(notes): validasi judul kosong + test`
- **Masalah:** Pengguna bisa menyimpan catatan tanpa judul, dan tombol tambah memanggil `noteRepositoryProvider` langsung dari widget sehingga melewati *Use Case*.
- **Solusi:** Menambah `AddNote` pada *Domain Layer* yang memangkas spasi dan menolak judul kosong dengan `ValidationFailure`, mengganti FAB menjadi dialog form, lalu memisahkan dialog ke `_AddNoteDialog` (`StatefulWidget`).
- **Cara uji:**
  1. Buka halaman Catatan Pribadi.
  2. Tekan tombol tambah, kosongkan judul, tekan Simpan -> muncul pesan `Judul tidak boleh kosong.`
  3. Isi judul, tekan Simpan -> catatan muncul di daftar.
  4. Jalankan `flutter test test/add_note_test.dart`.
- **Closes:** #1

### PR #6 - Perbaikan route dan konfigurasi Dio

- **Branch:** `fix/announcement-route` -> `develop`
- **Judul:** `fix(announcement): perbaiki route detail dan satukan konfigurasi Dio`
- **Masalah:** Rute detail pengumuman memakai `\$` sehingga `$` ter-escape dan halaman detail gagal dibuka. Selain itu ada dua konfigurasi `Dio` dengan *timeout* berbeda.
- **Solusi:** Menambah `AppRoutes.announcementDetailPath()`, memusatkan `connectTimeout` dan `receiveTimeout` pada `dio_client.dart`, dan mewajibkan `Dio` diinjeksi ke repository.
- **Cara uji:**
  1. Buka halaman Pengumuman Kampus.
  2. Ketuk salah satu item, halaman detail harus terbuka dengan id yang sesuai.
  3. Jalankan `flutter test test/route_test.dart`.
- **Closes:** #2

### PR #7 - Dokumentasi review

- **Branch:** `docs/week8-review` -> `develop`
- **Judul:** `docs(week8): checklist review, keputusan AI, peta issue/PR, dan README`
- **Masalah:** Belum ada dokumen bukti review dan belum ada CI yang menolak PR kotor.
- **Solusi:** Menambahkan `review-checklist.md`, `ai-review-vs-keputusan.md`, `pr-notes.md`, `issue-pr-map.md`, README Week 8, workflow CI, dan seluruh screenshot bukti.
- **Cara uji:** `flutter analyze`, `dart format --set-exit-if-changed lib test`, `flutter test` harus hijau.

### PR #8 - Rilis Week 8 ke main

- **Branch:** `develop` -> `main`
- **Judul:** `release(week8): mid project review siap dirilis`
- **Masalah:** Hasil Week 8 sudah terintegrasi di `develop`, tetapi `main` belum memuatnya padahal `main` adalah branch yang selalu bisa dirilis.
- **Solusi:** Menggabungkan seluruh hasil Week 8 ke `main` setelah workflow `ci` berstatus hijau.
- **Cara uji:** CI pada commit `develop` sukses, lalu jalankan `flutter analyze`, `dart format`, dan `flutter test` pada folder Week 8.
- **Bukti:** Screenshot `Praktikum 3 - CI Workflow Hijau.png`.

### PR #9 - Penanda status paruh semester

- **Branch:** `docs/week8-root` -> `develop`
- **Judul:** `docs: tandai minggu 8 selesai pada root readme dan portfolio summary`
- **Masalah:** Root `README.md` masih menulis Week 8 sebagai *Coming Soon* dan `portfolio-summary.md` belum memuat highlight Week 8.
- **Solusi:** Menandai Week 8 selesai pada kedua dokumen dan menambahkan bagian *Minggu 8 - Highlight* beserta refleksi kuncinya.
- **Cara uji:** Buka `README.md` dan `portfolio-summary.md`, pastikan baris Week 8 berstatus selesai.

## 3. Template PR yang Dipakai

```text
Judul: feat(notes): validasi judul kosong + test

Masalah: pengguna bisa menyimpan catatan tanpa judul.

Solusi: validasi di use case + pesan error di UI.

Cara uji:
1) tambah catatan kosong -> error muncul.
2) flutter test test/add_note_test.dart

Closes #1
```

## 4. Hasil Review Sejawat

Review dilakukan mandiri memakai checklist modul, karena tidak ada pasangan yang tersedia pada sesi ini. Setiap PR menerima satu review berisi empat kategori temuan: kebenaran, arsitektur, test, dan keterbacaan.

### Review pada PR #5

| No | Jenis Temuan | Isi | Tindak Lanjut |
|:--:|---|---|---|
| 1 | Kebenaran | Validasi judul hanya ada di `TextFormField`, hilang kalau ada jalur simpan lain | Dipindah ke *Use Case* `AddNote` |
| 2 | Arsitektur | FAB memanggil repository langsung | Diganti `addNoteProvider` |
| 3 | Test | Jalur gagal belum diuji | Ditambah 3 test (kosong, spasi saja, sukses) |
| 4 | Keterbacaan | Dialog sebaiknya widget sendiri | Dipisah ke `_AddNoteDialog` pada commit `5337208` |

Bug tambahan ditemukan saat uji manual: controller di-*dispose* ketika dialog masih beranimasi keluar sehingga muncul `'_dependents.isEmpty': is not true`. Perbaikan temuan 4 sekaligus menyelesaikan bug tersebut.

### Review pada PR #6

| No | Jenis Temuan | Isi | Tindak Lanjut |
|:--:|---|---|---|
| 1 | Kebenaran | Pastikan tidak ada string literal route tersisa | Diganti helper `AppRoutes.announcementDetailPath()` |
| 2 | Arsitektur | `ignore_for_file: prefer_initializing_formals` sebaiknya dihapus | **Ditolak sebagian**, *named parameter* tidak bisa memakai *initializing formal* privat |
| 3 | Test | Belum ada test konfigurasi `Dio` | Ditambah 2 test pada commit `a06aa58` |
| 4 | Keterbacaan | Helper route lebih baik daripada interpolasi manual | Diterima |

Keputusan akhir: **Approve** setelah seluruh temuan ditindaklanjuti.

## 5. Tindak Lanjut dan Merge

- Perbaikan dikerjakan pada branch masing-masing, bukan pada `main`.
- Merge memakai *merge commit* agar jejak branch tetap terlihat pada grafik commit.
- Issue #1 dan #2 tertutup otomatis lewat kata kunci `Closes #<nomor>`.
- Branch fitur dihapus setelah merge agar daftar branch tetap pendek.

## 6. Catatan Instrumen

`gh` CLI tidak tersedia pada mesin pengembang, sehingga issue dan Pull Request dibuat melalui GitHub REST API dengan kredensial yang sudah tersimpan pada *credential helper* Git. Branch di-push lebih dulu, lalu PR dibuka menuju `develop`.
