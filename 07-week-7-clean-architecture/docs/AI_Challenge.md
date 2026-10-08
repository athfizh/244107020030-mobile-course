# AI Challenge - Clean Architecture (Week 7)

## 1. Prompt yang Digunakan
```text
Aplikasi Flutter Campus Notify (refactor dari Week 6).
Stack yang sudah ada: firebase_messaging, flutter_secure_storage,
go_router, Riverpod, Dio.

Usulkan reorganisasi project menjadi feature-first Clean Architecture dengan:
- Tiga layer: domain, data, presentation per fitur
- Aturan dependensi: domain tidak bergantung pada Dio/Flutter/SQLite
- Entity vs Model: entity murni Dart (tanpa toJson), model di data layer
- Repository interface di domain, implementasi di data
- Use case: satu kelas = satu operasi bisnis
- DI via Riverpod Provider (widget tidak new Repository() sendiri)
- Unit test use case dengan FakeRepository (tanpa Firebase/Dio nyata)

Tandai bagian yang berpotensi OVER-ENGINEERING untuk skala proyek ini,
dan berikan justifikasi trade-off untuk setiap keputusan arsitektur.
```

## 2. Output Awal AI (Draft Arsitektur)

AI memberikan usulan struktur folder yang lengkap dengan fitur `auth` dan `announcement`.
Draf awal mencakup penggunaan package `dartz` untuk tipe `Either<Failure, T>` pada
semua return value use case, serta saran `abstract class UseCase<T, Params>` sebagai
base class generik untuk semua use case.

## 3. Perbaikan Manual & Keputusan Arsitektur

### A. Menolak Either<Failure, T> dari dartz
AI mengusulkan pola Functional Programming murni:
```dart
// Saran AI (DITOLAK)
abstract class UseCase<T, P> {
  Future<Either<Failure, T>> call(P params);
}
```
**Alasan penolakan:** Menambah dependensi `dartz` yang tidak perlu, memperkenalkan
konsep monad yang menambah kurva belajar tanpa manfaat nyata di skala proyek ini.
`AsyncValue.guard` dari Riverpod sudah menangani error secara ergonomis.

### B. Menolak base class UseCase generik
AI menyarankan satu `abstract class UseCase<T, P>` untuk semua use case.
**Alasan penolakan:** Untuk 3 use case kecil (login, logout, getSession),
generik ini adalah *over-engineering*. Lebih mudah dibaca tanpa base class.

### C. Menerima: Pemisahan AuthRepository menjadi interface + impl
AI benar bahwa Week 6 mencampur interface dan implementasi dalam satu kelas.
Saran ini **diterima penuh** — ini pelanggaran nyata yang membuat unit testing mustahil.

### D. Menerima: Model sebagai adapter antara JSON dan Entity
AI benar bahwa entity tidak boleh punya `toJson`/`fromJson`.
`SessionModel.fromJson().toEntity()` adalah pola yang bersih dan diterima.

## 4. AI Verification Checklist

| Kriteria | Hasil |
|---|---|
| Apakah domain layer bebas dari import Dio/Flutter/SQLite? | **Lulus.** `lib/features/*/domain/` tidak ada satu pun import eksternal selain Dart murni. |
| Apakah entity tidak punya toJson/fromJson? | **Lulus.** Session, User, Announcement — ketiganya murni Dart tanpa mapping. |
| Apakah repository interface ada di domain? | **Lulus.** `auth_repository.dart` dan `announcement_repository.dart` adalah `abstract class` di domain. |
| Apakah use case hanya satu operasi per kelas? | **Lulus.** LoginUseCase, LogoutUseCase, GetSessionUseCase, GetAnnouncements, GetAnnouncementById — masing-masing satu kelas. |
| Apakah widget melakukan DI sendiri (new Repository)? | **Lulus.** Semua dependensi disuntik via Provider Riverpod. |
| Apakah unit test berjalan tanpa Firebase/Dio nyata? | **Lulus.** 9/9 test lulus menggunakan FakeAuthRepository dan FakeAnnouncementRepository. |

## 5. Keputusan Final & Justifikasi Teknis

**Arsitektur yang dipilih:** Feature-first dengan tiga layer (domain, data, presentation)
tanpa `dartz`, tanpa base class generik, menggunakan `throw Exception` + `AsyncValue.guard`.

**Justifikasi:**
1. **Kesederhanaan:** Tidak menambah dependensi eksternal untuk masalah yang bisa diselesaikan dengan alat bawaan Riverpod.
2. **Keterbacaan:** Setiap file bisa dibaca dan dipahami tanpa perlu mengerti konsep monad atau Either.
3. **Testabilitas:** FakeRepository sebagai implementasi `abstract class` sudah cukup untuk memisahkan unit test dari infrastruktur nyata.
4. **Skalabilitas:** Jika proyek berkembang dan tim membutuhkan `Either`, migrasi dapat dilakukan per fitur — tidak perlu refactor masif.
