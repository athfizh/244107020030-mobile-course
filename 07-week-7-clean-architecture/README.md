# Minggu 7 Clean Architecture

**Nama:** Athfizh  
**NIM:** 244107020030  

---

## Tujuan

Praktikum ini bertujuan memahami dan menerapkan prinsip *Clean Architecture* pada proyek Flutter yang sudah berjalan (refactor dari Week 6). Fokus utama mencakup pemisahan tiga lapisan utama (presentation, domain, data), penerapan prinsip SOLID dalam rancangan kelas, pembuatan *use case* sebagai unit operasi bisnis tunggal, dan pengujian logika domain secara terisolasi menggunakan *Fake Repository* tanpa menyentuh jaringan atau database sungguhan.

## Fitur Utama

| Fitur | Keterangan |
|---|---|
| Feature-First Structure | Kode dikelompokkan per fitur (`auth`, `announcement`) lalu dibagi per layer (`domain`, `data`, `presentation`) |
| Domain Layer Murni | Entity dan Use Case sepenuhnya bebas dari Dio/Flutter/SQLite sehingga dapat diuji tanpa emulator |
| Repository Interface | Kontrak domain (`abstract class`) dipisah dari implementasinya sehingga mudah diganti dan di-mock |
| Dependency Injection via Riverpod | Widget tidak pernah memanggil `Repository()` langsung — semua disuntik melalui `Provider` |
| Unit Test Terisolasi | 9 unit test domain dijalankan menggunakan `FakeRepository` tanpa Firebase/Dio sungguhan |

---

## Tahapan Praktikum

### Praktikum 1: Audit Layer Project Lama + Rancang Struktur Target

**Tabel Audit File (berdasarkan project Week 6 - campus_notify):**

| File | Layer Saat Ini | Masalah Arsitektur |
|---|---|---|
| `pages/home_page.dart` | presentation | Memanggil `push_service.dart` langsung dari Widget (DI bocor) |
| `data/auth_repository.dart` | data | Interface dan implementasi tercampur dalam satu kelas |
| `providers/auth_provider.dart` | presentation (state) | OK, hanya memanggil repository — namun provider `authRepositoryProvider` dibuat di file ini sehingga melanggar pemisahan |
| `data/api_client.dart` | data | OK, hanya dipakai oleh repository |
| `data/api_errors.dart` | data | Sebaiknya di domain (`Failure` class) agar presentation tidak import data |
| `routes.dart` | shared | OK, terpusat |

**Tiga Pelanggaran Klasik yang Ditemukan:**
1. **DI Bocor:** `HomePage` langsung memanggil `requestNotificationPermission()` dan `initFcmToken()` tanpa melewati use case atau provider — widget menjadi `PushService` itu sendiri.
2. **Interface + Impl Tercampur:** `AuthRepository` di Week 6 adalah kelas konkret (bukan `abstract class`), sehingga tidak bisa di-*mock* untuk testing.
3. **Error Mapping di Data Layer:** `api_errors.dart` berada di `data/`, tetapi di-import langsung oleh `pages/login_page.dart` (presentation) — melanggar aturan ketergantungan (presentation tidak boleh import data).

**Struktur Target (Feature-First Clean Architecture):**
<img src="screenshots/Praktikum 1 - Struktur Folder.png" width="350" alt="Struktur folder Clean Architecture">
<img src="screenshots/Praktikum 1 - Audit Layer.png" width="500" alt="Audit layer Week 6">

### Refactoring ke Clean Architecture (Praktikum 2-3)
<img src="screenshots/Praktikum 1 - Hasil Flutter Analyze.png" width="600" alt="Flutter Analyze - No issues found">
<br><img src="screenshots/Praktikum 1 - Hasil Flutter Test.png" width="600" alt="Flutter Test - All tests passed">

> **Keterangan gambar**
> - Hasil `flutter analyze` menunjukkan **No issues found!** — seluruh kode bersih dari pelanggaran linter.
> - Hasil `flutter test` menunjukkan **9/9 All tests passed!** — semua use case domain tervalidasi menggunakan FakeRepository tanpa menyentuh jaringan nyata.

---

## AI Prompt Challenge

Seluruh proses eksplorasi prompt AI untuk mengusulkan reorganisasi struktur proyek, evaluasi trade-off arsitektur, keputusan akhir yang diambil secara mandiri, dan justifikasi teknisnya telah didokumentasikan secara terpisah.

👉 [**Lihat Pembahasan Lengkap AI Challenge (AI_Challenge.md)**](docs/AI_Challenge.md)

---

## Refleksi

**1. Apa yang terjadi bila widget memanggil Dio langsung? Prinsip SOLID mana yang dilanggar?**

Bila widget memanggil Dio langsung (tanpa melewati repository), widget tersebut memiliki dua alasan berubah sekaligus: perubahan tampilan UI *dan* perubahan cara pengambilan data. Ini melanggar **Single Responsibility Principle (SRP)**. Selain itu, melanggar **Dependency Inversion Principle (DIP)** karena widget (high-level) bergantung langsung pada Dio (low-level concrete), bukan pada abstraksi (repository interface).

**2. Mengapa entity tidak boleh punya method toJson/fromJson?**

Entity adalah representasi konsep bisnis yang murni — ia harus bisa hidup dan diuji tanpa tahu bagaimana data disimpan atau dikirim. Jika `toJson` disematkan di entity, entity menjadi sadar tentang format penyimpanan (JSON/SQLite), sehingga domain layer menjadi bergantung pada detail implementasi data layer. Tugas konversi ini sepenuhnya milik `Model` di data layer.

**3. Apa trade-off feature-first vs layer-first? Kapan layer-first justru lebih baik?**

*Feature-first* memudahkan tim bekerja paralel per fitur dan memudahkan penghapusan fitur tanpa menyentuh fitur lain. Namun untuk proyek dengan **satu fitur kecil atau tim solo pemula**, struktur ini terasa *over-engineering*. *Layer-first* (`lib/data`, `lib/domain`, `lib/presentation` secara global) lebih sederhana dan cepat dipahami untuk skala kecil — tetapi akan berantakan saat fitur bertambah.

**4. Bagian mana dari saran AI yang Anda tolak atau modifikasi, dan mengapa?**

AI mengusulkan penggunaan `Either<Failure, T>` (dari package `dartz`) untuk semua return value use case. Saya menolak saran ini karena: (1) menambah dependensi eksternal yang tidak perlu untuk skala proyek ini, (2) memperkenalkan konsep functional programming yang menambah kurva belajar, dan (3) penggunaan `throw Exception` + `AsyncValue.guard` dari Riverpod sudah cukup untuk menangani error secara ergonomis tanpa boilerplate tambahan.

---

## Referensi Pendukung
- [Slide Week 7: Clean Architecture](https://jti-polinema.github.io/flutter-codelab/07-minggu-7-clean-architecture/index.html)
- [The Clean Architecture - Robert C. Martin](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)
- [SOLID Principles in Dart/Flutter](https://dart.dev/effective-dart/design)
- [Riverpod: Dependency Injection](https://riverpod.dev/)
- [GoRouter: redirect & deep linking](https://pub.dev/packages/go_router)
- [flutter_secure_storage package](https://pub.dev/packages/flutter_secure_storage)
- [dio package](https://pub.dev/packages/dio)
- [Learn Dart in Y Minutes](https://learnxinyminutes.com/dart/)
