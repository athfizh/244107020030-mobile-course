# Refleksi - Minggu 10: Integrasi Fitur AI

**Nama:** Athaulla Hafizh  
**NIM:** 244107020030  
**Tanggal:** 2 November 2026

---

## 1. Fitur AI mana yang Anda integrasikan dan mengapa?
Saya memilih chat asisten kampus karena paling dekat dengan kebutuhan nyata mahasiswa dan paling ringkas untuk dibuktikan. Chat hanya butuh satu endpoint, tetapi tetap memaksa saya menyelesaikan hal-hal yang sering dilewatkan: penyimpanan kunci, penyamaran data, *streaming*, *cache*, dan penanganan error. OCR atau *speech-to-text* akan menambah izin perangkat dan berkas biner, sehingga bukti yang bisa dinilai justru berkurang.

## 2. Bagaimana Anda melindungi privasi pengguna saat menggunakan AI API?
Tiga lapis. Pertama, prompt sistem melarang model meminta data pribadi. Kedua, sebelum request, `RedactSensitive` mengganti NIK, nomor HP, dan email menjadi penanda. Ketiga, API key tidak pernah ikut terkirim sebagai bagian percakapan; ia hanya hidup di `flutter_secure_storage` dan dikirim lewat header `x-goog-api-key`. Screenshot pengaturan juga hanya menampilkan key tersamar.

## 3. Fallback apa yang Anda sediakan jika layanan AI error?
Ada tiga tingkat. Untuk 503, aplikasi mencoba ulang tiga kali dengan jeda bertingkat. Untuk 401/403, 404, dan 429, aplikasi menampilkan pesan spesifik agar pengguna tahu apakah masalahnya di key, model, atau kuota. Untuk kondisi tanpa key sama sekali, aplikasi masuk Mode Demo dan menjawab dari data lokal, sehingga demo tidak pernah gagal total.

## 4. Satu hal yang Anda pelajari tentang UX fitur AI di mobile?
Menunggu adalah bagian dari pengalaman. Model generasi baru bisa butuh lebih dari satu menit sebelum mengirim byte pertama, dan pengguna tidak boleh dibiarkan menatap layar kosong. Karena itu gelembung `...` muncul segera setelah pertanyaan dikirim, dan jawaban ditampilkan bertahap alih-alih menunggu satu blok teks selesai. Kesabaran pengguna jauh lebih panjang ketika ada tanda bahwa sistem sedang bekerja.
