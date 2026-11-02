# Learning Journal - Semester Mobile Development

**Athaulla Hafizh | NIM: 244107020030**

---

## Minggu 10 - Integrasi Fitur AI

**Tanggal:** 2 November 2026

### Yang Dipelajari
- Pola integrasi LLM API pada aplikasi mobile: UI, repository, service, dan penyimpanan kunci yang terpisah.
- Cara membaca respons *Server-Sent Events* (SSE) dari endpoint `streamGenerateContent` dan mengubahnya menjadi aliran teks bertahap.
- Perbedaan antara `generateContent` dan `streamGenerateContent`, serta alasan streaming lebih baik untuk pengalaman pengguna.
- Pengiriman API key lewat header `x-goog-api-key` agar tidak muncul pada log URL.
- Teknik penyamaran data pribadi sebelum request, *cache* jawaban dengan TTL, dan pembatasan jumlah permintaan per sesi.
- Pemetaan kode status 401/403, 404, 429, dan 503 menjadi pesan yang bisa dipahami pengguna.

### Yang Dikerjakan
- [x] Menyusun struktur `lib/features/ai/` dengan lapisan *domain*, *data*, dan *presentation*.
- [x] Membuat `AiService` dengan *streaming* SSE dan *retry* otomatis 3x untuk kode 503.
- [x] Membuat `AiKeyStore` di atas `flutter_secure_storage` dengan tampilan key tersamar.
- [x] Membuat `AiCache` berbasis SharedPreferences dengan TTL 1 hari.
- [x] Membuat `RedactSensitive` untuk menyamarkan NIK, nomor HP, dan email.
- [x] Membuat *Use Case* `AskAi` dengan validasi prompt dan batas 10 permintaan per sesi.
- [x] Membangun halaman `AiChatPage` dengan gelembung chat, indikator *streaming*, dan banner Mode Demo.
- [x] Membangun halaman `AiSettingsPage` untuk menyimpan dan menghapus API key.
- [x] Menulis 16 unit test baru untuk penyamaran, validasi, cache, dan jawaban mode demo.
- [x] Menjalankan seluruh pemeriksaan mesin dan mengambil bukti screenshot di emulator Pixel 8.

### Kendala & Solusi
- **Masalah:** Model `gemini-2.5-flash` dan `gemini-2.0-flash` mengembalikan kode 404 karena sudah ditutup untuk pengguna baru.
- **Solusi:** Mengganti ke `gemini-3.8-flash` dan memusatkan nama model pada `AiConfig` agar mudah diganti lagi.
- **Masalah:** Kode 503 dari layanan muncul sesekali ketika permintaan sedang padat.
- **Solusi:** Menambahkan *retry* otomatis maksimal tiga kali dengan jeda bertingkat sebelum menyerah.
- **Masalah:** Model generasi baru bisa butuh lebih dari dua menit sebelum mengirim byte pertama, sehingga timeout biasa membuat permintaan gagal padahal server masih bekerja.
- **Solusi:** Menghapus batas waktu pada tahap `send` dan memakai timeout diam yang panjang pada aliran SSE.
- **Masalah:** `dart format --set-exit-if-changed .` gagal karena direktori `build/` memiliki path terlalu panjang di Windows.
- **Solusi:** Membatasi cakupan ke `lib test` dan menyamakan perintah pada workflow CI.

### Key Takeaway
> Integrasi AI yang layak dipakai bukan soal berhasil memanggil API sekali, melainkan soal apa yang terjadi ketika API lambat, menolak, atau tidak tersedia. Lapisan *fallback*, *cache*, dan pesan error yang jujur justru menentukan apakah fitur ini terasa seperti produk atau hanya demo.
