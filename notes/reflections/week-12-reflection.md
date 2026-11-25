# Refleksi - Minggu 12: Testing & Quality Assurance

**Nama:** Athaulla Hafizh  
**NIM:** 244107020030  
**Tanggal:** 9 November 2026

---

## 1. Bug apa yang paling mungkin terlewat tanpa pengujian yang Anda tulis?
Bug pada perpindahan state. Tombol Login yang tetap aktif saat proses berjalan, atau halaman pengumuman yang menampilkan layar kosong ketika jaringan gagal, tidak terlihat dari pembacaan kode sekilas. Widget test memaksa saya memeriksa state loading dan error secara eksplisit. Tanpa test itu, bug baru muncul saat perangkat dipakai.

## 2. Bagian mana yang perlu fake, dan bagaimana fake itu membuat pengujian lebih konsisten?
Autentikasi, repository catatan, dan repository pengumuman. Ketiganya menyentuh dunia luar: jaringan, `flutter_secure_storage`, dan SQLite. Dengan fake, test tidak bergantung pada kuota `reqres.in`, isi database perangkat, atau kecepatan jaringan. Fake juga bisa dipaksa gagal, sesuatu yang sulit dilakukan pada layanan nyata.

## 3. Apa perbedaan nilai yang diberikan pengujian widget dan pengujian integrasi pada fitur Anda?
Widget test cepat dan presisi: ia membuktikan satu layar bereaksi benar terhadap satu state, misalnya pesan validasi muncul. Namun widget test tidak membuktikan bahwa login benar-benar menyimpan token atau SQLite benar-benar menulis catatan. Integration test menutup celah itu, tetapi lebih lambat, lebih rapuh, dan hanya layak untuk satu alur utama.
