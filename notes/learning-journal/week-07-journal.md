# Learning Journal - Semester Mobile Development

**Athaulla Hafizh | NIM: 244107020030**

---

## Minggu 7 — Clean Architecture

**Tanggal:** 8 Oktober 2026

### Pemahaman Konsep
Pada minggu ini, saya mempelajari secara mendalam tentang **Clean Architecture** (Feature-First) pada Flutter. Konsep utamanya adalah memisahkan kode ke dalam tiga layer: `Presentation`, `Domain`, dan `Data`. Aturan emas (*Dependency Rule*) menetapkan bahwa dependensi hanya boleh mengarah ke dalam (ke arah Domain). Domain layer murni berisi logika bisnis dan kontrak (Interface), tanpa campur tangan kode framework Flutter, SQLite, atau Dio.

### Implementasi
Saya berhasil menerapkan pemisahan layer ini pada fitur `Auth`, `Announcements`, dan `Notes`. 
1. **Layer Data:** Berisi Model (mapping JSON/Map) dan implementasi Repository (berhubungan langsung dengan API/SQLite).
2. **Layer Domain:** Berisi Entity (tipe data murni), Interface Repository, Use Cases, dan tipe *Failure* (Sealed Class) sebagai standardisasi error.
3. **Layer Presentation:** Berisi UI (Widget), Provider (Dependency Injection menggunakan Riverpod), dan Notifier.

Saya juga melakukan migrasi dari penggunaan package `dartz` menjadi fitur *Records* bawaan Dart 3.0 untuk *Return* berganda sukses/gagal, yang terbukti jauh lebih efisien dan terhindar dari *over-engineering*.

### Hasil
Hasil *Grep* terbukti steril di mana tidak ada impor infrastruktur yang bocor ke Domain atau Presentation. Pengujian *Mock* menggunakan `FakeRepository` terbukti 100% independen tanpa database riil. Seluruh kode termodularisasi dengan elegan.
