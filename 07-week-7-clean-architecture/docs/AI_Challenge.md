# AI Challenge - Clean Architecture (Week 7)

## 1. Prompt yang Digunakan
```text
Project Flutter saya: campus_notify (auth + FCM + daftar pengumuman).
Kondisi kini: folder lib/{data, providers, pages, messaging},
repository tercampur dengan implementasi, widget memanggil Dio langsung.

Tugas:
1. Usulkan struktur feature-first Clean Architecture (presentation/domain/data) untuk fitur auth + announcements.
2. Untuk tiap file lama, sebutkan tujuan barunya (pindah/pecah/hapus).
3. Tandai bagian yang over-engineering bila diterapkan ke CRUD sederhana, dan kapan use case benar-benar dibutuhkan vs repository langsung.
4. Tunjukkan wiring DI dengan Riverpod (tanpa package DI tambahan).
Jelaskan trade-off setiap keputusan.
```

## 2. Output Awal AI (Draft Arsitektur)

AI memberikan draf struktur *feature-first* secara lengkap:
- Pemisahan `AuthRepository` (interface di Domain) dan `AuthRepositoryImpl` (implementasi di Data).
- Pembuatan kelas *Entity* tanpa ada referensi `toJson/fromJson`.
- Pembuatan *Use Case* terpisah seperti `GetAnnouncements` dan `LoginUseCase`.
- Wiring menggunakan `Provider` dan `FutureProvider` dari Riverpod.

Namun, AI juga mengusulkan hal yang berpotensi *over-engineering* untuk skala proyek ini:
- Menggunakan *package* `dartz` untuk mengembalikan tipe `Either<Failure, T>`.
- Mengusulkan pembuatan *Use Case* bahkan untuk operasi CRUD sederhana satu-baris (misalnya `addNote` langsung di-pass melalui *Use Case* kosongan).

## 3. Tabel Pemetaan File Lama vs Baru (Usulan AI & Keputusan)

| File Lama (Week 6) | Tujuan Baru / Keputusan Arsitektur | Keterangan |
|---|---|---|
| `data/auth_repository.dart` | **Dipecah** menjadi dua: `domain/repositories/auth_repository.dart` (Interface) dan `data/repositories/auth_repository_impl.dart` (Implementasi). | Penting agar bisa di-*mock* saat *testing*. |
| `pages/home_page.dart` | **Dipindah** ke `features/announcement/presentation/pages/home_page.dart`. | Semua UI dimasukkan ke layer *Presentation*. |
| `providers/auth_provider.dart` | **Dipecah & Dipindah**. State notif pindah ke `presentation/providers/`. Inisialisasi Storage dipindah ke `core/providers.dart`. | Mencegah kebocoran layer data ke presentasi. |
| `data/api_client.dart` | **Dihapus/Digabung**. Instansiasi `Dio` kini dipusatkan di `lib/features/announcement/data/dio_client.dart` | Lebih rapi disuntik via *Dependency Injection*. |
| `data/api_errors.dart` | **Diubah** menjadi `lib/core/failures.dart` (*Sealed Class*). | Error naik kasta menjadi *Domain Knowledge* agar dikenali seluruh layer tanpa import paket eksternal. |

## 4. Evaluasi Over-Engineering & Penggunaan Use Case

**Kapan Use Case itu *Over-engineering*?**
Berdasarkan tinjauan, membuat *Use Case* untuk operasi *CRUD satu baris* (seperti `repo.getNotes()`) yang tidak memiliki logika validasi tambahan adalah sebuah **Over-engineering**. 
Namun, untuk kepatuhan praktikum dan pembelajaran pemisahan tanggung jawab, *Use Case* ini tetap dibuat. Di industri nyata, untuk CRUD tanpa bisnis logika kompleks, *Presentation layer (Notifier)* diperbolehkan memanggil *Repository* secara langsung (Pola *Repository Pattern* murni, mem-bypass *Use Case*).

**Kapan Use Case Wajib Digunakan?**
*Use Case* wajib saat operasi melibatkan:
- Pemanggilan ke lebih dari 1 repository (misal: simpan ke SQLite lokal, lalu sinkronisasi ke server REST).
- Logika bisnis berat (validasi umur, pengurutan, kalkulasi total diskon).

## 5. AI Verification Checklist & Hasil Grep

| Kriteria Verifikasi | Status | Catatan Teknis |
|---|---|---|
| Interface repo di *domain*, impl di *data*? | ✅ Lulus | Keduanya sukses dipisah dalam folder berbeda. |
| Domain bebas dari Flutter/Dio/SQLite? | ✅ Lulus | Diverifikasi via *Grep*. Domain hanya berisi murni Dart. |
| AI membuat *Use Case* untuk tiap CRUD? | ⚠️ Over-eng | AI awalnya memaksa, namun ditoleransi untuk keperluan pendidikan Praktikum. |
| Entity bebas dari *mapping*? | ✅ Lulus | `toJson/fromJson` hanya hidup di layer Data (`Model`). |
| Wiring DI terpusat di Provider? | ✅ Lulus | Widget (UI) terbebas dari pemanggilan `new AuthRepository()`. |

**Bukti Tiga Grep (Verifikasi Sterilisasi)**

1. **Presentation bebas data mentah:**
```powershell
PS> Select-String -Path "lib\features\*\presentation\*\*.dart" -Pattern "Dio\(|openDatabase|getDatabasesPath|FlutterSecureStorage|SharedPreferences\.getInstance|jsonDecode"

(Nol Hasil / Kosong) -> Sukses.
```

2. **Domain bebas framework/package:**
```powershell
PS> Select-String -Path "lib\features\*\domain\*\*.dart", "lib\core\*.dart" -Pattern "import 'package:flutter|import 'package:dio|import 'package:sqflite|import 'package:firebase"

(Nol Hasil / Kosong) -> Sukses.
```

3. **Linter & Test Bersih:**
```powershell
PS> flutter analyze
No issues found! (ran in 2.3s)

PS> flutter test
00:00 +9: All tests passed!
```

## 6. Keputusan Final
Struktur *Feature-First* dengan pemisahan 3 layer diadopsi sepenuhnya. Penggunaan tipe pengembalian *Dart Records 3.0* (`({Data? data, Failure? failure})`) dipilih sebagai pengganti package eksternal `dartz` (saran AI) karena lebih modern, bawaan bahasa (native), dan sangat ergonomis tanpa perlu pusing dengan hirarki monad (Right/Left).
