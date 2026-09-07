# Minggu 2 – Declarative UI & Responsive Design

## Tujuan
Memahami prinsip dasar Declarative UI pada Flutter, membangun komponen layout dasar (Row, Column, Container, Expanded, Spacer), serta membuat aplikasi Student Dashboard dan Academic Overview yang responsif menggunakan LayoutBuilder, GridView, dan CupertinoSwitch.

---

## Fitur Utama
| Fitur | Keterangan |
|---|---|
| **Profil Mahasiswa** | Kartu profil (`ProfileCard`) berisi avatar, nama, NIM, kelas, dan email (`profile_card.dart`) |
| **Student Dashboard** | Grid kartu informasi mahasiswa (`main.dart`) |
| **Academic Overview** | Halaman akademik lengkap dengan header profil dan 4 kartu indikator (`academic_overview.dart`) |
| **Responsive Layout** | `LayoutBuilder` dengan breakpoint 700px (1 kolom pada HP, 2 kolom pada layar lebar) |
| **Dark Mode Toggle** | `CupertinoSwitch` pada AppBar untuk mengganti tema terang dan gelap |
| **Aksesibilitas** | Widget `Semantics` pada switch dan kartu dashboard untuk dukungan screen reader |

---

## Stack Teknologi
- **Bahasa:** Dart 3.13.2 (null safety penuh)
- **Framework:** Flutter SDK 3.47.2 (stable channel)
- **Tools:** Android Studio Meerkat, Git, Flutter CLI
- **Testing:** `flutter_test` (widget tests)

---

## Cara Menjalankan
```bash
# 1. Masuk ke folder project
cd 02-week-2-declarative-ui-responsive-design

# 2. Install dependencies
flutter pub get

# 3. Jalankan aplikasi Academic Overview (Tugas Utama)
flutter run lib/academic_overview.dart

# 4. Jalankan test responsif
flutter test test/academic_overview_test.dart
```

---

## Hasil yang Dicapai
- Kartu profil sederhana berhasil dibangun menggunakan `Row`, `Column`, `Container`, dan `Expanded`
- Dashboard responsif berhasil diimplementasikan dengan `LayoutBuilder` dan `GridView.count`
- Halaman Academic Overview berhasil dibangun dengan komponen reusable `InfoCard` dan tema dinamis
- Pengaturan tema terang/gelap berhasil diintegrasikan menggunakan `StatefulWidget` dan `CupertinoSwitch`
- Widget `Semantics` berhasil diterapkan pada elemen interaktif untuk aksesibilitas
- Seluruh widget test responsif berhasil diverifikasi dan lulus (`flutter test`)

---

## Screenshot & Bukti Visual

### Student Dashboard (Mode Terang & Gelap)
<img src="screenshots/Praktikum Dashboard Responsif Light Theme.png" width="250" alt="Student Dashboard Light Theme"> <img src="screenshots/Praktikum Dashboard Responsif Dark Theme.png" width="250" alt="Student Dashboard Dark Theme">

> **Keterangan gambar:**
> - **AppBar** "Student Dashboard" dengan ikon mode dan `CupertinoSwitch`
> - **Grid Cards** 4 kartu (Assignments, Attendance, Portfolio, Current week)
> - **Toggle Dark Mode** peralihan tema terang dan gelap secara instan

### Kartu Profil Mahasiswa (Warm-up)
<img src="screenshots/Hasil Praktikum layout sederhana (warm-up).png" width="250" alt="Hasil Praktikum layout sederhana - Kartu Profil">

> **Keterangan gambar:**
> - **Avatar** ikon person -> widget `CircleAvatar` + `Icon`
> - **Nama Mahasiswa** -> widget `Text` dengan styling bold
> - **NIM, Kelas, Email** -> widget `Row` + `Spacer` / `Expanded`

---

## AI Prompt Challenge & Exploration

### 1. Desain Layout: GridView vs LayoutBuilder + Column
- **Prompt:** "Bandingkan dua tata letak dashboard akademik untuk Flutter: versi GridView dan versi LayoutBuilder + Column. Jelaskan trade-off responsif dan aksesibilitasnya."
- **Analisis & Keputusan:** 
  `GridView` efisien untuk grid item seragam berulang. Namun, `LayoutBuilder + Column/Row` (yang diterapkan di `academic_overview.dart`) memberikan kontrol spasi dan tinggi kartu secara penuh. Secara aksesibilitas, urutan pembacaan *screen reader* pada `Row` dan `Column` teratur dengan jelas dari atas ke bawah.

### 2. Penguatan Konsep: Jebakan Widget Expanded
- **Prompt:** "Jelaskan kapan penggunaan Expanded justru menyebabkan overflow di dalam Row, beri contoh kode yang gagal dan perbaikannya."
- **Analisis & Keputusan:** 
  `Expanded` gagal ketika ditaruh di dalam `Row` yang berada di dalam widget *scrollable* arah horizontal (seperti `SingleChildScrollView` horizontal). Flutter akan memicu error `RenderFlex children have non-zero flex but incoming width constraints are unbounded` karena `Expanded` mencoba mengambil lebar tak terhingga. Perbaikannya adalah mengganti `Expanded` dengan widget yang memiliki batas lebar pasti atau membuang scroll horizontal.

### 3. Verification Audit
- **Prompt:** "Periksa kembali rekomendasi layout di atas: apakah tetap responsif di bawah 600px, apakah mengurangi aksesibilitas, dan apakah ada widget yang tidak tersedia di Flutter stabil saat ini?"
- **Analisis & Keputusan:**
  - **Responsif < 600px:** Lulus. Breakpoint diset pada `700px` (`kWideBreakpoint`), sehingga layar HP biasa (360px-600px) otomatis tampil 1 kolom.
  - **Aksesibilitas:** Lulus. Ditambahkan widget `Semantics` pada switch dan kartu informasi.
  - **Kestabilan Widget:** Lulus. Seluruh widget yang digunakan (`LayoutBuilder`, `Card`, `CupertinoSwitch`) 100% stabil pada SDK Flutter saat ini.

---

## Kendala Setup & Solusi

### Kendala: Teks "Email" terpotong/tertekuk menjadi dua baris ("Ema il")
Saat menambahkan baris email pada kartu profil dengan pola `Expanded(child: Text('Email'))`, kata "Email" terpotong menjadi two baris secara vertikal.

**Penyebab:** Teks nilai email yang panjang memakan sebagian besar lebar terbatas dari `Container` (320px), sehingga sisa lebar yang diberikan `Expanded` kepada label "Email" terlalu kecil.

**Solusi:** Memindahkan `Expanded` ke teks nilai email dan menyesuaikan `fontSize`, atau menggunakan `Spacer()` sehingga label memiliki lebar alami dan teks email sejajar di sebelah kanan.

---

## Refleksi dan referensi

### Refleksi

- **Apa perbedaan cara berpikir imperative dan declarative saat membangun UI?**
  Pendekatan imperative mengharuskan developer mengubah UI secara manual langkah demi langkah setiap kali state/data berubah (misal: `textView.setText("Baru")`). Sedangkan pendekatan declarative pada Flutter bersifat reaktif; developer mendeskripsikan *blueprint* UI untuk setiap kemungkinan state (`UI = f(state)`). Ketika state berubah, Flutter secara otomatis merender ulang (rebuild) bagian widget tree yang terdampak tanpa perlu intervensi manual.

- **Kapan `Expanded` membantu dan kapan penggunaannya justru menghasilkan layout error?**
  `Expanded` sangat membantu saat kita ingin membagi sisa ruang kosong secara proporsional dalam `Row` atau `Column`. Namun, `Expanded` akan menyebabkan *layout error* (overflow atau constraint tidak terbatas) jika ditempatkan di dalam widget scroll (seperti `SingleChildScrollView` horizontal untuk `Row` atau vertikal untuk `Column`) atau di dalam parent yang tidak memberikan batasan ukuran secara tegas.

- **Bagaimana breakpoint dan theme memengaruhi pengalaman pengguna?**
  Breakpoint memastikan bahwa layout aplikasi beradaptasi dengan ukuran layar perangkat (misal: ponsel vs tablet/desktop), sehingga mencegah UI terlihat terlalu kosong di layar besar atau terhimpit di layar kecil. Theme (khususnya *dark mode*) memengaruhi kenyamanan visual pengguna saat berinteraksi di kondisi pencahayaan rendah, mengurangi kelelahan mata, dan meningkatkan aksesibilitas kontras teks.

- **Apa yang Anda verifikasi dari rekomendasi AI setelah tugas inti selesai?**
  Saya memverifikasi tiga hal utama dari saran AI:
  1. **Tingkat Responsivitas**: Memastikan aplikasi benar-benar berpindah ke tata letak 1 kolom pada layar di bawah 700px dan 2 kolom saat di atasnya.
  2. **Dampak Aksesibilitas**: Mengecek penggunaan widget `Semantics` apakah memberi kejelasan pembacaan pada *screen reader* tanpa merusak tata letak yang ada.
  3. **Ketersediaan Widget**: Mengonfirmasi bahwa komponen pendukung seperti `CupertinoSwitch` dan `LayoutBuilder` beroperasi stabil tanpa masalah versi pada SDK terbaru.

### Referensi

- [Flutter UI documentation](https://docs.flutter.dev/ui)
- [Building responsive apps](https://docs.flutter.dev/ui/adaptive-responsive)
- [Material Design 3](https://m3.material.io/)
- [Flutter accessibility](https://docs.flutter.dev/ui/accessibility)
