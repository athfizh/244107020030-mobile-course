# Minggu 4 Networking & REST API

## Tujuan
Memahami konsep komunikasi data melalui protokol HTTP/REST, menerapkan sentralisasi klien (Dio) beserta *interceptor*, mengonversi JSON ke model Dart yang aman dari *null* (*null-safe*), mengelola *state* paginasi (*infinite scroll*) dengan Riverpod, dan melakukan pengujian perangkat lunak (*unit testing*) menggunakan *mock repository*.

## Fitur Utama
| Fitur | Keterangan |
|---|---|
| Sentralisasi Dio | Konfigurasi `baseUrl`, pengaturan *timeout*, dan pencatatan riwayat (*log interceptor*) dikelola terpusat di `api_client.dart` tanpa disebar di setiap *method*. |
| Null-Safe Model | Parsing JSON pada `post.dart` memanfaatkan *defensive casting* dengan nilai bawaan (*fallback*) untuk menghindari aplikasi *crash* jika atribut hilang. |
| Riverpod AsyncNotifier | Pengelolaan *state* pemanggilan API yang terbebas dari *race condition* dan sanggup menahan data lama selama kesalahan terjadi (pada `paged_posts.dart`). |
| Paginasi Dasar | Mekanisme *infinite scroll* yang akan menunda pengambilan data hingga pengguna mencapai batas bawah layar, lengkap dengan indikator *loading* tambahan. |
| Error Handling Pintar | Fungsi pemetaan `friendlyErrorMessage` mengubah sandi teknis `DioException` menjadi bahasa yang sangat ramah untuk dibaca oleh pengguna akhir. |
| Pengujian Fiktif | *Unit testing* untuk membuktikan *error handling* dan model berfungsi 100% menggunakan *Fake Repository* (Mock API) bebas koneksi internet. |

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

Keterangan navigasi dalam aplikasi:
1. Layar utama langsung memuat daftar **Posts** menggunakan mekanisme paginasi *infinite scroll*.
2. Mematikan data internet saat aplikasi berjalan akan memunculkan layar perlindungan **Error Koneksi** lengkap dengan tombol muat ulang.
3. Melakukan gulir layar (*scroll*) hingga bagian paling dasar akan otomatis memuat 20 item selanjutnya tanpa harus memuat ulang seluruh isi halaman.
4. Mengetuk salah satu *ListTile* pada linimasa akan membuka rute baru `/post/:id` untuk melihat halaman detail.

## Hasil yang Dicapai
Arsitektur penarikan data berlapis berhasil diimplementasikan tanpa ada kebocoran permohonan HTTP ke lapisan antarmuka. Model data terbukti kebal dari kerusakan bahkan ketika ada *field* (atribut JSON) yang secara paksa dihilangkan. 

Paginasi di halaman utama sukses mengeksekusi penarikan data secara berantai tanpa *refresh* ulang layar secara penuh. Skenario kesalahan dari server maupun *timeout* konektivitas terbukti ditangani dengan mulus, dan aplikasi sukses diuji serta terbebas 100% dari *warning* linter lewat perintah `flutter analyze`.

## Screenshot dan Bukti Visual

### Praktikum 1 & 2: Error Handling & Data Tunggal
<img src="screenshots/Praktikum%202%20-%20State%20Sukses%20(Daftar%20Post).png" width="250" alt="Daftar Data Sukses"> <img src="screenshots/Praktikum%202%20-%20State%20Error%20Koneksi%20(Mode%20Pesawat).png" width="250" alt="Error Koneksi"> <img src="screenshots/Praktikum%202%20-%20State%20Error%20Server%20(Salah%20URL%20%20404).png" width="250" alt="Error 404">

> **Keterangan gambar:**
> - **Daftar Data Sukses** menyajikan tampilan list saat internet berjalan normal.
> - **Error Koneksi** merupakan *state* ketika akses mode pesawat diaktifkan di emulator.
> - **Error 404** menyajikan respons aplikasi ketika diuji coba dengan memasukkan URL *endpoint* palsu.

### Praktikum 3: Paginasi (Infinite Scroll)
<img src="screenshots/Praktikum%203%20-%20State%20Infinite%20Scroll%20%20Paginasi%20(1).png" width="250" alt="Paginasi Loading 1"> <img src="screenshots/Praktikum%203%20-%20State%20Infinite%20Scroll%20%20Paginasi%20(2).png" width="250" alt="Paginasi Loading">

> **Keterangan gambar:**
> - **Infinite Scroll** menunjukkan titik henti sejenak berbentuk *CircularProgressIndicator* berukuran mini di bagian bawah daftar saat aplikasi mengambil kelompok data *page* selanjutnya.

### Tahap 7: Refactoring, Detail, & Testing
<img src="screenshots/Refactor&Testing%20-%20UI%20GoRouter%20(Detail%20Page).png" width="250" alt="Halaman Detail GoRouter">
<br><img src="screenshots/AI%20Challenge%20-%20Lolos%20Analyze%20&%20Test.png" width="500" alt="Hasil Lulus flutter test">

> **Keterangan gambar:**
> - **Halaman Detail** dimuat rapi dengan rute `/post/:id` membuktikan *refactoring widget* berhasil.
> - **Pengujian Perangkat Lunak** melalui Terminal VSCode membuktikan 100% kode uji (model JSON aman, pesan *error*, dan fiktif repo) sukses bercetak hijau.

## Refleksi

**1. Mengapa UI dilarang memanggil Dio langsung? Apa yang rusak jika aturan ini dilanggar?**

Antarmuka (UI) memiliki siklus hidup yang sangat pendek dan rentan dibangun ulang berkali-kali dalam hitungan detik. Jika UI memanggil `Dio` secara langsung, maka arsitektur aplikasi akan kacau; kode menjadi sulit dites (sulit di-*mock*), duplikasi pemanggilan berisiko terjadi setiap kali layar berputar (*rotate*), dan modifikasi kecil pada struktur JSON dari *server* akan memaksa kita untuk merombak habis kode tampilan.

**2. Kapan pagination client-side cukup, dan kapan harus mengandalkan pagination server (_page/_limit)?**

*Pagination client-side* (menarik seluruh data di awal lalu membaginya per halaman di dalam memori HP) cukup digunakan jika total populasi data kecil (maksimal ratusan) atau datanya jarang berubah. Sebaliknya, aplikasi wajib menggunakan *pagination server* ketika data berjumlah puluhan ribu hingga jutaan baris. Pemaksaan *client-side* untuk data raksasa akan menyiksa *server*, menghabiskan RAM perangkat pengguna, serta menelan kuota internet pelanggan secara sepihak.

**3. Bagaimana exception repository berubah menjadi AsyncError tanpa try/catch di setiap widget? Kapan try/catch eksplisit tetap dibutuhkan?**

Hal tersebut bisa terwujud karena `AsyncNotifier` milik Riverpod secara otomatis akan menangkap (*catch*) semua jenis interupsi atau *exception* apa pun yang terlempar di dalam fungsi asinkron (misalnya di dalam method `build` atau `AsyncValue.guard()`). Riverpod kemudian mengonversinya menjadi wujud *state* `AsyncError`. Walau begitu, *try/catch* eksplisit tetap wajib dibubuhkan di dalam kode khusus saat kita hendak mengeksekusi operasi tunggal tanpa memperbarui *state* (misalnya: aksi `POST` mengirim data *login* atau menghapus file).

**4. Bagian mana dari hasil AI yang Anda perbaiki, dan mengapa?**

Bagian yang saya bedah ulang dari hasil AI meliputi penempatan `timeout`, implementasi *state management* dengan argumen (*family/future provider*), dan penanganan pesan galat. AI sering kali menyelipkan *timeout* satu-persatu di tiap fungsi secara repetitif sehingga harus saya pusatkan ke dalam `api_client.dart`. Saya juga merevisi *provider* dasar yang awalnya tak mendukung penerimaan variabel, agar sukses menerima parameter spesifik seperti `postId`. Selain itu, duplikasi kode penerjemah *error* dari AI saya hilangkan karena aplikasinya sudah memiliki kelas penerjemah tersendiri di *file* `network_errors.dart`.

## Pola Keliru yang Harus Dihindari

| No | Praktik Kesalahan | Dampak yang Ditimbulkan |
|---|---|---|
| 1 | Hardcode `baseUrl` di setiap halaman *method* API | Jika alamat API berganti dari `http://api-v1` ke `http://api-v2`, pemrogram terpaksa mencari dan mengubah satu per satu *file*. |
| 2 | Pemaksaan konversi data mentah JSON (`as String`) | Aplikasi akan seketika *crash* menjadi layar merah mati total jika *server* secara tak sengaja tak mengembalikan *field* tersebut atau mengembalikannya sebagai `null`. |
| 3 | Mengabaikan waktu tunggu (`Timeout`) pada kofigurasi Dio | Aplikasi terjebak *loading* berputar-putar dalam waktu tak terbatas jika jaringannya tersendat namun tak putus 100%. |

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
| 1 | Apakah UI memanggil Dio secara langsung (dilarang) atau lewat repository? | Tidak ada pemanggilan langsung. UI terbukti hanya menyentuh Riverpod Provider, lalu Provider berkomunikasi dengan *Repository*. |
| 2 | Apakah fromJson aman null, atau masih memakai cast langsung yang bisa crash? | Terjamin aman *null*. Model memakai taktik *defensive casting* semacam `json['name'] as String? ?? ''` alih-alih `as String` murni. |
| 3 | Apakah semua tipe DioExceptionType dipetakan ke pesan pengguna? | Terverifikasi aman! Pesan error sudah mencakup segala jenis kegagalan via kelas `friendlyErrorMessage`. |
| 4 | Apakah baseUrl/timeout terpusat di satu client, bukan tersebar di tiap method? | Seluruh parameter HTTP berfokus mutlak di dalam fungsi injeksi `createDio()`. |
| 5 | Apakah test AI benar-benar menguji kasus field hilang, atau hanya happy path? | Uji coba unit terbukti meloloskan skenario *edge case* ketika JSON tak memiliki atribut (nilai menjadi *fallback text* kosong, tak lagi *crash*). |
| 6 | Jalankan flutter analyze dan test, apakah lolos tanpa warning? | Uji unit (*test*) dan cek sintaks linter (*analyze*) terverifikasi hijau 100%. |

### Rincian Modifikasi Teknis
- **Restrukturisasi Provider**: Meluruskan bentuk `AsyncNotifier` ke wujud yang menyetujui penerimaan argumen pencarian komentar untuk sebuah *post*.
- **Sentralisasi Komponen**: Membersihkan perulangan blok penterjemah pesan galat `DioException` buatan AI dan mengalihkannya pada komponen otentik yang telah berdiri semenjak Praktikum 2.

## Referensi Pendukung
- [Slide Minggu 4: Networking & REST API](https://drive.google.com/open?id=1tqDg_xjU7V4kWlygn4Utxr9CdxmTu9wb&usp=drive_fs)
- [Dio package](https://pub.dev/packages/dio)
- [JSONPlaceholder (API dummy)](https://jsonplaceholder.typicode.com/)
- [Riverpod: AsyncNotifier dan AsyncValue](https://riverpod.dev/docs/concepts/async_notifiers)
- [Flutter cookbook: Fetch data from the internet](https://docs.flutter.dev/cookbook/networking/fetch-data)
- [Learn Dart in Y Minutes](https://learnxinyminutes.com/dart/)

