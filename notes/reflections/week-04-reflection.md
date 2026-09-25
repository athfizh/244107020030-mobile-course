# Refleksi — Minggu 4: Networking & REST API

**Nama:** Athaulla Hafizh  
**NIM:** 244107020030  
**Tanggal:** 25 September 2026

---

## 1. Mengapa UI dilarang memanggil Dio langsung? Apa yang rusak jika aturan ini dilanggar?

Antarmuka bertugas murni untuk menampilkan sisi visual aplikasi. Jika fungsi antarmuka melakukan pemanggilan API secara langsung maka arsitektur kode akan menyatu. Kode tersebut akan berimbas pada sulitnya proses pengujian dan perubahan format JSON dari server bisa memaksa developer merombak ulang banyak file tampilan. Kondisi ini juga berisiko tinggi memicu pemanggilan ganda setiap kali sistem membangun ulang layar antarmuka.

## 2. Kapan pagination client-side cukup, dan kapan harus mengandalkan pagination server (_page/_limit)?

Penerapan pagination sisi klien relevan digunakan untuk data statis tabel dengan jumlah entri yang masih tergolong sedikit. Namun untuk pengambilan data dinamis yang mencapai rentang ribuan baris ke atas maka pagination harus diletakkan pada sistem antrian server. Memaksakan pengolahan sisi klien untuk data skala masif akan menyebabkan beban yang signifikan pada memori perangkat pengguna dan boros konsumsi kuota data internet.

## 3. Bagaimana exception repository berubah menjadi AsyncError tanpa try/catch di setiap widget? Kapan try/catch eksplisit tetap dibutuhkan?

Paket Riverpod melalui kelas AsyncNotifier memiliki mekanisme proteksi error bawaan secara dasar. Segala bentuk kegagalan jaringan yang terjadi pada lapisan repository akan direkam secara otomatis sesaat setelah fungsi panggilan asinkron dijalankan. Riverpod lalu menerjemahkannya ke dalam status AsyncError. Pembuatan blok try catch eksplisit baru difungsikan saat mengelola operasi spesifik yang tidak mengikat status UI seperti aksi pengiriman formulir baru.

## 4. Bagian mana dari hasil AI yang Anda perbaiki, dan mengapa?

Skrip fungsi dasar yang dibuat oleh AI memerlukan beberapa penyesuaian teknis. AI menetapkan variabel batas waktu secara perorangan dalam setiap fungsi sehingga saya memindahkan variabel tersebut menuju file klien API utama untuk efisiensi koding. Saya juga merekonstruksi ulang kelas provider bawaan agar sanggup menerima input argumen parameter id. Fungsi penerjemah kode respon error AI turut saya hapus karena aplikasi telah tersambung pada modul pengelolaan error buatan praktikum sebelumnya.
