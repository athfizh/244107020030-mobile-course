# Refleksi - Minggu 5: Local Storage & Offline First

**Nama:** Athaulla Hafizh  
**NIM:** 244107020030  
**Tanggal:** 2 Oktober 2026

---

## 1. Mengapa daftar catatan tidak boleh disimpan di SharedPreferences? Apa yang rusak jika aturan ini dilanggar?
SharedPreferences memuat seluruh isi datanya ke dalam memori aplikasi (RAM) secara bersamaan saat dijalankan. Jika kita menaruh ribuan data JSON yang kompleks ke dalamnya, aplikasi bisa mengalami *Out-of-Memory (OOM)* atau *freeze* saat proses *decoding/encoding*. Selain itu, kita tidak bisa melakukan operasi SQL murni (misalnya memfilter `WHERE dirty = 1`).

## 2. Kapan cache-first cukup, dan kapan Anda membutuhkan strategi lain?
*Cache-first* sangat cukup untuk jenis sistem konsumsi konten sosial atau artikel bacaan. Akan tetapi strategi *Network-first* mutlak diperlukan apabila aplikasi berhubungan dengan saldo, harga saham *real-time*, atau tiket transportasi komersial untuk menghindari keputusan fatal akibat *cache* lama.

## 3. Bagaimana dirty flag berubah menjadi antrean sync tanpa memblokir UI? Kapan antrean terpisah (tabel outbox) menjadi perlu?
Tugas antrean *sync* ditarik ke dalam isolasi `AsyncNotifier` (Riverpod) yang mengeksekusi operasi secara asinkron di belakang panggung. Tabel antrean terpisah (tabel *outbox*) digunakan apabila aplikasi harus merekam rantai mutasi kompleks lintas entitas saat mode offline berjalan tanpa henti.

## 4. Bagian mana dari rekomendasi AI yang Anda tolak, dan mengapa?
Saya menolak saran dari hasil keluaran generatif AI yang memaksakan adopsi *Drift* di setiap kondisi aplikasi *offline-first*. Pemasangan dan pembangunan *codegen* dari *Drift* memakan waktu dan boilerplate yang tidak ringkas, saya mempertahankan *sqflite* karena efisiensinya.
