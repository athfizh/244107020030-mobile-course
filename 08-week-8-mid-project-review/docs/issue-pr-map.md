# Peta Issue dan Pull Request - Minggu 8

**Nama:** Athaulla Hafizh
**NIM:** 244107020030
**Tanggal:** 2 November 2026

---

## 1. Alur Kerja

```text
issue #1  -> branch feat/notes-validation   -> PR #5 -> review -> merge ke develop
issue #2  -> branch fix/announcement-route  -> PR #6 -> review -> merge ke develop
             branch chore/week8-scaffold    -> PR #3 -> merge ke develop
             branch style/week8-format      -> PR #4 -> merge ke develop
             branch docs/week8-review       -> PR #7 -> merge ke develop
develop   -> PR rilis -> merge ke main
```

## 2. Tabel Peta

| Issue | Judul Issue | Branch | PR | Status | Bukti Uji |
|:--:|---|---|:--:|---|---|
| #1 | Judul catatan bisa kosong saat disimpan | `feat/notes-validation` | #5 | Merged | `test/add_note_test.dart` (3 tes) |
| #2 | Halaman detail pengumuman gagal dibuka | `fix/announcement-route` | #6 | Merged | `test/route_test.dart` (5 tes) |
| - | Folder Week 8 belum berisi project | `chore/week8-scaffold` | #3 | Merged | `flutter analyze` dan `flutter test` |
| - | Format kode belum seragam | `style/week8-format` | #4 | Merged | `dart format --set-exit-if-changed lib test` |
| - | Dokumen review dan CI belum ada | `docs/week8-review` | #7 | Merged | README dan empat dokumen di `docs/` |

## 3. Tautan

- Issue #1: https://github.com/athfizh/244107020030-mobile-course/issues/1
- Issue #2: https://github.com/athfizh/244107020030-mobile-course/issues/2
- PR #3: https://github.com/athfizh/244107020030-mobile-course/pull/3
- PR #4: https://github.com/athfizh/244107020030-mobile-course/pull/4
- PR #5: https://github.com/athfizh/244107020030-mobile-course/pull/5
- PR #6: https://github.com/athfizh/244107020030-mobile-course/pull/6
- PR #7: https://github.com/athfizh/244107020030-mobile-course/pull/7

## 4. Aturan yang Dijaga

1. Tidak ada commit langsung ke `main`.
2. Setiap PR berasal dari satu issue yang jelas, kecuali pekerjaan mekanis seperti scaffold, format, dan dokumentasi.
3. Setiap PR menyertakan bagian **Masalah**, **Solusi**, **Cara uji**, dan **Closes** bila relevan.
4. Ukuran PR dijaga di bawah 300 baris perubahan, kecuali PR scaffold yang hanya menyalin file.
5. Branch dihapus setelah merge agar daftar branch tetap pendek.

## 5. Status Akhir

```text
main      -> berisi seluruh hasil Minggu 1 sampai Minggu 8
develop   -> sinkron dengan main setelah rilis
branch    -> hanya menyisakan main dan develop
```
