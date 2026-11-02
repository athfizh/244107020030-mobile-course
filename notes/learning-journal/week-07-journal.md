# Learning Journal - Semester Mobile Development

**Athaulla Hafizh | NIM: 244107020030**

---

## Minggu 7 - Clean Architecture

**Tanggal:** 8 Oktober 2026

### Yang Dipelajari
Pada minggu ini, saya mempelajari Secara detail tentang **Clean Architecture** (Feature-First) pada Flutter. Konsep utamanya adalah memisahkan kode ke dalam tiga layer: `Presentation`, `Domain`, dan `Data`. Aturan emas (*Dependency Rule*) menetapkan bahwa dependensi hanya boleh mengarah ke dalam (ke arah Domain). Domain layer murni berisi logika bisnis dan kontrak (Interface), tanpa campur tangan kode framework Flutter, SQLite, atau Dio.

### Yang Dikerjakan
Saya berhasil menerapkan pemisahan layer ini pada fitur `Auth`, `Announcements`, dan `Notes`. 
1. **Layer Data:** Berisi Model (mapping JSON/Map) dan implementasi Repository (berhubungan langsung dengan API/SQLite).
2. **Layer Domain:** Berisi Entity (tipe data murni), Interface Repository, Use Cases, dan tipe *Failure* (Sealed Class) sebagai standardisasi error.
3. **Layer Presentation:** Berisi UI (Widget), Provider (Dependency Injection menggunakan Riverpod), dan Notifier.

Saya juga melakukan migrasi dari penggunaan package `dartz` menjadi fitur *Records* bawaan Dart 3.0 untuk *Return* berganda sukses/gagal, yang terbukti jauh lebih efisien dan terhindar dari *over-engineering*.

Hasil *Grep* terbukti steril di mana tidak ada impor infrastruktur yang bocor ke Domain atau Presentation. Pengujian *Mock* menggunakan `FakeRepository` terbukti 100% independen tanpa database riil. Seluruh kode termodularisasi dengan rapi.

### Kendala & Solusi
- **Masalah:** Sebagian widget lama masih mengimpor `Dio` dan `sqflite` secara langsung sehingga *Domain Layer* tercemar.
- **Solusi:** Memindahkan seluruh instansiasi infrastruktur ke *Data Layer*, lalu menghubungkannya lewat *Dependency Injection* Riverpod.
- **Masalah:** Draf awal AI menyarankan *package* `dartz` dengan tipe `Either<Failure, T>`.
- **Solusi:** Menolaknya dan memakai *Records* bawaan Dart 3 (`({T? data, Failure? failure})`) agar tidak menambah dependensi pihak ketiga.

### Key Takeaway
> Batas antar lapisan bukan sekadar kerapian folder, melainkan aturan yang menentukan arah dependensi. Selama *Domain* tetap murni, logika bisnis bisa diuji dan dipindahkan tanpa menyentuh UI, database, atau jaringan.
