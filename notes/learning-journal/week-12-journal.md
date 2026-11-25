# Learning Journal - Semester Mobile Development

**Athaulla Hafizh | NIM: 244107020030**

---

## Minggu 12 - Testing & Quality Assurance

**Tanggal:** 9 November 2026

### Yang Dipelajari
- Perbedaan pengujian unit, widget, dan integrasi serta kapan masing-masing dipakai.
- Pola Arrange, Act, Assert untuk menyusun test yang mudah dibaca.
- Fake repository sebagai pengganti jaringan, penyimpanan aman, dan SQLite.
- `pumpWidget`, `enterText`, `tap`, dan `pumpAndSettle` untuk menguji interaksi widget.
- `integration_test` yang berjalan pada emulator dengan `flutter test ... -d <device>`.
- Membaca `lcov.info` dan menafsirkan cakupan baris tanpa mengejar 100%.

### Yang Dikerjakan
- [x] Menyalin project Minggu 11 menjadi project `week12_quality` yang mandiri.
- [x] Menambahkan `integration_test` pada `dev_dependencies`.
- [x] Menulis widget test login untuk form, loading, dan pesan error.
- [x] Menulis widget test dialog catatan untuk judul kosong dan penyimpanan valid.
- [x] Menulis widget test pengumuman untuk state loading, error, dan data.
- [x] Menulis integration test login sampai catatan tersimpan di emulator.
- [x] Menjalankan 65 tes dan memastikan semuanya lulus.
- [x] Menghasilkan `coverage/lcov.info` dengan cakupan baris 67,52%.
- [x] Menjalankan `flutter analyze` dan `dart format` sampai bersih.

### Kendala & Solusi
- **Masalah:** Widget test login gagal dengan `No GoRouter found in context` saat login berhasil, karena `context.go` dipanggil tanpa router.
- **Solusi:** Skenario loading dipaksa berakhir dengan error agar `context.go` tidak dieksekusi; pengujian navigasi sukses diserahkan ke integration test.
- **Masalah:** Build Android gagal karena Kotlin tidak bisa menutup incremental cache dengan path berbeda antara pub cache dan project.
- **Solusi:** Menambahkan `kotlin.incremental=false` dan `kotlin.compiler.execution.strategy=in-process` pada `android/gradle.properties`, lalu `flutter clean`.
- **Masalah:** AVD Pixel 8 tidak terdeteksi karena berkas `.ini` di `~/.android/avd` hilang.
- **Solusi:** Membuat `Pixel_8.ini` yang menunjuk ke folder `Pixel_8_2.avd`, lalu memverifikasi dengan `flutter emulators`.
- **Masalah:** Test integrasi bergantung pada layanan `reqres.in`.
- **Solusi:** Menambahkan penantian berbasis waktu dan mencatat ketergantungan ini sebagai temuan, bukan menyembunyikannya.

### Key Takeaway
> Test yang baik bukan yang membuat coverage naik, tetapi yang akan gagal ketika perilaku penting rusak. Fake repository membuat test cepat dan deterministik, sementara integration test tetap diperlukan untuk membuktikan bahwa penyimpanan aman dan SQLite benar-benar bekerja di perangkat.
