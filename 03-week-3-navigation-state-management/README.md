# Minggu 3 Navigation and State Management

## Tujuan
Memahami konsep navigasi deklaratif di Flutter menggunakan GoRouter, menerapkan state management dengan Riverpod (Provider, Notifier, ConsumerWidget), dan menangani state asinkron (loading, error, success) menggunakan AsyncValue dan AsyncNotifier.

## Fitur Utama
| Fitur | Keterangan |
|---|---|
| Navigasi GoRouter | Router deklaratif terpusat di `main.dart` dengan route bersarang dan path parameter `/detail/:id` pada `home_page.dart` dan `detail_page.dart` |
| ToDo List (Riverpod) | CRUD daftar tugas meliputi tambah, toggle done/undone, dan hapus, dikelola `TodoListNotifier` di luar widget pada `todo_page.dart` dan `todo_provider.dart` |
| State Immutable | Setiap perubahan state selalu membuat list baru menggunakan spread `[...state]` agar Riverpod bisa mendeteksi perubahan dan rebuild otomatis |
| AsyncValue (Produk) | State asinkron produk dimodelkan dengan `AsyncNotifier`, UI menangani loading, error, dan data sekaligus lewat `productsAsync.when()` pada `product_page.dart` dan `products_provider.dart` |
| Error Recovery | Tombol coba lagi menggunakan `ref.invalidate` untuk mereset dan menjalankan ulang provider dari awal |
| ProviderScope | Membungkus seluruh app di `main.dart` agar semua provider Riverpod bisa diakses dari widget manapun |

## Stack Teknologi
1. Bahasa Dart 3.13.2
2. Framework Flutter SDK 3.47.2
3. Package go_router 18.0.1, flutter_riverpod 3.4.3
4. Tools Android Studio, Git, Flutter CLI
5. Pengujian menggunakan flutter_test

## Cara Menjalankan
```bash
# Masuk ke folder project
cd 03-week-3-navigation-state-management

# Install dependencies
flutter pub get

# Jalankan aplikasi
flutter run
```

Keterangan navigasi dalam aplikasi:
1. Menekan item 1 sampai 10 akan masuk ke halaman Detail Praktikum 1.
2. Menekan tombol Buka ToDo akan masuk ke halaman ToDo Riverpod Praktikum 2.
3. Menekan tombol Buka Produk akan masuk ke halaman AsyncValue Praktikum 3.
4. Menekan tombol Buka Statistik akan masuk ke halaman StatsPage AI Challenge.

## Hasil yang Dicapai
Navigasi multi halaman berhasil diimplementasikan dengan GoRouter. Path parameter untuk detail id terverifikasi berjalan dan bisa diakses langsung tanpa harus melewati halaman utama terlebih dahulu.

Aplikasi ToDo berhasil dibangun dengan Riverpod. Operasi tambah, ubah status, dan hapus terbukti merefleksikan perubahan state secara reaktif di antarmuka pengguna tanpa perlu menggunakan blok setState.

Tiga kondisi AsyncValue yaitu loading, error, dan success berhasil diuji. Tampilan loading muncul selama 2 detik pertama, pesan error tampil lengkap dengan tombol coba lagi, dan data berhasil muncul setelah provider dipulihkan.

Fungsi invalidate dari Riverpod terbukti mampu mereset provider dan menjalankan ulang pengambilan data saat tombol coba lagi ditekan. Perintah flutter analyze juga menunjukkan tidak ada isu pada seluruh baris kode.

## Screenshot dan Bukti Visual

### Praktikum 1: Navigasi GoRouter
<img src="screenshots/Praktikum%201%20%E2%80%94%20Aplikasi%20multi-page%20dengan%20GoRouter%20(1).png" width="250" alt="HomePage daftar item"> <img src="screenshots/Praktikum%201%20%E2%80%94%20Aplikasi%20multi-page%20dengan%20GoRouter%20(2).png" width="250" alt="DetailPage path parameter">

> **Keterangan gambar:**
> - **Halaman Awal** menampilkan ListView berisi 10 item beserta tombol navigasi tugas di bagian bawah
> - **Halaman Detail** menampilkan id item yang diteruskan langsung lewat mekanisme path parameter GoRouter

### Praktikum 2: ToDo dengan Riverpod
<img src="screenshots/Praktikum%202%20%E2%80%94%20Halaman%20ToDo%20kosong.png" width="250" alt="TodoPage belum ada tugas"> <img src="screenshots/Praktikum%202%20%E2%80%94%20Daftar%20ToDo%20terisi.png" width="250" alt="TodoPage daftar tugas terisi"> <img src="screenshots/Praktikum%202%20%E2%80%94%20Toggle.png" width="250" alt="TodoPage item dicoret">

> **Keterangan gambar:**
> - **Kondisi Kosong** memunculkan teks informasi bahwa belum ada tugas yang tersimpan
> - **Daftar Tugas** tampil otomatis di layar sesaat setelah pengguna menambahkan entri data baru
> - **Tandai Selesai** menerapkan efek coret pada teks item dan dapat dihapus sepenuhnya lewat tombol tempat sampah

### Praktikum 3: AsyncValue (Loading, Error, Success)
<img src="screenshots/Praktikum%203%20%E2%80%94%20State%20Loading.png" width="250" alt="ProductPage loading"> <img src="screenshots/Praktikum%203%20%E2%80%94%20State%20Error.png" width="250" alt="ProductPage error state"> <img src="screenshots/Praktikum%203%20%E2%80%94%20State%20Success%20(Data).png" width="250" alt="ProductPage data tampil">

> **Keterangan gambar:**
> - **Tampilan Loading** berupa indikator putar melingkar yang menahan layar selama proses asinkron 2 detik pertama
> - **Tampilan Error** memunculkan teks peringatan sistem beserta tombol coba lagi untuk percobaan ulang
> - **Tampilan Sukses** menyajikan antarmuka ListView yang langsung memuat data produk (Keyboard, Mouse, Monitor)

### Tugas 6: Refactoring dan Testing
<img src="screenshots/Refactor&Testing%20%E2%80%94%20Tampilan%20NavigationBar.png" width="250" alt="Navigation Bar ToDo"> <img src="screenshots/AI%20Challenge%20%E2%80%94%20State%20Success%20(Data).png" width="250" alt="Navigation Bar Statistik"> <img src="screenshots/Refactor&Testing%20%E2%80%94%20Efek%20Filter%20di%20Halaman%20ToDo.png" width="250" alt="Filter ToDo Aktif">
<br><img src="screenshots/Refactor&Testing%20%E2%80%94%20Hasil%20Lulus%20flutter%20test.png" width="500" alt="Widget Test Berhasil">

> **Keterangan gambar:**
> - **Integrasi NavigationBar** sukses menjembatani navigasi antara halaman ToDo dan Statistik menggunakan perutean ShellRoute
> - **Fitur Penyaringan** membatasi tampilan halaman ToDo sehingga tugas akan langsung menghilang seketika saat dicentang selesai
> - **Pengujian Perangkat Lunak** lewat perintah flutter test terbukti lulus untuk uji coba logika penambahan tugas baru pada UI

## Refleksi

**1. Mengapa menampilkan ulang data lama dengan indikator refresh kadang lebih baik daripada mengosongkan layar? Kapan pola itu penting?**

Kalau layar langsung dikosongkan saat refresh berjalan, pengguna akan kehilangan konteks. Tidak ada informasi yang bisa dibaca selama proses berjalan padahal data lama yang tampil sebelumnya masih valid. Dengan pola mempertahankan data lama ditambah indikator putar, pengguna tetap bisa melihat isi sebelumnya sambil menunggu data baru masuk. Pola ini penting terutama saat koneksi internet lambat, saat tipe datanya jarang berubah drastis, dan saat proses memuat ulang dipicu secara manual oleh pengguna sendiri.

**2. Kapan penggunaan setState masih cukup, dan kapan sebuah state harus naik level ke Riverpod?**

Fungsi setState masih sangat cukup untuk state lokal yang sifatnya sementara dan hanya dipakai oleh satu widget saja, misalnya seperti animasi transisi, buka tutup menu *dropdown*, atau formulir input singkat. Sebaliknya, manajemen state harus dinaikkan ke Riverpod ketika datanya perlu dibawa melintasi berbagai halaman berbeda, butuh diakses oleh widget lain yang terpisah jauh di dalam hierarki antarmuka, atau ketika logika manipulasi datanya sudah mulai kompleks sehingga kodenya perlu dipisah dari baris kode tampilan antarmuka.

**3. Apa perbedaan context.go dan context.push, dan kapan masing-masing tepat digunakan?**

Perintah `context.go` mengubah lokasi secara mutlak dan mengganti tumpukan layar sesuai struktur *route* bawaan aplikasi. Ini sangat cocok untuk navigasi tingkat akar seperti berpindah tab utama. Sementara itu, `context.push` hanya menumpuk jendela baru di atas jendela yang sudah terbuka tanpa mempedulikan hierarki aplikasi, sehingga fungsi tombol kembali bawaan selalu mengarahkan pengguna ke jendela yang dibuka sebelumnya. Ini paling ideal digunakan untuk menampilkan informasi detail atau alur pendaftaran berjenjang.

**4. Bagaimana sistem AsyncValue mencegah bug di antarmuka dibanding tiga nilai boolean terpisah?**

Mengelola proses asinkron dengan tiga variabel boolean terpisah (seperti `isLoading`, `hasError`, dan `hasData`) rentan menghasilkan konflik logika, misalnya aplikasi tidak sengaja menampilkan animasi loading dan pesan error secara bersamaan. AsyncValue mencegah cacat perangkat lunak tersebut dengan membungkus ketiga kondisi tadi ke dalam satu tipe data tunggal yang saling menggugurkan. Lewat fungsi bawaan `when()`, pemrogram diwajibkan untuk menutupi skenario *loading*, *error*, dan kesuksesan secara sistematis tanpa ada celah tumpang tindih visual.

**5. Bagian mana dari kode AI yang Anda perbaiki, dan mengapa?**

Bagian yang saya bedah ulang meliputi logika duplikasi proses *fetch* data, penggunaan tombol penarik data ulang, dan kerangka pengujian unit. AI awalnya menuliskan kode pengambilan data dua kali di dua blok fungsi berbeda, sehingga saya meleburkannya agar ada satu sumber kebenaran tunggal yang mudah dipelihara. Untuk tombol uji coba ulang, saya mengganti perintah `ref.invalidate` menjadi sebuah method internal agar proses tersebut tetap terkontrol dengan baik. Terakhir, saya menyesuaikan kembali tata cara penulisan uji unit yang awalnya menyebabkan keterlambatan respon 30 detik akibat salah penempatan fungsi tunggu asinkron.

## Pola Keliru yang Harus Dihindari

| No | Praktik Kesalahan | Dampak yang Ditimbulkan |
|---|---|---|
| 1 | Menyisipkan perintah `ref.watch` di dalam fungsi callback tombol | Langganan ganda tiap kali antarmuka dirender ulang yang memicu beban memori |
| 2 | Menimpa data state secara langsung tanpa membangun objek baru | Sistem Riverpod gagal mendeteksi perubahan sehingga layar menolak untuk diperbarui |
| 3 | Mengabaikan penanganan kesalahan di dalam blok fungsi `when()` | Tampilan memutih kosong saat pengambilan data dari jaringan gagal terwujud |
| 4 | Memaksakan `setState` untuk elemen yang digunakan secara global | Data menghilang secara permanen ketika pengguna berpindah ke halaman lain |

## AI Prompt Challenge

### Intruksi Prompt yang Digunakan
```text
Buatkan halaman Flutter bernama StatsPage menggunakan flutter_riverpod.
Requirements:
1. ConsumerWidget dengan satu AsyncNotifierProvider yang mensimulasikan pengambilan data statistik (delay 2 detik, kadang gagal 30 persen).
2. UI harus menangani loading, pesan error beserta tombol retry, dan format kesuksesan via ListView 3 item.
3. Berikan unit test untuk provider terkait.
4. Jelaskan setiap bagian kode dalam komentar berbahasa Indonesia.
```

### Hasil Verifikasi

| No | Poin Verifikasi | Hasil Pengecekan |
|---|---|---|
| 1 | Apakah state diubah secara aman dan tidak dapat ditimpa langsung? | State diintegrasikan melalui `AsyncValue`, bukan dimanipulasi secara agresif pada baris list |
| 2 | Apakah pembacaan `ref` ditempatkan dengan benar? | Tombol muat ulang secara tepat membaca *notifier* menggunakan perintah satu kali panggil |
| 3 | Apakah ketiga skenario AsyncValue ditangani? | Kondisi memuat, peringatan galat, dan kesiapan data tercakup utuh di dalam perintah `when()` |
| 4 | Apakah penamaan Provider diketikkan secara tegas dan tak ambigu? | Ya, diketik secara eksplisit dengan `AsyncNotifierProvider` |
| 5 | Apakah arsitektur kodenya mutakhir? | Menggunakan kelas `AsyncNotifier` dan `ConsumerWidget`, menjauhi metode usang versi sebelumnya |
| 6 | Apakah aplikasi lulus uji klinis perangkat lunak? | Analisis statis membersihkan seluruh *file*, dan pengujian fungsional otomatis sukses mencetak centang hijau |

### Rincian Modifikasi Teknis
1. Blok awal kode kecerdasan buatan menyajikan instruksi redundan. Fungsi *build* segera diarahkan ulang untuk mendelegasikan tugas ke satu fungsi pusat agar pemeliharaan struktur menjadi terpusat.
2. Instruksi *retry* diubah ke bentuk *method* internal agar siklus operasinya tetap bersandar di dalam ruang lingkup Notifier aslinya.
3. Kerangka uji fungsional dirancang ulang dengan penambahan metode *listen* dan *delay* sepersekian detik untuk menanggulangi respons lamban ketika simulasi lemparan peringatan *error* tereksekusi.
4. Kelas fiktif yang digunakan untuk manipulasi pengujian ikut disempurnakan dengan penimpahan ulang pada fungsi percobaan kedua agar variabel peluang kegagalan 30 persen berhasil dihindari pada skenario yang mensyaratkan jaminan sukses.

## Referensi pendukung
- [Slide: Navigation & State Management](https://drive.google.com/file/d/1NB58_3HbR6pQhPTWG1Kbr4p4bHIcm45B/view)
- [Flutter: Navigation overview](https://docs.flutter.dev/ui/navigation)
- [GoRouter package](https://pub.dev/packages/go_router)
- [Riverpod: Getting started](https://riverpod.dev/docs/introduction/getting_started)
- [Riverpod: AsyncNotifier dan AsyncValue](https://riverpod.dev/docs/concepts/async_notifiers)
- [Learn Dart in Y Minutes](https://learnxinyminutes.com/dart/)
