# Minggu 10 Integrasi Fitur AI

**Nama:** Athaulla Hafizh  
**NIM:** 244107020030  

---

## Tujuan

Praktikum ini menambahkan satu fitur AI ke project hasil Minggu 9, yaitu asisten kampus berbasis Gemini API. Fokusnya bukan sekadar memanggil API, melainkan merancang integrasi yang layak dipakai: kunci disimpan aman, jawaban dialirkan bertahap (*streaming*), data pribadi disamarkan sebelum dikirim, jawaban di-*cache* agar hemat kuota, dan aplikasi tetap berguna ketika layanan AI sedang bermasalah.

---

## Fitur Utama

| Fitur | Keterangan |
|---|---|
| Chat Asisten Kampus | Antarmuka percakapan dengan gelembung pengguna dan gelembung jawaban AI |
| Streaming Response | Jawaban muncul bertahap dari endpoint `streamGenerateContent?alt=sse` |
| API Key Aman | Key disimpan di `flutter_secure_storage` dan dikirim lewat header `x-goog-api-key`, bukan *query string* |
| Penyamaran Data Pribadi | NIK, nomor HP, dan email diganti `[NIK]`, `[NO_HP]`, dan `[EMAIL]` sebelum dikirim |
| Cache Jawaban | Jawaban disimpan di SharedPreferences dengan masa berlaku 1 hari dan penanda `dari cache` pada UI |
| Batas Permintaan | Maksimal 10 permintaan per sesi untuk menahan lonjakan biaya |
| Mode Demo | Saat API key kosong, aplikasi menjawab dari data lokal dan menampilkan banner jujur |
| Penanganan Error | Kode 401/403, 404, 429, dan 503 dipetakan menjadi pesan yang bisa dipahami pengguna, dengan *retry* otomatis 3x untuk 503 |

---

## Stack Teknologi
1. Bahasa Dart 3.13.2
2. Framework Flutter SDK 3.47.2
3. Package `flutter_riverpod` 2.6.1, `go_router` 14.8.1, `dio` 5.8.0, `flutter_secure_storage` 9.2.4, `sqflite` 2.4.4, `path` 1.9.1, `intl` 0.20.3, `http` 1.2.0, `shared_preferences` 2.5.5
4. Layanan AI: Google Gemini `gemini-3.8-flash` (streaming SSE)
5. Tools Android Studio, Git, Flutter CLI
6. Pengujian menggunakan `flutter_test`

---

## Cara Menjalankan
```bash
cd 10-week-10-ai-feature-integration

flutter pub get

flutter run

flutter test
```

Keterangan alur aplikasi:
1. Masuk melalui halaman Login, lalu tekan tombol **Tanya AI** pada halaman Home.
2. Tanpa API key, aplikasi berjalan pada **Mode Demo** dan menjawab dari data lokal.
3. Untuk memakai Gemini asli, buka ikon **Pengaturan** lalu tempel API key pada kolom `API key baru`.
4. Key disimpan terenkripsi dan ditampilkan dalam bentuk tersamar, misalnya `AQ.A...ueng`.
5. Kirim pertanyaan dan jawaban akan muncul bertahap. Pertanyaan yang sama pada hari yang sama dijawab dari cache.

---

## Hasil yang Dicapai

Integrasi Gemini berhasil berjalan dengan jawaban streaming yang benar-benar berasal dari model, bukan data lokal. API key tidak pernah menyentuh kode sumber maupun repository. Data pribadi tersamarkan sebelum dikirim, terbukti lewat lima unit test. Cache 1 hari bekerja dan menampilkan penanda `dari cache`, sedangkan batas 10 permintaan per sesi terbukti lewat test. Seluruh pemeriksaan mesin hijau dengan 49 tes, dan aplikasi tetap bisa didemokan tanpa key melalui Mode Demo.

---

## Arsitektur Integrasi AI

```text
Flutter UI (AiChatPage)
        |
        v
AiChatNotifier (Presentation, Riverpod)
        |
        v
AskAi (Domain: validasi prompt, redaksi, batas sesi)
        |
        v
AiRepository (Domain: kontrak)
        |
        v
AiRepositoryImpl (Data)
   |          |            |
   v          v            v
AiCache   AiKeyStore    AiService
(Shared   (secure      (HTTP + SSE
 Prefs)    storage)     ke Gemini)
```

Aturan yang dijaga: *Domain* tidak mengimpor Flutter, `http`, maupun
`shared_preferences`. Widget tidak pernah memanggil `AiService` secara langsung.

---

## Prompt Design

| Komponen | Isi |
|---|---|
| System prompt | "Kamu asisten kampus yang ramah. Jawab dalam Bahasa Indonesia, maksimal 2 kalimat, dan jangan meminta data pribadi pengguna." |
| User prompt | Pertanyaan bebas dari pengguna, dibatasi 10 permintaan per sesi |
| Konteks | Tidak ada data pengguna yang dikirim; hanya teks pertanyaan yang sudah disamarkan |
| Batas | Panjang jawaban dibatasi lewat prompt sistem, bukan pemotongan paksa di UI |

Aturan privasi diterapkan sebelum request: NIK 16 digit menjadi `[NIK]`,
nomor berawalan `08` menjadi `[NO_HP]`, dan alamat email menjadi `[EMAIL]`.

---

## Risiko dan Mitigasi

| Risiko | Mitigasi |
|---|---|
| Bocor data pengguna | Penyamaran NIK, nomor HP, dan email sebelum request |
| Biaya melonjak | Cache 1 hari dan batas 10 permintaan per sesi |
| API error atau down | Pemetaan kode status, *retry* 3x untuk 503, dan mode demo |
| Respons tidak relevan | Prompt sistem membatasi panjang dan topik jawaban |
| Key bocor di repository | Key hanya di `flutter_secure_storage`, `.env` di `.gitignore`, tampilan key disamarkan |

---

## Tahapan Praktikum

### Praktikum 1: Integrasi Gemini, Streaming, dan Pengaturan Key
<img src="screenshots/Praktikum 1 - Halaman Home AI.png" width="250" alt="Home AI"> <img src="screenshots/Praktikum 1 - Halaman Chat AI Kosong.png" width="250" alt="Chat Kosong"> <img src="screenshots/Praktikum 1 - Pengaturan API Key.png" width="250" alt="Pengaturan API Key">

> **Keterangan gambar**
> - Tombol **Tanya AI** ditambahkan pada halaman Home sebagai pintu masuk fitur.
> - Halaman chat kosong menampilkan contoh pertanyaan dan banner Mode Demo ketika key belum diatur.
> - Halaman Pengaturan menyediakan kolom key bertipe *obscure* beserta catatan keamanan.

<img src="screenshots/Praktikum 1 - API Key Tersimpan Tersamar.png" width="250" alt="Key Tersamar"> <img src="screenshots/Praktikum 1 - Streaming Response.png" width="250" alt="Streaming"> <img src="screenshots/Praktikum 1 - Chat AI Menjawab Asli.png" width="250" alt="Jawaban Asli">

> **Keterangan gambar**
> - Key yang tersimpan hanya ditampilkan sebagian (`AQ.A...ueng`) agar screenshot aman dibagikan.
> - Saat jawaban sedang dialirkan, gelembung AI menampilkan `...` sebagai penanda proses berjalan.
> - Jawaban lengkap berasal dari Gemini asli, bukan dari daftar jawaban lokal.

### Praktikum 2: Fallback, Error Handling, dan Mode Demo
<img src="screenshots/Praktikum 2 - Fallback Tanpa API Key.png" width="250" alt="Mode Demo"> <img src="screenshots/Praktikum 2 - Error Layanan AI.png" width="250" alt="Error Layanan AI">

> **Keterangan gambar**
> - Tanpa API key, aplikasi tetap menjawab lewat Mode Demo dengan banner informasi yang jelas.
> - Saat layanan menolak permintaan, pesan kesalahan ditampilkan sebagai gelembung chat, bukan layar merah atau diam tanpa kabar.
> - Kode status 503 dicoba ulang otomatis hingga tiga kali sebelum menyerah.

### Praktikum 3: Cache, Privasi, dan Verifikasi Mesin
<img src="screenshots/Praktikum 3 - Jawaban dari Cache.png" width="250" alt="Jawaban dari Cache"> <img src="screenshots/Praktikum 3 - Prompt Sistem dan Privasi.png" width="500" alt="Prompt dan Privasi">

> **Keterangan gambar**
> - Pertanyaan yang sama pada hari yang sama dijawab dari cache dan diberi penanda `dari cache` di bawah gelembung.
> - Prompt sistem dan aturan penyamaran data pribadi tercatat eksplisit sehingga bisa diaudit.

<img src="screenshots/Praktikum 3 - Hasil Flutter Test.png" width="500" alt="Flutter Test"> <img src="screenshots/Refactoring - Flutter Analyze dan Test.png" width="400" alt="Analyze">

> **Keterangan gambar**
> - Seluruh 49 tes lulus, mencakup penyamaran data, validasi prompt, cache, dan batas sesi.
> - `flutter analyze` selesai tanpa satu pun isu.

### Refactoring & Testing
<img src="screenshots/Refactoring - Hasil Flutter Format.png" width="500" alt="Format">

> **Keterangan gambar**
> - `dart format --set-exit-if-changed lib test` melaporkan nol file berubah.
> - Struktur akhir memisahkan *Presentation*, *Domain*, dan *Data* sesuai aturan Minggu 7.

---

## AI Prompt Challenge

Prompt sistem, contoh user prompt, output awal AI, tabel keputusan, serta tabel risiko dan mitigasi dicatat pada dokumen terpisah.

<img src="screenshots/AI Challenge - Tabel Risiko dan Mitigasi.png" width="600" alt="Risiko dan Mitigasi">

👉 [**Lihat Pembahasan AI Log (ai-log.md)**](docs/ai-log.md)

---

## Refleksi

**1. Fitur AI mana yang Anda integrasikan dan mengapa?**

Saya memilih chat asisten kampus karena paling dekat dengan kebutuhan nyata mahasiswa dan paling ringkas untuk dibuktikan. Chat hanya butuh satu endpoint, tetapi tetap memaksa saya menyelesaikan hal-hal yang sering dilewatkan: penyimpanan kunci, penyamaran data, *streaming*, *cache*, dan penanganan error. OCR atau *speech-to-text* akan menambah izin perangkat dan berkas biner, sehingga bukti yang bisa dinilai justru berkurang.

**2. Bagaimana Anda melindungi privasi pengguna saat menggunakan AI API?**

Tiga lapis. Pertama, prompt sistem melarang model meminta data pribadi. Kedua, sebelum request, `RedactSensitive` mengganti NIK, nomor HP, dan email menjadi penanda. Ketiga, API key tidak pernah ikut terkirim sebagai bagian percakapan; ia hanya hidup di `flutter_secure_storage` dan dikirim lewat header `x-goog-api-key`. Screenshot pengaturan juga hanya menampilkan key tersamar.

**3. Fallback apa yang Anda sediakan jika layanan AI error?**

Ada tiga tingkat. Untuk 503, aplikasi mencoba ulang tiga kali dengan jeda bertingkat. Untuk 401/403, 404, dan 429, aplikasi menampilkan pesan spesifik agar pengguna tahu apakah masalahnya di key, model, atau kuota. Untuk kondisi tanpa key sama sekali, aplikasi masuk Mode Demo dan menjawab dari data lokal, sehingga demo tidak pernah gagal total.

**4. Satu hal yang Anda pelajari tentang UX fitur AI di mobile?**

Menunggu adalah bagian dari pengalaman. Model generasi baru bisa butuh lebih dari satu menit sebelum mengirim byte pertama, dan pengguna tidak boleh dibiarkan menatap layar kosong. Karena itu gelembung `...` muncul segera setelah pertanyaan dikirim, dan jawaban ditampilkan bertahap alih-alih menunggu satu blok teks selesai. Kesabaran pengguna jauh lebih panjang ketika ada tanda bahwa sistem sedang bekerja.

---

## Referensi

- [Slide Week 10: Integrasi Fitur AI](https://jti-polinema.github.io/flutter-codelab/00-slides/Week_10_AI_Feature_Integration.html)
- [Google Gemini AI API](https://ai.google.dev/gemini-api/docs)
- [flutter_secure_storage package](https://pub.dev/packages/flutter_secure_storage)
- [http package](https://pub.dev/packages/http)
- [Riverpod: Getting started](https://riverpod.dev/docs/introduction/getting_started)
- [Learn Dart in Y Minutes](https://learnxinyminutes.com/dart/)
- [Dart Language Tour](https://dart.dev/language)
