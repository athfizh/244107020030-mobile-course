# Learning Journal — Semester Mobile Development

**Athaulla Hafizh | NIM: 244107020030**

---

## Minggu 3 — Navigation & State Management

**Tanggal:** 25 September 2026

### Yang Dipelajari
- Penggunaan pustaka `go_router` untuk sistem navigasi deklaratif
- Konsep manajemen state terpusat menggunakan kerangka `Riverpod`
- Penanaman `ProviderScope` di level paling atas aplikasi
- Penyimpanan dan pembacaan state statis maupun dinamis via `StateProvider`

### Yang Dikerjakan
- [x] Pembuatan menu laci aplikasi (Drawer navigation)
- [x] Perpindahan rute statis menuju halaman daftar dan halaman dengan parameter
- [x] Integrasi fungsi peralihan mode terang dan gelap via state `Riverpod`
- [x] Ekstraksi fungsi kalkulasi matematis menggunakan state provider

### Kendala & Solusi
- **Masalah:** Fungsi perpindahan rute antar halaman sempat mengalami kejanggalan saat tombol kembali bawaan gawai ditekan.
- **Solusi:** Memanfaatkan manajemen riwayat tumpukan berlapis dari `go_router` ketimbang pustaka rute bawaan milik Flutter.

### Key Takeaway
> Pengaturan status aplikasi tidak seharusnya tercampur aduk di dalam kelas perender antarmuka. Pemisahan fungsi ini pada manajemen lapisan mandiri membuat modul program menjadi sangat independen dan mudah dites secara berkelanjutan.
