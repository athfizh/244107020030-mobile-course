# Minggu 11 Performance Optimization

**Nama:** Athaulla Hafizh  
**NIM:** 244107020030  

---

## Tujuan

Praktikum ini mengoptimalkan performa project hasil Minggu 10 berdasarkan pengukuran nyata, bukan dugaan. Fokusnya mencakup pengurangan *rebuild* widget, isolasi *repaint*, efisiensi daftar panjang, paginasi, cache jaringan, serta pembuktian *before/after* memakai data `FrameTiming` dari perangkat.

---

## Fitur Utama

| Fitur | Keterangan |
|---|---|
| Widget `const` Terpisah | `AnnouncementTile` dan `NoteTile` diekstrak agar item tidak ikut dibangun ulang |
| `itemExtent` Tetap | Tinggi baris dipatok sehingga Flutter tidak mengukur ulang saat menggulir |
| `RepaintBoundary` | Isolasi repaint per item daftar dan per gelembung chat |
| Riverpod `select` | Hanya bagian yang bergantung pada nilai tertentu yang ikut *rebuild* |
| Paginasi Server | `_limit` dan `_start` dimuat bertahap lewat *infinite scroll* |
| Cache Stale-While-Revalidate | Data cache tampil lebih dulu, data segar menyusul, TTL 5 menit |
| Refresh Tanpa Kosong | `RefreshIndicator` menyegarkan daftar tanpa menghapus data lama |
| Frame Timing Recorder | Pencatatan `build`, `raster`, dan `total` setiap frame untuk bukti kuantitatif |

---

## Stack Teknologi
1. Bahasa Dart 3.13.2
2. Framework Flutter SDK 3.47.2
3. Package `flutter_riverpod` 2.6.1, `go_router` 14.8.1, `dio` 5.8.0, `flutter_secure_storage` 9.2.4, `sqflite` 2.4.4, `path` 1.9.1, `intl` 0.20.3, `http` 1.2.0, `shared_preferences` 2.5.5
4. Tools Android Studio, Git, Flutter CLI, `adb`
5. Perangkat: Emulator Pixel 8, Android 17.0, x86_64, 1080x2400

---

## Cara Menjalankan
```bash
cd 11-week-11-performance-optimization

flutter pub get

flutter run --profile

flutter test
```

Keterangan pengukuran:
1. Jalankan build profile, bukan debug, agar angka tidak terdistorsi.
2. Buka halaman Pengumuman, gulir cepat ke bawah, buka detail, kembali, lalu gulir balik.
3. Baris `FRAME build=... raster=... total=...` muncul pada `adb logcat -s flutter`.
4. Bandingkan hasilnya dengan `docs/performance-report.md`.

---

## Hasil yang Dicapai

Rata-rata waktu raster turun dari 16,50 ms menjadi 8,32 ms (turun 49,6%), dan rata-rata total frame turun dari 33,34 ms menjadi 19,24 ms (turun 42,3%). Frame *jank* turun dari 93,7% menjadi 37,1%. Sebagai konsekuensi, PSS naik sekitar 4,3 MB karena cache pengumuman dan buffer chat, dan ini dicatat jujur pada laporan. Seluruh pemeriksaan mesin hijau dengan 57 tes.

---

## Baseline vs After

| Metrik | Before | After | Perubahan |
|---|---|---|---|
| Rata-rata build | 0,66 ms | 0,63 ms | -4,5% |
| Rata-rata raster | 16,50 ms | 8,32 ms | -49,6% |
| Rata-rata total | 33,34 ms | 19,24 ms | -42,3% |
| p90 total | 28,81 ms | 21,99 ms | -23,7% |
| Frame jank | 93,7% | 37,1% | -56,6 pp |
| Total PSS | 82.363 KB | 86.684 KB | +5,2% |

Angka lengkap dan analisis trade-off ada di `docs/performance-report.md`.

---

## Tahapan Praktikum

### Praktikum 1: Baseline Profiling
<img src="screenshots/Praktikum 1 - Baseline Frame Chart.png" width="600" alt="Baseline Frame Chart">

> **Keterangan gambar**
> - Pengukuran baseline dilakukan pada build profile dengan skenario yang sama seperti versi After.
> - 111 frame tercatat dengan rata-rata raster 16,50 ms, hampir menyentuh anggaran 16,67 ms.
> - 93,7% frame melewati anggaran, tanda bahwa daftar belum efisien.

### Praktikum 2: Identifikasi Masalah
<img src="screenshots/Praktikum 2 - Temuan Rebuild Berlebih.png" width="600" alt="Temuan Rebuild">

> **Keterangan gambar**
> - Lima masalah utama teridentifikasi: rebuild berlebih, tanpa isolasi repaint, `ref.watch` terlalu lebar, tanpa paginasi dan cache, serta chat yang membangun ulang seluruh daftar.
> - Setiap temuan diberi prioritas berdasarkan dampaknya terhadap anggaran frame.

### Praktikum 3: Terapkan Optimasi dan Verifikasi
<img src="screenshots/Praktikum 3 - After Frame Chart.png" width="600" alt="After Frame Chart">

> **Keterangan gambar**
> - Setelah optimasi, 89 frame tercatat dengan rata-rata raster 8,32 ms.
> - Rata-rata total turun menjadi 19,24 ms dan frame jank turun menjadi 37,1%.

<img src="screenshots/Praktikum 3 - Perbandingan Metrics.png" width="600" alt="Perbandingan Metrics">

> **Keterangan gambar**
> - Tabel perbandingan menunjukkan penurunan waktu raster hampir setengahnya.
> - Kenaikan PSS sebesar 5,2% dicatat sebagai trade-off, bukan disembunyikan.

<img src="screenshots/Praktikum 3 - Halaman Home Setelah Optimasi.png" width="250" alt="Home Setelah Optimasi"> <img src="screenshots/Praktikum 3 - Halaman Pengumuman Setelah Optimasi.png" width="250" alt="Pengumuman Setelah Optimasi"> <img src="screenshots/Praktikum 3 - Halaman Catatan Setelah Optimasi.png" width="250" alt="Catatan Setelah Optimasi">

> **Keterangan gambar**
> - Tampilan tidak berubah secara visual setelah optimasi, sesuai prinsip bahwa optimasi performa tidak boleh mengubah perilaku.
> - Daftar pengumuman kini memuat bertahap lewat paginasi dan tetap menampilkan data cache saat dibuka kembali.
> - Daftar catatan memakai `NoteTile` dan `itemExtent` sehingga gulir terasa lebih ringan.

### Refactoring & Testing
<img src="screenshots/Refactoring - Flutter Analyze dan Test.png" width="600" alt="Analyze dan Test">

> **Keterangan gambar**
> - `flutter analyze` bersih tanpa isu.
> - Seluruh 57 tes lulus, termasuk 8 tes baru untuk cache pengumuman, paginasi, dan penghentian paginasi.

---

## Ringkasan Optimasi

1. Ekstraksi widget item menjadi `const`.
2. `ListView.builder` dengan `itemExtent`.
3. `RepaintBoundary` per item dan per gelembung chat.
4. `ref.watch` dengan `select`.
5. Paginasi `_limit` dan `_start`.
6. Cache *stale-while-revalidate*.
7. `RefreshIndicator` tanpa mengosongkan layar.
8. `FrameTimingRecorder` sebagai alat ukur.

---

## Refleksi

**1. Optimasi mana yang memberikan dampak terbesar dan mengapa?**

`RepaintBoundary` dan `itemExtent` memberi dampak terbesar. Keduanya bekerja pada akar masalah yang sama: biaya *raster*. `itemExtent` menghapus kebutuhan mengukur tinggi setiap item, sedangkan `RepaintBoundary` membatasi area yang digambar ulang. Karena *build* hanya 0,66 ms sementara *raster* 16,50 ms, perbaikan pada sisi raster memang paling terasa, terbukti dari penurunan 49,6%.

**2. Bagaimana Anda memverifikasi bahwa optimasi benar-benar bekerja (bukan placebo)?**

Saya mengukur dua kali dengan skenario identik: login, buka pengumuman, gulir enam kali, buka detail, kembali, gulir balik empat kali. Keduanya memakai build profile, bukan debug, dan perangkat yang sama. Angka dibandingkan pada metrik yang sama: rata-rata, p90, p95, dan persentase jank. Tanpa perbandingan itu, "terasa lebih cepat" tidak bisa dibuktikan.

**3. Trade-off apa yang Anda hadapi?**

Tiga trade-off utama. Pertama, kompleksitas: `AnnouncementsNotifier` kini mengelola `_page`, `_hasMore`, dan `_loadingMore`. Kedua, memori: cache menambah sekitar 4,3 MB PSS. Ketiga, kesegaran data: TTL 5 menit berarti pengguna bisa melihat data lama hingga 5 menit. Ketiganya saya terima karena pengumuman bukan data *real-time* dan biaya jaringan yang dihemat lebih besar.

**4. Kapan sebaiknya optimasi premature dihindari?**

Optimasi premature terjadi ketika kode diubah tanpa angka pendukung. Contohnya menambah `itemExtent` pada daftar berisi lima item, atau memasang `RepaintBoundary` di seluruh widget. Keduanya menambah kode tanpa manfaat terukur. Aturan yang saya pakai: ukur dulu, perbaiki masalah terbesar, lalu ukur ulang. Optimasi yang tidak bisa dibuktikan lewat metrik lebih baik ditunda.

---

## Referensi

- [Slide Week 11: Optimasi Performa](https://jti-polinema.github.io/flutter-codelab/00-slides/Week_11_Performance_Optimization.html)
- [Flutter DevTools Overview](https://docs.flutter.dev/tools/devtools/overview)
- [Flutter UI Performance](https://docs.flutter.dev/perf/ui-performance)
- [Flutter Performance Best Practices](https://docs.flutter.dev/perf/best-practices)
- [FrameTiming API](https://api.flutter.dev/flutter/dart-ui/FrameTiming-class.html)
- [cached_network_image package](https://pub.dev/packages/cached_network_image)
- [Dio HTTP Client](https://pub.dev/packages/dio)
- [Learn Dart in Y Minutes](https://learnxinyminutes.com/dart/)
- [Dart Language Tour](https://dart.dev/language)
