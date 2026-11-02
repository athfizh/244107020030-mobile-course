# AI Review vs Keputusan Final - Minggu 8

**Nama:** Athaulla Hafizh
**NIM:** 244107020030
**Tanggal:** 2 November 2026

---

## 1. Prompt yang Digunakan

```text
Review PR Flutter ini sebagai senior Flutter dev.
Konteks: feature-first Clean Architecture (presentation -> domain <- data),
Riverpod, GoRouter, SQLite + Dio.
Fokus: kebenaran, arsitektur, dan test. Abaikan style.
Berikan 5 temuan teratas + level (blocker/saran)
+ alasan + usulan potongan kode perbaikan.
```

Konteks yang ditempel ke AI: struktur folder `lib/`, isi `announcement_repository.dart`, `note_repository.dart`, `routes.dart`, dan `notes_page.dart`. Tidak ada token, API key, atau data pribadi yang disertakan.

## 2. Output Awal AI (Ringkas)

AI memberikan lima temuan dengan level dan usulan perbaikan:

1. **blocker** - `announcements_page.dart` memakai `context.go('/pengumuman/\${item.id}')` sehingga `$` ter-escape dan rute menjadi literal.
2. **blocker** - `NotesPage` memanggil `noteRepositoryProvider` langsung dari `FloatingActionButton`, melewati *Use Case* dan tanpa validasi judul.
3. **saran** - Ada dua konfigurasi `Dio` berbeda: `dio_client.dart` tanpa *timeout*, sedangkan `AnnouncementRepositoryImpl` punya *fallback* dengan *timeout*.
4. **saran** - `ref.read(authStateProvider).value ?? false` di dalam `redirect` GoRouter dianggap tidak reaktif dan disarankan diganti `refreshListenable`.
5. **saran** - `notesProvider` disarankan diubah menjadi `AsyncNotifier` dengan *optimistic update* agar daftar langsung berubah tanpa `invalidate`.

## 3. Tabel Usulan vs Keputusan Final

| No | Temuan AI | Level | Keputusan | Alasan Teknis | Bukti |
|:--:|---|:--:|---|---|---|
| 1 | Escape `$` pada route detail | blocker | **Diterima** | `\$` membuat interpolasi tidak berjalan sehingga rute menjadi string literal `/pengumuman/${item.id}` dan halaman detail gagal dibuka | `test/route_test.dart` gagal sebelum diperbaiki, lulus setelah `AppRoutes.announcementDetailPath()` |
| 2 | Widget memanggil repository langsung | blocker | **Diterima + refactor** | Melanggar *Dependency Rule* Minggu 7. AI mengusulkan validasi di widget, saya pindahkan validasi ke *Use Case* `AddNote` di *Domain Layer* agar bisa diuji tanpa widget | `test/add_note_test.dart` (3 tes) dan `grep` presentation tanpa `noteRepositoryProvider` |
| 3 | Dua konfigurasi Dio | saran | **Diterima** | Satu sumber konfigurasi mencegah *timeout* yang tidak konsisten antar pemanggilan | `dio_client.dart` kini memuat `connectTimeout` dan `receiveTimeout`; `AnnouncementRepositoryImpl` mewajibkan `Dio` diinjeksi |
| 4 | `redirect` GoRouter tidak reaktif | saran | **Ditolak** | GoRouter mengevaluasi `redirect` pada setiap navigasi, sehingga `ref.read` sudah membaca state terbaru. Mengganti ke `refreshListenable` menambah kompleksitas dan mengubah perilaku di luar cakupan PR ini | Uji manual: login berhasil berpindah ke Home, logout kembali ke Login |
| 5 | `notesProvider` jadi `AsyncNotifier` + *optimistic update* | saran | **Ditolak** | Untuk CRUD satu tabel, `ref.invalidate` sudah cukup dan lebih sederhana. *Optimistic update* baru sepadan ketika ada jaringan dengan latensi nyata | Kode tetap `FutureProvider`, seluruh tes lulus |
| 6 | Kerapian *trailing comma* dan panjang baris | nitpick | **Dialihkan ke otomatisasi** | Temuan gaya berulang tidak diselesaikan manual, melainkan lewat `dart format` pada satu commit khusus | `style(week8): terapkan dart format pada seluruh project` |

## 4. Verifikasi Sebelum Menerapkan

| Pertanyaan Verifikasi | Jawaban |
|---|---|
| Apakah temuan benar-benar ada? | Ya, dibuktikan lewat `grep`, tes gagal, dan uji manual |
| Apakah usulan melanggar *dependency rule*? | Tidak. Temuan 2 justru diperbaiki dengan memindahkan logika ke *Domain* |
| Apakah AI hanya nitpick gaya? | Temuan 6 ya, sehingga diserahkan ke `dart format` |
| Apakah ada temuan yang ditolak? | Ada dua, yaitu temuan 4 dan 5, dengan alasan tertulis di tabel |

## 5. Catatan Tanggung Jawab

Prompt, output awal AI, tabel keputusan, dan bukti `analyze` + `test` disimpan pada folder `docs/`. Setiap keputusan di tabel dapat dijelaskan tanpa membuka catatan AI, karena alasannya bersandar pada aturan arsitektur dan hasil pengujian, bukan pada klaim model.
