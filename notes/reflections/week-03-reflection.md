# Refleksi — Minggu 3: Navigation & State Management

**Nama:** Athaulla Hafizh  
**NIM:** 244107020030  
**Tanggal:** 25 September 2026

---

## 1. Mengapa menampilkan ulang data lama dengan indikator refresh kadang lebih baik daripada mengosongkan layar? Kapan pola itu penting?

Kalau layar langsung dikosongkan saat refresh berjalan, pengguna akan kehilangan konteks. Tidak ada informasi yang bisa dibaca selama proses berjalan padahal data lama yang tampil sebelumnya masih valid. Dengan pola mempertahankan data lama ditambah indikator putar, pengguna tetap bisa melihat isi sebelumnya sambil menunggu data baru masuk. Pola ini penting terutama saat koneksi internet lambat, saat tipe datanya jarang berubah drastis, dan saat proses memuat ulang dipicu secara manual oleh pengguna sendiri.

---

## 2. Kapan penggunaan setState masih cukup, dan kapan sebuah state harus naik level ke Riverpod?

Fungsi setState masih sangat cukup untuk state lokal yang sifatnya sementara dan hanya dipakai oleh satu widget saja, misalnya seperti animasi transisi, buka tutup menu *dropdown*, atau formulir input singkat. Sebaliknya, manajemen state harus dinaikkan ke Riverpod ketika datanya perlu dibawa melintasi berbagai halaman berbeda, butuh diakses oleh widget lain yang terpisah jauh di dalam hierarki antarmuka, atau ketika logika manipulasi datanya sudah mulai kompleks sehingga kodenya perlu dipisah dari baris kode tampilan antarmuka.

---

## 3. Apa perbedaan context.go dan context.push, dan kapan masing-masing tepat digunakan?

Perintah `context.go` mengubah lokasi secara mutlak dan mengganti tumpukan layar sesuai struktur *route* bawaan aplikasi. Ini sangat cocok untuk navigasi tingkat akar seperti berpindah tab utama. Sementara itu, `context.push` hanya menumpuk jendela baru di atas jendela yang sudah terbuka tanpa mempedulikan hierarki aplikasi, sehingga fungsi tombol kembali bawaan selalu mengarahkan pengguna ke jendela yang dibuka sebelumnya. Ini paling ideal digunakan untuk menampilkan informasi detail atau alur pendaftaran berjenjang.

---

## 4. Bagaimana sistem AsyncValue mencegah bug di antarmuka dibanding tiga nilai boolean terpisah?

Mengelola proses asinkron dengan tiga variabel boolean terpisah (seperti `isLoading`, `hasError`, dan `hasData`) rentan menghasilkan konflik logika, misalnya aplikasi tidak sengaja menampilkan animasi loading dan pesan error secara bersamaan. AsyncValue mencegah cacat perangkat lunak tersebut dengan membungkus ketiga kondisi tadi ke dalam satu tipe data tunggal yang saling menggugurkan. Lewat fungsi bawaan `when()`, pemrogram diwajibkan untuk menutupi skenario *loading*, *error*, dan kesuksesan secara sistematis tanpa ada celah tumpang tindih visual.

---

## 5. Bagian mana dari kode AI yang Anda perbaiki, dan mengapa?

Bagian yang saya bedah ulang meliputi logika duplikasi proses *fetch* data, penggunaan tombol penarik data ulang, dan kerangka pengujian unit. AI awalnya menuliskan kode pengambilan data dua kali di dua blok fungsi berbeda, sehingga saya meleburkannya agar ada satu sumber kebenaran tunggal yang mudah dipelihara. Untuk tombol uji coba ulang, saya mengganti perintah `ref.invalidate` menjadi sebuah method internal agar proses tersebut tetap terkontrol dengan baik. Terakhir, saya menyesuaikan kembali tata cara penulisan uji unit yang awalnya menyebabkan keterlambatan respon 30 detik akibat salah penempatan fungsi tunggu asinkron.
