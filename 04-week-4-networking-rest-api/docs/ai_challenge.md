# Dokumentasi AI Challenge - Week 4

## 1. Prompt yang Digunakan
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

## 2. Output Awal AI dan Perbaikan
AI menghasilkan kerangka dasar yang meliputi `Comment` model, `CommentRepository`, dan implementasi Provider. 

**Perbaikan yang Dilakukan terhadap Hasil AI:**
1. AI terkadang menyarankan penempatan *timeout* 10 detik di setiap pemanggilan Dio. Saya memperbaikinya dengan tetap menjaga kaidah sentralisasi (meletakkan konfigurasi terpusat pada `api_client.dart`), meskipun saya juga menambahkan parameter opsional pada `_dio.get` sebagai lapisan ganda.
2. AI menggunakan `AsyncNotifier` standar, padahal untuk meneruskan variabel spesifik seperti `postId`, arsitektur Riverpod mewajibkan penggunaan `FamilyAsyncNotifier`. Hal ini langsung saya revisi pada *file* `comment_providers.dart`.
3. Fungsi `friendlyErrorMessage` sebelumnya sudah dibuat di Praktikum 2, sehingga tidak perlu dibuat ulang menjadi fungsi duplikat oleh AI, melainkan cukup memanfaatkan ulang fungsi yang sudah ada.

## 3. Verifikasi Checklist AI
- [x] **Apakah UI memanggil Dio secara langsung (dilarang) atau lewat repository?**  
  **Jawaban:** Tidak ada pemanggilan langsung. UI nantinya hanya akan memanggil Riverpod Provider (`commentsProvider`), yang secara internal akan berinteraksi dengan `CommentRepository`.
- [x] **Apakah fromJson aman null, atau masih memakai cast langsung yang bisa crash?**  
  **Jawaban:** Terjamin aman *null*. Model menggunakan *defensive casting* seperti `json['name'] as String? ?? ''` alih-alih `as String` polos.
- [x] **Apakah semua tipe DioExceptionType dipetakan ke pesan pengguna?**  
  **Jawaban:** Ya. Pengecekan pada fungsi `friendlyErrorMessage` di `providers.dart` (dari praktikum sebelumnya) mencakup *timeout*, *connectionError*, *404*, *401/403*, dan *500*.
- [x] **Apakah baseUrl/timeout terpusat di satu client, bukan tersebar di tiap method?**  
  **Jawaban:** Ya. Terpusat di fungsi `createDio()` pada `api_client.dart`.
- [x] **Apakah test AI benar-benar menguji kasus field hilang, atau hanya happy path?**  
  **Jawaban:** Pengujian `comment_test.dart` telah mengujikan kasus (*edge case*) ketika JSON server tiba-tiba kehilangan atribut `name` dan `email`. Terbukti kode tidak akan mengalami *crash*, melainkan mengubah nilainya menjadi teks kosong `''`.
- [x] **Jalankan flutter analyze dan flutter test, apakah hasil AI lolos tanpa warning?**  
  **Jawaban:** Ya, linter *analyze* lolos, dan laporan *unit test* semuanya sukses (*passed*).
