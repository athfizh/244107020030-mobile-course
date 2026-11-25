# Minggu 12 Testing & Quality Assurance

**Nama:** Athaulla Hafizh  
**NIM:** 244107020030  

---

## Tujuan

Praktikum ini menambahkan lapisan pengujian pada project hasil Minggu 11. Fokusnya bukan mengejar angka *coverage*, melainkan memastikan perilaku penting benar-benar diperiksa: aturan bisnis, validasi input, penanganan error, interaksi widget, dan satu alur utama dari login sampai catatan tersimpan. Pengujian dijalankan pada emulator Pixel 8 dengan Android 17.

---

## Fitur Utama

| Fitur | Keterangan |
|---|---|
| Unit Test Logika | Aturan validasi, pencarian, paginasi, cache, dan use case diuji tanpa UI |
| Fake Repository | `FakeAuthRepository`, `FakeNoteRepository`, dan `FakeAnnouncementRepository` menggantikan jaringan serta database |
| Widget Test Login | Memeriksa form, indikator loading, dan pesan kegagalan kredensial |
| Widget Test Catatan | Memeriksa validasi judul kosong dan penyimpanan catatan valid |
| Widget Test Pengumuman | Memeriksa state loading, error, dan daftar data |
| Integration Test | Alur login → Home → Catatan → tambah catatan dijalankan di emulator |
| Laporan Coverage | `flutter test --coverage` menghasilkan `coverage/lcov.info` |
| Pemeriksaan Mesin | `flutter analyze`, `dart format`, dan `flutter test` dijalankan sebelum commit |

---

## Stack Teknologi
1. Bahasa Dart 3.13.2
2. Framework Flutter SDK 3.47.2
3. Package `flutter_riverpod` 2.6.1, `go_router` 14.8.1, `dio` 5.8.0, `flutter_secure_storage` 9.2.4, `sqflite` 2.4.4, `path` 1.9.1, `intl` 0.20.3, `http` 1.2.0, `shared_preferences` 2.5.5
4. Package pengujian `flutter_test` dan `integration_test`
5. Tools Android Studio, Git, Flutter CLI, `adb`
6. Perangkat: Emulator Pixel 8, Android 17 (API 37), x86_64, 1080x2400

---

## Cara Menjalankan
```bash
cd 12-week-12-testing-quality-assurance

flutter pub get

flutter run

flutter test
```

Menjalankan pengujian integrasi pada emulator:
```bash
flutter test integration_test/app_test.dart -d emulator-5554
```

Menghasilkan laporan cakupan:
```bash
flutter test --coverage
```

Keterangan alur aplikasi:
1. Login memakai kredensial contoh `eve.holt@reqres.in` / `cityslicka`.
2. Dari Home, buka **Catatan Pribadi**.
3. Tekan tombol **+**, lalu simpan catatan. Judul kosong ditolak dengan pesan validasi.
4. Catatan baru langsung muncul pada daftar.

---

## Hasil yang Dicapai

Seluruh **65 tes** lulus: 57 tes lama dari Minggu 11 dan 8 tes baru untuk login, dialog catatan, serta state halaman pengumuman. Pengujian integrasi berhasil dijalankan di emulator Pixel 8 dan membuktikan alur login sampai catatan tersimpan. Cakupan baris mencapai **67,52% (318 dari 471 baris)**. `flutter analyze` bersih, dan `dart format` melaporkan nol file berubah.

---

## Skenario Pengujian

| No | Skenario | Jenis | Hasil |
|:--:|---|---|:--:|
| 1 | Judul catatan kosong ditolak | Unit + Widget | Lulus |
| 2 | Judul berisi spasi saja ditolak | Unit | Lulus |
| 3 | Judul valid dipangkas lalu disimpan | Unit | Lulus |
| 4 | Pencarian tidak membedakan huruf besar/kecil | Unit + Widget | Lulus |
| 5 | Query tanpa hasil menampilkan *empty state* | Widget | Lulus |
| 6 | Login menampilkan indikator loading | Widget | Lulus |
| 7 | Kredensial ditolak menampilkan pesan error | Widget | Lulus |
| 8 | Halaman pengumuman menampilkan loading | Widget | Lulus |
| 9 | Kegagalan jaringan menampilkan tombol coba lagi | Widget | Lulus |
| 10 | Daftar pengumuman tampil dari repository | Widget | Lulus |
| 11 | Alur login sampai tambah catatan | Integrasi | Lulus |
| 12 | Paginasi berhenti saat `hasMore` bernilai false | Unit | Lulus |

---

## Tahapan Praktikum

### Praktikum 1: Unit Test dan Fake Repository

<img src="screenshots/Praktikum 1 - Struktur Berkas Test.png" width="700" alt="Struktur Berkas Test">

> **Keterangan gambar**
> - Delapan berkas test baru ditambahkan di samping 13 berkas test Minggu 11.
> - `integration_test/app_test.dart` dipisahkan dari folder `test/` karena dijalankan pada perangkat, bukan di VM pengujian.

<img src="screenshots/Praktikum 1 - Hasil Unit dan Widget Test.png" width="700" alt="Hasil Unit dan Widget Test">

> **Keterangan gambar**
> - Seluruh 65 tes lulus dalam waktu sekitar dua detik.
> - Tidak ada test yang bergantung pada jaringan atau database asli karena dependensi diganti fake.

### Praktikum 2: Widget Test untuk Validasi dan Interaksi

<img src="screenshots/Praktikum 2 - Dialog Catatan Baru di Emulator.png" width="300" alt="Dialog Catatan Baru"> <img src="screenshots/Praktikum 2 - Validasi Judul Kosong di Emulator.png" width="300" alt="Validasi Judul Kosong">

> **Keterangan gambar**
> - Dialog `Catatan Baru` diuji lewat `find.byType(TextFormField)` dan tombol `Simpan`.
> - Menekan **Simpan** tanpa judul memunculkan pesan `Judul tidak boleh kosong.` dan tidak menyentuh repository.
> - Validasi ini sudah ada sejak Minggu 11, tetapi baru sekarang dikunci dengan widget test agar tidak regresi.

<img src="screenshots/Praktikum 2 - Mengisi Catatan di Emulator.png" width="300" alt="Mengisi Catatan">

> **Keterangan gambar**
> - Widget test kedua mengisi judul dan isi, menekan **Simpan**, lalu memastikan catatan muncul pada daftar.
> - Fake repository mencatat pemanggilan sehingga test dapat memeriksa data yang benar-benar disimpan.

### Praktikum 3: Integration Test dan Coverage

<img src="screenshots/Praktikum 3 - Integration Test di Emulator.png" width="700" alt="Integration Test di Emulator">

> **Keterangan gambar**
> - `flutter test integration_test/app_test.dart -d emulator-5554` membangun APK debug, memasangnya, lalu menjalankan alur utama.
> - Test menunggu halaman Home muncul dengan batas waktu 60 detik agar tidak bergantung pada kecepatan jaringan.
> - Hasil: `All tests passed!` pada perangkat Pixel 8.

<img src="screenshots/Praktikum 3 - Home Setelah Login.png" width="300" alt="Home Setelah Login"> <img src="screenshots/Praktikum 3 - Halaman Catatan di Emulator.png" width="300" alt="Halaman Catatan"> <img src="screenshots/Praktikum 3 - Catatan Berhasil Ditambahkan.png" width="300" alt="Catatan Berhasil Ditambahkan">

> **Keterangan gambar**
> - Login nyata ke `reqres.in` berhasil dan sesi disimpan di `flutter_secure_storage`.
> - Halaman Catatan diuji dalam keadaan kosong, lalu diisi satu catatan.
> - Catatan `Rencana praktikum testing` tersimpan di SQLite dan langsung tampil pada daftar.

<img src="screenshots/Praktikum 3 - Ringkasan Coverage.png" width="700" alt="Ringkasan Coverage">

> **Keterangan gambar**
> - `flutter test --coverage` menghasilkan `coverage/lcov.info`.
> - Cakupan baris 318/471 atau 67,52%. Angka ini tidak dikejar sampai 100% karena halaman streaming AI dan integrasi penyimpanan aman lebih mahal untuk diuji daripada nilainya pada tahap ini.
> - Cabang yang belum tercakup dicatat jujur pada bagian temuan.

### Refactoring & Testing

<img src="screenshots/Refactoring - Flutter Analyze dan Test.png" width="600" alt="Flutter Analyze dan Test"> <img src="screenshots/Refactoring - Hasil Flutter Format.png" width="500" alt="Hasil Flutter Format">

> **Keterangan gambar**
> - `flutter analyze` bersih tanpa isu.
> - Seluruh 65 tes lulus setelah penambahan test baru.
> - `dart format --output=none --set-exit-if-changed lib test integration_test` melaporkan 71 file diperiksa dan 0 berubah.

---

## Temuan yang Belum Terselesaikan

1. **Streaming AI belum diuji end-to-end.** Pengujian berhenti pada `AskAi` dan cache; parsing SSE serta pembatalan stream belum punya test karena membutuhkan server tiruan.
2. **`flutter_secure_storage` hanya diuji lewat fake.** Perilaku Keystore asli baru terbukti saat integration test berjalan di perangkat.
3. **Cakupan halaman detail pengumuman masih rendah.** Halaman ini hanya diuji secara tidak langsung lewat route.
4. **Test integrasi bergantung pada jaringan.** `reqres.in` adalah layanan demo; jika kuota harian habis, test akan gagal karena alasan yang bukan bug aplikasi.

---

## AI Prompt Challenge

Prompt yang dipakai untuk meminta bantuan menyusun skenario dan meninjau test:

```text
Konteks: aplikasi Flutter feature-first dengan fitur login, pengumuman,
catatan SQLite, dan chat AI. Sudah ada 57 unit test. Saya ingin menambah
pengujian untuk Minggu 12 (testing & QA).

Tugas: usulkan maksimal 8 skenario baru yang memberi nilai tinggi, bukan
sekadar menaikkan coverage. Untuk tiap skenario sebutkan jenis (unit,
widget, integrasi), data uji, dan alasan mengapa skenario itu penting.

Batasan: jangan menyarankan menambah package baru, jangan menguji getter
sepele, dan jangan memakai Future.delayed untuk membuat test lulus.
```

### Ringkasan Saran AI dan Keputusan

| Saran AI | Keputusan | Alasan Teknis |
|---|---|---|
| Uji validasi judul kosong dan spasi saja | **Diterima** | Aturan bisnis yang paling mudah rusak saat refactor |
| Uji state loading dan error halaman pengumuman | **Diterima** | Dua state ini sering terlewat karena test hanya menguji data sukses |
| Uji login dengan kredensial salah | **Diterima** | Memastikan error tidak berubah diam-diam menjadi sesi valid |
| Uji seluruh getter entity | **Ditolak** | Tidak memeriksa perilaku; hanya menambah jumlah test |
| Tambah `mockito` dan `build_runner` | **Ditolak** | Fake manual sudah cukup; menambah dependensi hanya untuk 3 kelas |
| Uji streaming AI dengan server lokal | **Ditunda** | Membutuhkan server tiruan dan waktu; dicatat sebagai temuan |
| Uji setiap kombinasi query pencarian | **Ditolak** | Sudah diwakili test case-insensitive dan spasi tepi |

Saran yang diterima dijalankan dan diverifikasi dengan `flutter test` serta integration test pada emulator. Klaim AI bahwa "widget test bisa menggantikan integration test" ditolak karena widget test tidak menyentuh penyimpanan aman dan SQLite asli.

---

## Refleksi

**1. Bug apa yang paling mungkin terlewat tanpa pengujian yang Anda tulis?**

Bug pada perpindahan state. Contohnya, tombol Login yang tetap aktif saat proses login berjalan, atau halaman pengumuman yang menampilkan layar kosong ketika jaringan gagal. Keduanya tidak terlihat dari pembacaan kode sekilas dan baru muncul saat perangkat dipakai. Widget test memaksa saya memeriksa state loading dan error secara eksplisit.

**2. Bagian mana yang perlu fake, dan bagaimana fake itu membuat pengujian lebih konsisten?**

Tiga bagian: autentikasi, repository catatan, dan repository pengumuman. Ketiganya menyentuh dunia luar (jaringan, penyimpanan aman, SQLite). Dengan fake, test tidak bergantung pada kuota `reqres.in`, isi database perangkat, atau kecepatan jaringan. Fake juga bisa dipaksa gagal, sesuatu yang sulit dilakukan pada layanan nyata.

**3. Apa perbedaan nilai yang diberikan pengujian widget dan pengujian integrasi pada fitur Anda?**

Widget test cepat dan presisi: ia membuktikan satu layar bereaksi benar terhadap satu state, misalnya pesan validasi muncul. Namun widget test tidak membuktikan bahwa login benar-benar menyimpan token atau SQLite benar-benar menulis catatan. Integration test menutup celah itu, tetapi lebih lambat, lebih rapuh, dan hanya layak untuk satu alur utama.

---

## Referensi

- [Codelab Minggu 12: Pengujian dan Jaminan Kualitas](https://jti-polinema.github.io/flutter-codelab/12-minggu-12-testing-quality-assurance/index.html)
- [Slide Minggu 12: Pengujian dan Jaminan Kualitas](https://jti-polinema.github.io/flutter-codelab/00-slides/Week_12_Testing_Quality_Assurance.html)
- [Testing Flutter apps](https://docs.flutter.dev/testing/overview)
- [Introduction to widget testing](https://docs.flutter.dev/cookbook/testing/widget/introduction)
- [Integration testing](https://docs.flutter.dev/testing/integration-tests)
- [Dart test package](https://pub.dev/packages/test)
- [Riverpod testing](https://riverpod.dev/docs/essentials/testing)
