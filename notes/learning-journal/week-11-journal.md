# Learning Journal - Semester Mobile Development

**Athaulla Hafizh | NIM: 244107020030**

---

## Minggu 11 - Performance Optimization

**Tanggal:** 2 November 2026

### Yang Dipelajari
- Pipeline rendering Flutter: UI thread (`build`, `layout`, `paint`) dan raster thread (GPU), dengan anggaran frame 16,67 ms untuk 60 FPS.
- Perbedaan dampak optimasi pada sisi *build* dan sisi *raster*, serta mengapa mengukur keduanya penting.
- Teknik pengurangan *rebuild*: `const` constructor, ekstraksi widget, dan Riverpod `select`.
- Teknik isolasi *repaint* memakai `RepaintBoundary`.
- Efisiensi daftar panjang dengan `ListView.builder` dan `itemExtent`.
- Paginasi server dengan `_limit` dan `_start`, serta cache *stale-while-revalidate*.
- Pengukuran objektif memakai `SchedulerBinding.addTimingsCallback` dan `FrameTiming`.

### Yang Dikerjakan
- [x] Mengukur baseline Week 10 pada build profile dengan skenario gulir yang sama.
- [x] Menemukan lima masalah performa dan memberi prioritas berdasarkan dampak.
- [x] Mengekstrak `AnnouncementTile` dan `NoteTile` menjadi widget `const`.
- [x] Mengganti `ListView.separated` menjadi `ListView.builder` dengan `itemExtent`.
- [x] Menambahkan `RepaintBoundary` pada item daftar dan gelembung chat.
- [x] Mengganti `ref.watch(notesQueryProvider)` menjadi `select` pada halaman catatan.
- [x] Menambahkan paginasi `_limit` dan `_start` beserta *infinite scroll*.
- [x] Membuat `AnnouncementCache` dengan TTL 5 menit dan `RefreshIndicator`.
- [x] Membuat `FrameTimingRecorder` untuk bukti pengukuran *before/after*.
- [x] Menulis 7 test baru untuk cache pengumuman dan paginasi.
- [x] Mengukur ulang dan menyusun laporan performa beserta trade-off.

### Kendala & Solusi
- **Masalah:** DevTools browser tidak praktis dipakai berulang pada emulator, dan `dumpsys gfxinfo` mengembalikan nol frame untuk aplikasi Flutter.
- **Solusi:** Memakai `SchedulerBinding.addTimingsCallback` lewat `FrameTimingRecorder` yang mencetak `build`, `raster`, dan `total` ke log, sehingga angka bisa direproduksi kapan saja.
- **Masalah:** Emulator sempat mati di tengah pengukuran sehingga ADB kehilangan perangkat.
- **Solusi:** Menjalankan ulang `adb kill-server`, `adb start-server`, lalu meluncurkan `Pixel_8` dan menunggu `sys.boot_completed` bernilai 1.
- **Masalah:** `dart format` gagal karena direktori `build/` memiliki path terlalu panjang di Windows.
- **Solusi:** Membatasi cakupan ke `lib test` dan menyamakan perintah pada workflow CI.
- **Masalah:** Rata-rata PSS naik sekitar 4,3 MB setelah optimasi.
- **Solusi:** Tidak dihapus, tetapi dicatat sebagai trade-off di laporan karena kenaikannya berasal dari cache yang justru menghemat panggilan jaringan.

### Key Takeaway
> Optimasi tanpa pengukuran hanyalah tebakan yang dibungkus istilah teknis. Angka *before/after* pada skenario yang sama persis adalah satu-satunya cara membedakan perbaikan nyata dari placebo, sekaligus cara jujur mengakui trade-off seperti kenaikan memori.
