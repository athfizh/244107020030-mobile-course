# Refleksi - Minggu 11: Performance Optimization

**Nama:** Athaulla Hafizh  
**NIM:** 244107020030  
**Tanggal:** 2 November 2026

---

## 1. Optimasi mana yang memberikan dampak terbesar dan mengapa?
`RepaintBoundary` dan `itemExtent` memberi dampak terbesar. Keduanya bekerja pada akar masalah yang sama: biaya *raster*. `itemExtent` menghapus kebutuhan mengukur tinggi setiap item, sedangkan `RepaintBoundary` membatasi area yang digambar ulang. Karena *build* hanya 0,66 ms sementara *raster* 16,50 ms, perbaikan pada sisi raster memang paling terasa, terbukti dari penurunan 49,6%.

## 2. Bagaimana Anda memverifikasi bahwa optimasi benar-benar bekerja (bukan placebo)?
Saya mengukur dua kali dengan skenario identik: login, buka pengumuman, gulir enam kali, buka detail, kembali, gulir balik empat kali. Keduanya memakai build profile, bukan debug, dan perangkat yang sama. Angka dibandingkan pada metrik yang sama: rata-rata, p90, p95, dan persentase jank. Tanpa perbandingan itu, "terasa lebih cepat" tidak bisa dibuktikan.

## 3. Trade-off apa yang Anda hadapi?
Tiga trade-off utama. Pertama, kompleksitas: `AnnouncementsNotifier` kini mengelola `_page`, `_hasMore`, dan `_loadingMore`. Kedua, memori: cache menambah sekitar 4,3 MB PSS. Ketiga, kesegaran data: TTL 5 menit berarti pengguna bisa melihat data lama hingga 5 menit. Ketiganya saya terima karena pengumuman bukan data *real-time* dan biaya jaringan yang dihemat lebih besar.

## 4. Kapan sebaiknya optimasi premature dihindari?
Optimasi premature terjadi ketika kode diubah tanpa angka pendukung. Contohnya menambah `itemExtent` pada daftar berisi lima item, atau memasang `RepaintBoundary` di seluruh widget. Keduanya menambah kode tanpa manfaat terukur. Aturan yang saya pakai: ukur dulu, perbaiki masalah terbesar, lalu ukur ulang. Optimasi yang tidak bisa dibuktikan lewat metrik lebih baik ditunda.
