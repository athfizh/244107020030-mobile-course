# Minggu 5 Local Storage & Offline-First

**Nama:** Athaulla Hafizh  
**NIM:** 244107020030  

---

---

## Tujuan

Praktikum ini bertujuan untuk memahami implementasi penyimpanan lokal dan strategi *offline-first* di Flutter. Fokus utama mencakup penggunaan SharedPreferences untuk menyimpan preferensi pengguna, pemanfaatan SQLite (sqflite) untuk menyimpan daftar catatan secara persisten, dan perancangan arsitektur *cache-first* yang disinkronisasi ke cloud menggunakan antrean sinkronisasi *background*. Selain itu tahapan ini juga membahas cara melakukan refactoring dan *unit testing* dengan memanfaatkan pola *mock repository*.

## Fitur Utama

| Fitur | Keterangan |
|---|---|
| Preferensi Pengguna | Penyimpanan Mode Gelap/Terang dan jejak waktu buka aplikasi secara ringan melalui SharedPreferences |
| Database SQLite Terpusat | Penyimpanan tabel entitas catatan secara luring dengan *sqflite* demi meminimalisasi lonjakan konsumsi memori mematikan (OOM) |
| Sinkronisasi Latar Belakang | Manajemen *dirty flag* (antrean sinkronisasi *cloud*) yang tereksekusi tanpa memblokir pergerakan UI menggunakan isolasi *AsyncNotifier* |
| Pengujian Otomatis | Validasi integritas kode via lutter analyze dan lutter test yang menghasilkan 100% *clean code* |

---

## Tahapan Praktikum

### Praktikum 1: SharedPreferences
<img src="screenshots/Praktikum%201%20-%20Halaman%20Catatan%20%E2%80%94%20State%20Kosong.png" width="250" alt="Praktikum 1 - Halaman Catatan - State Kosong.png"> <img src="screenshots/Praktikum%201%20-%20Halaman%20Catatan%20%E2%80%94%20Dialog%20Tambah.png" width="250" alt="Praktikum 1 - Halaman Catatan - Dialog Tambah.png"> <img src="screenshots/Praktikum%201%20-%20Halaman%20Catatan%20%E2%80%94%20State%20Sukses%20%28Ada%20Data%29.png" width="250" alt="Praktikum 1 - Halaman Catatan - State Sukses (Ada Data).png">
<br><img src="screenshots/Praktikum%201%20-%20Halaman%20Pengaturan%20%E2%80%94%20Mode%20Terang.png" width="250" alt="Praktikum 1 - Halaman Pengaturan - Mode Terang.png"> <img src="screenshots/Praktikum%201%20-%20Halaman%20Pengaturan%20%E2%80%94%20Mode%20Gelap.png" width="250" alt="Praktikum 1 - Halaman Pengaturan - Mode Gelap.png">
<br><img src="screenshots/Praktikum%201%20-%20Hasil%20Flutter%20Analyze.png" width="500" alt="Praktikum 1 - Hasil Flutter Analyze.png">

> **Keterangan gambar**
> - Mode Gelap & Terang diatur dan disimpan secara persisten melalui SharedPreferences.
> - Waktu terakhir aplikasi dibuka juga dicatat dalam SharedPreferences dan ditampilkan pada halaman utama.

### Praktikum 2: SQLite dan Repository Catatan
<img src="screenshots/Praktikum%202%20-%20Halaman%20Catatan%20%E2%80%94%20State%20Kosong.png" width="250" alt="Praktikum 2 - Halaman Catatan - State Kosong.png"> <img src="screenshots/Praktikum%202%20-%20Halaman%20Catatan%20%E2%80%94%20Dialog%20Tambah.png" width="250" alt="Praktikum 2 - Halaman Catatan - Dialog Tambah.png">
<br><img src="screenshots/Praktikum%202%20-%20Halaman%20Catatan%20%E2%80%94%20State%20Sukses%20%2B%20Badge%20Cloud%20belum%20sync.png" width="250" alt="Praktikum 2 - Halaman Catatan - State Sukses + Badge Cloud belum sync.png"> <img src="screenshots/Praktikum%202%20-%20Halaman%20Catatan%20%E2%80%94%20Setelah%20Sync%20Badge%20Hilang.png" width="250" alt="Praktikum 2 - Halaman Catatan - Setelah Sync Badge Hilang.png">
<br><img src="screenshots/Praktikum%202%20-%20Hasil%20Flutter%20Analyze.png" width="500" alt="Praktikum 2 - Hasil Flutter Analyze.png">

> **Keterangan gambar**
> - Penyimpanan basis data tabel catatan ditangani menggunakan modul sqflite.
> - Ikon awan abu-abu menunjukkan indikasi data kotor (belum disinkronkan), ikon ceklis hijau menandakan data sudah sinkron (dummy).

### Praktikum 3: Cache-first dan Antrean Sync
<img src="screenshots/Praktikum%203%20-%20Halaman%20Feed%20%E2%80%94%20Cache%20Offline.png" width="250" alt="Praktikum 3 - Halaman Feed - Cache Offline.png"> <img src="screenshots/Praktikum%203%20-%20Halaman%20Pengaturan%20%E2%80%94%20Simulasi%20Offline%20NonAktif.png" width="250" alt="Praktikum 3 - Halaman Pengaturan - Simulasi Offline NonAktif.png"> <img src="screenshots/Praktikum%203%20-%20Halaman%20Pengaturan%20%E2%80%94%20Simulasi%20Offline%20Aktif.png" width="250" alt="Praktikum 3 - Halaman Pengaturan - Simulasi Offline Aktif.png">
<br><img src="screenshots/Praktikum%203%20-%20Halaman%20Catatan%20%E2%80%94%20Sinkronisasi%20Gagal%20%28Offline%29.png" width="250" alt="Praktikum 3 - Halaman Catatan - Sinkronisasi Gagal (Offline).png"> <img src="screenshots/Praktikum%203%20-%20Halaman%20Pengaturan%20%E2%80%94%20Berhasil%20Sinkronisasi.png" width="250" alt="Praktikum 3 - Halaman Pengaturan - Berhasil Sinkronisasi.png">
<br><img src="screenshots/Praktikum%203%20-%20Hasil%20Flutter%20Analyze.png" width="500" alt="Praktikum 3 - Hasil Flutter Analyze.png">

> **Keterangan gambar**
> - Saat fitur _Force Offline_ dinyalakan dari Pengaturan, sistem secara paksa akan menggunakan _cache_ yang telah disimpan pada SQLite, mencegah aplikasi layar kosong (Blank).
> - Notifikasi sinkronisasi gagal juga bekerja pada _background_ tanpa memblokir pergerakan antarmuka pengguna.

### Refactoring & Testing
<img src="screenshots/Refactoring%20-%20Halaman%20Catatan.png" width="250" alt="Refactoring - Halaman Catatan.png"> <img src="screenshots/Refactoring%20-%20Halaman%20Detail%20Catatan.png" width="250" alt="Refactoring - Halaman Detail Catatan.png">
<br><img src="screenshots/Refactoring%20-%20Hasil%20Flutter%20Test.png" width="500" alt="Refactoring - Hasil Flutter Test.png">

> **Keterangan gambar**
> - Navigasi Detail Catatan menggunakan _path routing_ (GoRouter).
> - Implementasi _Unit Test_ (Mocking Repository palsu) dan _Flutter Analyze_ menghasilkan persetujuan sempurna tanpa galat dan peringatan.

---

## Refleksi

**1. Mengapa daftar catatan tidak boleh disimpan di SharedPreferences? Apa yang rusak jika aturan ini dilanggar?**

_SharedPreferences_ memuat seluruh isi datanya ke dalam memori aplikasi (RAM) secara bersamaan saat dijalankan. Jika kita menaruh ribuan data JSON yang kompleks ke dalamnya, aplikasi bisa mengalami *Out-of-Memory (OOM)* atau _freeze_ saat proses _decoding/encoding_. Selain itu, kita sama sekali tidak bisa melakukan operasi SQL murni (misalnya memfilter WHERE dirty = 1).

**2. Kapan cache-first cukup, dan kapan Anda membutuhkan strategi lain (misalnya network-first untuk data harga real-time)?**

_Cache-first_ sangat cukup untuk jenis sistem konsumsi konten sosial atau artikel bacaan. Akan tetapi strategi _Network-first_ mutlak diperlukan apabila aplikasi berhubungan dengan saldo, harga saham _real-time_, atau tiket transportasi komersial untuk menghindari transaksi usang dan keputusan fatal pengguna akibat _cache_ lama.

**3. Bagaimana dirty flag berubah menjadi antrean sync tanpa memblokir UI? Kapan antrean terpisah (tabel outbox) menjadi perlu?**

Tugas antrean _sync_ ditarik ke dalam isolasi AsyncNotifier (Riverpod) yang mengeksekusi operasi secara asinkron di belakang panggung. Tabel antrean terpisah atau biasa dikenal tabel _outbox_ digunakan apabila aplikasi harus merekam rantai mutasi kompleks lintas entitas saat mode offline berjalan tanpa henti, bukannya sekedar sinkronisasi satu nilai.

**4. Bagian mana dari rekomendasi AI yang Anda tolak, dan mengapa?**

Saya menolak saran dari hasil keluaran generatif AI yang memaksakan adopsi _Drift_ di setiap kondisi aplikasi *offline-first*. Pemasangan dan pembangunan _codegen_ dari *Drift* memakan waktu dan boilerplate yang tidak ringkas, saya mempertahankan *sqflite* karena efisiensi baris kode _raw SQL_ lebih mendekatkan pengetahuan pengembang ke fundamental asli.

---

## AI Prompt Challenge

### Instruksi Prompt yang Digunakan
`	ext
Aplikasi Flutter Offline Notes: CRUD catatan + preferensi tema.
Bandingkan SharedPreferences, Hive, sqflite (SQLite), dan Drift
untuk dua kebutuhan ini. Requirements:
- Kriteria: kompleksitas query, kebutuhan relasi, reaktivitas (stream),
  type-safety, ukuran boilerplate, dan kemudahan testing.
- Beri rekomendasi final: mana untuk preferensi, mana untuk catatan,
  beserta alasannya dalam 1 tabel.
- Tunjukkan skema tabel/kotak untuk 1000+ catatan.
Jelaskan trade-off setiap pilihan.
`

### Hasil Verifikasi

| No | Poin Verifikasi | Hasil Pengecekan |
|---|---|---|
| 1 | Apakah AI menempatkan daftar catatan di SharedPreferences? | Tidak, AI menempatkannya di SQLite untuk meminimalisasi lonjakan konsumsi memori mematikan (OOM). |
| 2 | Apakah skema AI mendukung antrean sync (dirty flag / updated_at) atau hanya CRUD polos? | Ya, skema yang disusun memberikan index pendukung mutasi khusus dirty dan updated_at. |
| 3 | Apakah klaim "real-time" AI didukung stream (Drift/watch) atau hanya asumsi? | Ya, AI memberikan penjelasan valid mengapa Drift didapuk reaktif ketimbang sqflite biasa. |
| 4 | Apakah estimasi boilerplate AI masuk akal setelah instalasi? | Terverifikasi, AI jujur memperingatkan waktu _build_ runner memakan performa berlebih pada arsitektur Drift. |

### Keputusan Final
Arsitektur perpaduan **SharedPreferences** dan **sqflite** adalah opsi yang paling wajar. Prefs untuk data profil konfigurasi kecil, sedangkan SQL biasa dipakai untuk menyimpan relasi tabel dengan sistem sinkronisasi asinkron (_Last-Write-Wins_) tanpa harus direpotkan oleh *build runner / code generation* ala _Drift_.

---

## Referensi
- [Slide Week 5: Local Storage & Offline First](https://jti-polinema.github.io/flutter-codelab/00-slides/Week_05_Local_Storage_Offline_First.html)
- [Flutter cookbook: Store key-value data](https://docs.flutter.dev/cookbook/persistence/key-value)
- [shared_preferences package](https://pub.dev/packages/shared_preferences)
- [sqflite package](https://pub.dev/packages/sqflite)
- [Hive package (alternatif NoSQL)](https://pub.dev/packages/hive)
- [Drift package (alternatif reaktif)](https://pub.dev/packages/drift)
- [Riverpod: AsyncNotifier dan AsyncValue](https://riverpod.dev/docs/concepts/async_notifiers)
- [Learn Dart in Y Minutes](https://learnxinyminutes.com/dart/)
