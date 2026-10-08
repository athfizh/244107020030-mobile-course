# 07-week-7-clean-architecture
Tugas Minggu ke-7 Praktikum Mobile Development.

**Nama:** Athfizh  
**NIM:** 244107020030  

---

## Tujuan Pembelajaran
Praktikum ini bertujuan menguasai reorganisasi proyek yang sudah berjalan menuju **Clean Architecture**. Fokus utama mencakup pemisahan kode ke dalam 3 lapisan (Presentation, Domain, Data) dengan pola *Feature-First*, serta memastikan arah ketergantungan (Dependency Rule) selalu mengarah ke dalam agar logika bisnis murni (*Domain*) tidak bergantung pada Flutter, antarmuka jaringan (Dio), atau penyimpanan lokal. 

---

## Tahapan Praktikum

### Praktikum 1: Audit Layer Project Lama & Rancangan Target

Dalam praktikum awal ini, dilakukan bedah arsitektur pada *source code* Week 6 (Campus Notify) untuk mencari pelanggaran *separation of concerns*.

**Tabel Hasil Audit Arsitektur Lama:**

| Nama File | Layer Saat Ini | Status & Masalah |
|:---|:---:|:---|
| `pages/home_page.dart` | Presentation | ❌ **DI Bocor**: Memanggil servis `PushService` langsung dari level antarmuka. |
| `data/auth_repository.dart` | Data | ❌ **Antarmuka Tercampur**: Konsep *interface* & implementasi menyatu dalam kelas konkret. |
| `data/api_errors.dart` | Data | ❌ **Error Silang Layer**: `pages/login_page.dart` (Presentation) mengimpor file ini langsung. |
| `providers/auth_provider.dart`| Presentation | ⚠️ **Setup Terselubung**: Menyimpan inisiasi dependensi langsung di dalam penyedia state. |
| `data/api_client.dart` | Data | ✅ Aman, murni dikonsumsi oleh lapisan repositori jaringan. |
| `routes.dart` | Shared | ✅ Aman sebagai rute konstan pusat. |

<br/>

<div align="center">
  <h4>Struktur Baru (Feature-First) & Pemisahan Interface Repository</h4>
  <img src="screenshots/Praktikum 1 - Struktur Folder.png" height="350" alt="Struktur Folder Clean Architecture">
  &nbsp;&nbsp;&nbsp;
  <img src="screenshots/Praktikum 1 - Audit Layer.png" height="350" alt="Pemisahan Repository Interface">
  <p><em>(Kiri) Kode dirapikan per-fitur dan per-layer. (Kanan) AuthRepository kini menjadi abstract class.</em></p>
</div>

---

### Praktikum 2-3: Eksekusi Refactoring & Validasi Pengujian

Memindahkan implementasi model JSON, instansiasi Dio/SQLite, dan penyimpanan lokal *Secure Storage* mutlak ke dalam `Data Layer`, dan menyisakan entitas murni Dart di `Domain Layer`.

<div align="center">
  <h4>Verifikasi Linting dan Unit Test</h4>
  <img src="screenshots/Praktikum 1 - Hasil Flutter Analyze.png" width="800" alt="Hasil Flutter Analyze">
  <br><br>
  <img src="screenshots/Praktikum 1 - Hasil Flutter Test.png" width="800" alt="Hasil Flutter Test">
  <p><em>Sistem dinyatakan bersih tanpa cacat linter, dan sukses memvalidasi operasi bisnis dengan Mock Repository.</em></p>
</div>

---

## Evaluasi & Keputusan AI Challenge

Eksplorasi penggunaan saran *Artificial Intelligence* untuk reorganisasi proyek ini, beserta dokumentasi *trade-off* teknis, dan alasan arsitektur akhir yang dipilih secara sadar terangkum di bawah ini:

👉 **[Baca Dokumentasi Lengkap AI Challenge](docs/AI_Challenge.md)**

---

## 📝 Refleksi

**1. Apa yang terjadi bila widget memanggil Dio langsung? Prinsip SOLID mana yang dilanggar?**
Memanggil kerangka HTTP (`Dio`) secara langsung di level antarmuka pengguna (Widget) adalah pelanggaran **Single Responsibility Principle (SRP)**. Widget menjadi punya dua fokus: mengurus tampilan layar dan mengurus cara berkomunikasi ke server. Selain itu, ini sangat melanggar **Dependency Inversion Principle (DIP)** di mana modul tingkat atas (UI) justru bergantung pada rincian teknis tingkat bawah (Dio), alih-alih pada abstraksi kontrak jembatan.

**2. Mengapa entity tidak boleh punya method toJson/fromJson?**
*Entity* merepresentasikan identitas objek bisnis paling inti yang tidak mempedulikan dari mana ia datang (baik dari SQLite lokal, internet JSON, maupun memori). Memasukkan `fromJson/toJson` memaksa *Entity* mengerti format pengiriman spesifik (seperti nama-nama *key JSON*), yang mana ini menjebol tembok batas isolasi domain layer. Urusan *parsing* adalah tugas telak milik `Model` di level *Data Layer*.

**3. Apa trade-off feature-first vs layer-first? Kapan layer-first justru lebih baik?**
Model **Feature-First** (mengelompokkan fitur seperti `/auth/domain/..` dan `/announcement/data/..`) luar biasa solid untuk aplikasi raksasa karena fitur A bisa dilepas-pasang tanpa merusak fitur B, sangat optimal untuk pengembangan tim paralel. Sebaliknya, **Layer-First** (`/domain`, `/data`, `/presentation` global) berisiko semrawut saat proyek meluas, namun justru pilihan paling brilian untuk membuat purwarupa (MVP) solo berskala mini dengan cepat tanpa *over-engineering*.

**4. Bagian mana dari saran AI yang Anda tolak atau modifikasi, dan mengapa?**
Saya merombak dan **menolak** rekomendasi mesin penjawab AI yang memaksakan pola *Functional Programming* (`Either<Failure, Type>` dari pustaka eksternal `dartz`). Untuk aplikasi berskala sedang seperti kampus ini, hal tersebut murni *over-engineering* yang tidak berdasar. Pendekatan bawaan `AsyncValue.guard()` dari *Riverpod* dikombinasikan dengan lontaran galat lazim (`throw Exception`) sudah luar biasa kokoh, ergonomis, dan minim sintaks usang dibandingkan harus menarik seluruh dependensi pustaka luar hanya demi mengakomodir monad.

---

## 📚 Referensi

> Seluruh rujukan materi, pedoman praktikum, serta referensi _codelab_ resmi untuk mata kuliah ini diakses terpusat melalui portal **JTI Polinema**.

<div align="center">
  <a href="https://jti-polinema.github.io/flutter-codelab/">
    <img src="https://img.shields.io/badge/Akses_Portal_Codelab-02569B?style=for-the-badge&logo=flutter&logoColor=white" alt="Portal Codelab JTI Polinema" />
  </a>
</div>
