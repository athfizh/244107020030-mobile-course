# Performance Findings - Minggu 11

**Nama:** Athaulla Hafizh
**NIM:** 244107020030
**Tanggal:** 2 November 2026
**Perangkat:** Emulator Pixel 8, Android 17.0 (`CinnamonBun`), x86_64, 1080x2400
**Mode:** `flutter build apk --profile` + `adb logcat`

---

## 1. Metode Pengukuran

Pengukuran tidak memakai DevTools browser, melainkan `SchedulerBinding.addTimingsCallback`
lewat `FrameTimingRecorder`. Setiap frame dicatat pada tiga nilai:

- `buildDuration` - waktu UI thread membangun widget.
- `rasterDuration` - waktu GPU thread menggambar.
- `totalSpan` - total waktu frame.

Skenario yang dijalankan identik pada kedua versi:

1. Login.
2. Buka halaman Pengumuman.
3. Gulir cepat ke bawah enam kali.
4. Buka halaman detail.
5. Kembali.
6. Gulir balik ke atas empat kali.

Ambang *jank* yang dipakai 16,67 ms (target 60 FPS).

## 2. Baseline (Week 10)

| Metrik | Nilai |
|---|---|
| Frame sampel | 111 |
| Rata-rata build | 0,66 ms |
| Rata-rata raster | 16,50 ms |
| Rata-rata total | 33,34 ms |
| p90 total | 28,81 ms |
| p95 total | 33,67 ms |
| Frame jank | 104 dari 111 (93,7%) |
| Total PSS | 82.363 KB |

## 3. Temuan Masalah

### Temuan 1 - Rebuild berlebih pada daftar pengumuman

`ListView.separated` membangun `ListTile` secara *inline* di dalam `itemBuilder`.
Setiap perubahan state memaksa seluruh item yang terlihat dibangun ulang, dan
tidak ada `itemExtent` sehingga Flutter harus mengukur tinggi setiap item.

**Bukti:** rata-rata raster 16,50 ms, mendekati ambang 16,67 ms, dan 93,7% frame
melewati anggaran.

### Temuan 2 - Tidak ada isolasi repaint

Baik daftar pengumuman maupun daftar catatan tidak memakai `RepaintBoundary`.
Satu perubahan kecil memaksa area luas digambar ulang.

### Temuan 3 - `ref.watch` terlalu lebar pada halaman catatan

`NotesPage` melakukan `ref.watch(notesQueryProvider)` untuk seluruh kata kunci.
Akibatnya setiap ketukan pada kolom pencarian membangun ulang seluruh halaman,
padahal yang berubah hanya ada atau tidaknya tombol hapus.

### Temuan 4 - Semua data dimuat sekaligus tanpa cache

`AnnouncementRepositoryImpl` meminta `_limit: 10` tanpa `_start`, sehingga
paginasi tidak pernah berjalan. Tidak ada cache, sehingga setiap kali halaman
dibuka ulang aplikasi memanggil API lagi. Ini memboroskan kuota dan menambah
waktu tunggu.

### Temuan 5 - Gelembung chat ikut digambar ulang saat streaming

Setiap potongan teks dari Gemini memicu `state` baru pada `AiChatNotifier`,
yang membangun ulang seluruh `ListView` chat, bukan hanya gelembung terakhir.

## 4. Ringkasan Prioritas

| No | Temuan | Dampak | Prioritas |
|:--:|---|---|:--:|
| 1 | Rebuild berlebih pada daftar | Raster hampir menyentuh anggaran frame | Tinggi |
| 2 | Tanpa RepaintBoundary | Repaint area luas | Tinggi |
| 3 | `ref.watch` terlalu lebar | Rebuild halaman tiap ketukan | Sedang |
| 4 | Tanpa paginasi dan cache | Boros kuota dan waktu tunggu | Tinggi |
| 5 | Chat rebuild seluruh daftar | Streaming terasa berat | Sedang |
