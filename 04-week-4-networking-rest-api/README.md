# Minggu 4 Networking & REST API

## Tujuan
Praktikum ini bertujuan untuk memahami implementasi HTTP REST API di Flutter. Fokus utama mencakup pembuatan klien Dio terpusat lengkap dengan log interceptor serta konversi data JSON ke model Dart yang aman dari nilai null. Praktikum juga mencakup penerapan state management Riverpod untuk menangani fitur infinite scroll dan pengelolaan error handling. Selain itu tahapan ini juga membahas cara melakukan unit testing dengan memanfaatkan pola mock repository.

## Fitur Utama
| Fitur | Keterangan |
|---|---|
| Klien Dio Terpusat | Konfigurasi base URL dan batasan waktu tunggu dikelola dalam satu file klien agar tidak terjadi pengulangan kode di setiap fungsi panggilan API |
| Model JSON Null Safe | Konversi data JSON menggunakan metode fallback untuk mengantisipasi nilai null dari server sehingga aplikasi tidak berhenti tiba tiba |
| State Async Riverpod | Penggunaan AsyncNotifier untuk mengelola kondisi muat data dan menyimpan riwayat data sebelumnya saat terjadi gangguan jaringan |
| Paginasi Dasar | Implementasi infinite scroll yang otomatis memuat data tambahan saat layar digulir ke bawah lengkap dengan penanda indikator muat |
| Error Handling | Transformasi kode error teknis dari bawaan pustaka Dio menjadi pesan teks dalam bahasa Indonesia yang mudah dipahami |
| Uji Unit dan Mocking | Pengujian skenario kelas model dan provider menggunakan data repository tiruan untuk memastikan logika sistem berjalan sesuai alur |

## Stack Teknologi
1. Bahasa Dart 3.13.2
2. Framework Flutter SDK 3.47.2
3. Package dio 5.x, go_router 18.0.1, flutter_riverpod 3.4.3
4. Tools Android Studio, Git, Flutter CLI
5. Pengujian menggunakan flutter_test

## Cara Menjalankan
```bash
# Masuk ke folder project
cd 04-week-4-networking-rest-api

# Install dependencies
flutter pub get

# Jalankan aplikasi
flutter run
```

Keterangan navigasi dalam aplikasi
1. Layar utama langsung memuat daftar entri menggunakan mekanisme paginasi infinite scroll
2. Mematikan data internet saat aplikasi berjalan akan memunculkan layar perlindungan error koneksi lengkap dengan tombol muat ulang
3. Melakukan gulir layar hingga bagian paling dasar akan otomatis memuat 20 item selanjutnya tanpa memuat ulang isi halaman awal
4. Mengetuk salah satu entri pada linimasa akan membuka rute baru menuju halaman detail

## Hasil yang Dicapai
Aplikasi berhasil dibangun dengan pemisahan logika yang jelas antara antarmuka dan lapisan pengambil data. Kelas model mampu menangani data JSON yang tidak lengkap tanpa menyebabkan aplikasi crash. Mekanisme infinite scroll berjalan lancar dengan memuat blok data baru tanpa perlu menyegarkan seluruh layar. Pengelolaan error mampu merespons masalah koneksi internet dan kesalahan kode server dengan baik. Seluruh fungsi juga terbukti lulus uji unit dan pengecekan kode linter.

## Screenshot dan Bukti Visual

### Praktikum 1 & 2: Error Handling & Data Tunggal
<img src="screenshots/Praktikum%202%20-%20State%20Sukses%20(Daftar%20Post).png" width="250" alt="Daftar Data Sukses"> <img src="screenshots/Praktikum%202%20-%20State%20Error%20Koneksi%20(Mode%20Pesawat).png" width="250" alt="Error Koneksi"> <img src="screenshots/Praktikum%202%20-%20State%20Error%20Server%20(Salah%20URL%20404).png" width="250" alt="Error 404">

> **Keterangan gambar**
> - Daftar Data Sukses menampilkan data pos saat terhubung jaringan internet stabil
> - Error Koneksi menampilkan kondisi state perlindungan saat mode pesawat dinyalakan
> - Error 404 menampilkan respon aplikasi saat menguji format URL endpoint yang salah

### Praktikum 3: Paginasi (Infinite Scroll)
<img src="screenshots/Praktikum%203%20-%20State%20Infinite%20Scroll%20Paginasi%20(1).png" width="250" alt="Paginasi Loading 1"> <img src="screenshots/Praktikum%203%20-%20State%20Infinite%20Scroll%20Paginasi%20(2).png" width="250" alt="Paginasi Loading 2">

> **Keterangan gambar**
> - Infinite Scroll menunjukkan animasi putar kecil di bagian bawah layar saat mengambil memori halaman berikutnya

### Tahap 7: Refactoring, Detail, & Testing
<img src="screenshots/Refactor&Testing%20-%20UI%20GoRouter%20(Detail%20Page).png" width="250" alt="Halaman Detail GoRouter">
<br><img src="screenshots/AI%20Challenge%20-%20Lolos%20Analyze%20&%20Test.png" width="500" alt="Hasil Lulus flutter test">

> **Keterangan gambar**
> - Halaman Detail berpindah menggunakan rute path parameter dan memuat data detail pos
> - Pengujian perangkat lunak menunjukkan hasil sukses pada tahapan pengujian linter dan kode tes unit

## Refleksi

**1. Mengapa UI dilarang memanggil Dio langsung? Apa yang rusak jika aturan ini dilanggar?**

Antarmuka bertugas murni untuk menampilkan sisi visual aplikasi. Jika fungsi antarmuka melakukan pemanggilan API secara langsung maka arsitektur kode akan menyatu. Kode tersebut akan berimbas pada sulitnya proses pengujian dan perubahan format JSON dari server bisa memaksa developer merombak ulang banyak file tampilan. Kondisi ini juga berisiko tinggi memicu pemanggilan ganda setiap kali sistem membangun ulang layar antarmuka.

**2. Kapan pagination client-side cukup, dan kapan harus mengandalkan pagination server (_page/_limit)?**

Penerapan pagination sisi klien relevan digunakan untuk data statis tabel dengan jumlah entri yang masih tergolong sedikit. Namun untuk pengambilan data dinamis yang mencapai rentang ribuan baris ke atas maka pagination harus diletakkan pada sistem antrian server. Memaksakan pengolahan sisi klien untuk data skala masif akan menyebabkan beban yang signifikan pada memori perangkat pengguna dan boros konsumsi kuota data internet.

**3. Bagaimana exception repository berubah menjadi AsyncError tanpa try/catch di setiap widget? Kapan try/catch eksplisit tetap dibutuhkan?**

Paket Riverpod melalui kelas AsyncNotifier memiliki mekanisme proteksi error bawaan secara dasar. Segala bentuk kegagalan jaringan yang terjadi pada lapisan repository akan direkam secara otomatis sesaat setelah fungsi panggilan asinkron dijalankan. Riverpod lalu menerjemahkannya ke dalam status AsyncError. Pembuatan blok try catch eksplisit baru difungsikan saat mengelola operasi spesifik yang tidak mengikat status UI seperti aksi pengiriman formulir baru.

**4. Bagian mana dari hasil AI yang Anda perbaiki, dan mengapa?**

Skrip fungsi dasar yang dibuat oleh AI memerlukan beberapa penyesuaian teknis. AI menetapkan variabel batas waktu secara perorangan dalam setiap fungsi sehingga saya memindahkan variabel tersebut menuju file klien API utama untuk efisiensi koding. Saya juga merekonstruksi ulang kelas provider bawaan agar sanggup menerima input argumen parameter id. Fungsi penerjemah kode respon error AI turut saya hapus karena aplikasi telah tersambung pada modul pengelolaan error buatan praktikum sebelumnya.

## Pola Keliru yang Harus Dihindari

| No | Praktik Kesalahan | Dampak yang Ditimbulkan |
|---|---|---|
| 1 | Menulis base url langsung di setiap metode panggilan | Proses pergantian alamat server API akan memakan waktu lama karena developer wajib mencari baris alamat yang bersangkutan dan merevisinya di setiap sub folder proyek secara terpisah |
| 2 | Melakukan konversi teks data mentah secara paksa | Eksekusi aplikasi akan berhenti seketika saat server mengirimkan objek bernilai null secara acak pada fase kompilasi waktu berjalan |
| 3 | Mengabaikan variabel batasan waktu tunggu sambungan | Respon layar aplikasi berisiko terkunci pada animasi loading dalam waktu lama ketika kualitas jaringan sedang berada dalam batas kecepatan minim |

## AI Prompt Challenge

### Intruksi Prompt yang Digunakan
```text
Buatkan repository layer Flutter untuk endpoint GET /comments?postId={id}
dari JSONPlaceholder menggunakan Dio + flutter_riverpod.
Requirements:
- Model Comment dengan fromJson aman null (postId, id, name, email, body).
- CommentRepository dengan method fetchComments(postId) + timeout 10 detik.
- AsyncNotifierProvider dengan penanganan error otomatis (AsyncError)
  dan fungsi pesan error ramah pengguna untuk timeout, connection error, 404, dan 500.
- Satu unit test untuk fromJson dengan field yang hilang.
Jelaskan setiap bagian kode dalam komentar.
```

### Hasil Verifikasi

| No | Poin Verifikasi | Hasil Pengecekan |
|---|---|---|
| 1 | Apakah UI memanggil Dio secara langsung (dilarang) atau lewat repository? | Tidak ada pemanggilan langsung. Modul antarmuka membaca variabel state kelolaan dari status baca provider |
| 2 | Apakah fromJson aman null, atau masih memakai cast langsung yang bisa crash? | Pemetaan model menggunakan pendekatan opsi ganda nilai balik fallback untuk menangani masuknya data kosong |
| 3 | Apakah semua tipe DioExceptionType dipetakan ke pesan pengguna? | Terverifikasi. Sistem penanganan gagal memuat klasifikasi kode error ke file ekstensi tersendiri |
| 4 | Apakah baseUrl/timeout terpusat di satu client, bukan tersebar di tiap method? | Pengaturan protokol dan url difokuskan bersama pada satu file injeksi instansiasi klien |
| 5 | Apakah test AI benar-benar menguji kasus field hilang, atau hanya happy path? | Uji kode unit berhasil merangkum skenario ketidakadaan properti pengiriman JSON dari sumber pihak ketiga |
| 6 | Jalankan flutter analyze dan test, apakah lolos tanpa warning? | Pengecekan analisis linter dan komputasi tes otomatis sukses berjalan bersih |

### Rincian Modifikasi Teknis
- Merombak arsitektur model Notifier kepada wujud penyedia parameter argumen demi mengakomodasi masuknya nomor id pos spesifik
- Mengumpulkan file terpisah kode terjemahan error buatan AI untuk dipadukan pada skrip tunggal bawaan kerangka repositori utama

## Referensi Pendukung
- [Slide Minggu 4: Networking & REST API](https://drive.google.com/open?id=1tqDg_xjU7V4kWlygn4Utxr9CdxmTu9wb&usp=drive_fs)
- [Dio package](https://pub.dev/packages/dio)
- [JSONPlaceholder (API dummy)](https://jsonplaceholder.typicode.com/)
- [Riverpod: AsyncNotifier dan AsyncValue](https://riverpod.dev/docs/concepts/async_notifiers)
- [Flutter cookbook: Fetch data from the internet](https://docs.flutter.dev/cookbook/networking/fetch-data)
- [Learn Dart in Y Minutes](https://learnxinyminutes.com/dart/)
