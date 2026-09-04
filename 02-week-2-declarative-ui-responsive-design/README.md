# Minggu 2 – Declarative UI & Responsive Design

## Tujuan
Memahami prinsip dasar Declarative UI pada Flutter, membangun komponen layout dasar (Row, Column, Container, Expanded, Spacer), serta membuat aplikasi Student Dashboard yang responsif menggunakan LayoutBuilder, GridView, dan CupertinoSwitch.

---

## Fitur Utama
| Fitur | Keterangan |
|---|---|
| **Profil Mahasiswa** | Kartu profil (`ProfileCard`) berisi avatar, nama, NIM, kelas, dan email (`profile_card.dart`) |
| **Student Dashboard** | Grid kartu informasi mahasiswa (`main.dart`) |
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

# 3. Jalankan di emulator / perangkat fisik
flutter run

# 4. Jalankan test
flutter test
```

---

## Hasil yang Dicapai
- Kartu profil sederhana berhasil dibangun menggunakan `Row`, `Column`, `Container`, dan `Expanded`
- Dashboard responsif berhasil diimplementasikan dengan `LayoutBuilder` dan `GridView.count`
- Pengaturan tema terang/gelap berhasil diintegrasikan menggunakan `StatefulWidget` dan `CupertinoSwitch`
- Widget `Semantics` berhasil diterapkan pada elemen interaktif untuk aksesibilitas
- Widget test berhasil diverifikasi dengan hasil sukses (`flutter test`)

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

## Kendala Setup & Solusi

### Kendala: Teks "Email" terpotong/tertekuk menjadi dua baris ("Ema il")
Saat menambahkan baris email pada kartu profil dengan pola `Expanded(child: Text('Email'))`, kata "Email" terpotong menjadi dua baris secara vertikal.

**Penyebab:** Teks nilai email yang panjang memakan sebagian besar lebar terbatas dari `Container` (320px), sehingga sisa lebar yang diberikan `Expanded` kepada label "Email" terlalu kecil.

**Solusi:** Memindahkan `Expanded` ke teks nilai email dan menyesuaikan `fontSize`, atau menggunakan `Spacer()` sehingga label memiliki lebar alami dan teks email sejajar di sebelah kanan.

---

## Refleksi

### 1. Apa perbedaan antara Imperative UI dan Declarative UI pada Flutter?

- **Imperative UI**: Developer secara manual mengubah status dan properti elemen UI satu per satu ketika terjadi perubahan data (contoh: `textView.setText("Hello")` di Android SDK lama).
- **Declarative UI**: Developer mendeskripsikan bentuk UI berdasarkan state saat itu (`UI = f(state)`). Ketika state berubah, Flutter membangun ulang widget tree dan menyesuaikan tampilan secara otomatis.

---

### 2. Bagaimana LayoutBuilder membantu membuat aplikasi yang responsif?

`LayoutBuilder` menyediakan parameter `BoxConstraints` yang memberikan informasi batas lebar dan tinggi maksimum yang tersedia dari widget induk (`constraints.maxWidth`). 

Dengan informasi ini, developer dapat menentukan logika kondisional (misalnya merubah jumlah kolom pada `GridView` dari 1 kolom menjadi 2 kolom jika lebar layar >= 700px).

---

### 3. Mengapa widget Semantics penting dalam pengembangan aplikasi mobile?

Widget `Semantics` berfungsi memberikan informasi kontekstual dan deskriptif kepada fitur aksesibilitas sistem operasi (seperti TalkBack pada Android atau VoiceOver pada iOS).

Hal ini memungkinkan pengguna dengan keterbatasan penglihatan dapat memahami fungsi dari setiap elemen interaktif (seperti tombol sakelar atau kartu informasi) melalui pembaca layar.
