# Learning Journal — Semester Mobile Development

**Athaulla Hafizh | NIM: 244107020030**

---

## Minggu 4 — Networking & REST API

**Tanggal:** 25 September 2026

### Yang Dipelajari
- Pengambilan data asinkron jarak jauh melalui protokol HTTP
- Penerapan batas tunggu dan pencatatan riwayat log antarmuka melalui klien tersentral `Dio`
- Model Null-safe Dart untuk memastikan ketangguhan data JSON yang tidak terstruktur
- Manajemen state asinkron menggunakan kerangka Riverpod (`AsyncNotifier`)
- Metode eksekusi daftar gulir layar muat tak berujung (Infinite scroll)

### Yang Dikerjakan
- [x] Pemusatan kerangka konfigurasi klien HTTP pada satu fail pengelola `Dio` utama
- [x] Pencetakan struktur kriteria operator penampung saat parameter null
- [x] Penciptaan fungsi antrian tarikan objek masif dari server tanpa *loading* penuh
- [x] Konversi galat sandi respon internet menuju kalimat pelindungan layar yang rapi
- [x] Lulus uji klinis fiktif (mocking) untuk skenario pengembalian cacat data eksternal

### Kendala & Solusi
- **Masalah:** Aplikasi seketika tertutup otomatis pada fase eksekusi saat beberapa tag label hilang dari data server penyedia aslinya.
- **Solusi:** Memberikan *defensive casting* menggunakan pendekatan operator *fallback* substitusi dasar untuk mensiasatinya.

### Key Takeaway
> Arsitektur panggilan jaringan wajib disembunyikan secara sempurna di dalam blok repositori mandiri demi menjamin bahwa layar murni mendemonstrasikan visual, tanpa terpengaruh skema di balik unduhan data tersebut.
