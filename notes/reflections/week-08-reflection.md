# Refleksi - Minggu 8: Mid Project Review & Code Review

**Nama:** Athaulla Hafizh  
**NIM:** 244107020030  
**Tanggal:** 2 November 2026

---

## 1. Apa beda LGTM buta dengan approve yang bertanggung jawab? Apa risikonya bagi tim?
LGTM buta berarti menyetujui tanpa membuka kode, tanpa menjalankan tes, dan tanpa mencoba alurnya. Approve yang bertanggung jawab berarti reviewer membuka diff, memeriksa jalur *error*, menjalankan `flutter analyze` dan `flutter test`, lalu menguji manual di perangkat. Risikonya nyata: pada praktikum ini, kalau review dilakukan asal setuju, route detail yang salah escape akan lolos ke `develop` dan halaman detail pengumuman tetap tidak bisa dibuka tanpa ada yang menyadari.

## 2. Kapan komentar wajib berstatus request changes, dan kapan cukup saran?
Komentar wajib `request changes` ketika temuannya menyangkut kebenaran yang terlihat pengguna, pelanggaran *dependency rule*, atau tidak adanya tes pada jalur gagal. Contohnya route yang salah escape dan validasi judul yang tidak ada. Saran cukup dipakai untuk hal yang tidak mengubah perilaku, misalnya preferensi penamaan variabel. Temuan gaya berulang tidak perlu dikomentari satu per satu, cukup diserahkan ke `dart format` dan CI.

## 3. Bagian mana dari review AI yang Anda tolak atau sederhanakan, dan mengapa?
Saya menolak dua saran AI. Pertama, usulan mengganti `ref.read` pada `redirect` GoRouter menjadi `refreshListenable`, karena GoRouter sudah mengevaluasi `redirect` pada setiap navigasi sehingga perubahan itu hanya menambah kompleksitas tanpa memperbaiki bug. Kedua, usulan mengubah `notesProvider` menjadi `AsyncNotifier` dengan *optimistic update*, karena untuk CRUD satu tabel `ref.invalidate` sudah cukup. Saya juga menyederhanakan temuan *trailing comma* dan panjang baris dengan mengalihkannya ke `dart format`, bukan menyunting manual.

## 4. Satu hal konkret yang Anda perbaiki setelah review sejawat, apa dampaknya?
Saya memindahkan validasi judul dari widget ke *Use Case* `AddNote` pada *Domain Layer*. Dampaknya, aturan bisnis bisa diuji tanpa membangun widget, terbukti lewat tiga tes baru di `test/add_note_test.dart`. Efek sampingnya juga positif: `FloatingActionButton` tidak lagi memanggil `noteRepositoryProvider` langsung, sehingga *Dependency Rule* Minggu 7 tetap utuh. Bug tambahan juga ditemukan saat uji manual, yaitu controller dialog yang di-*dispose* terlalu cepat dan memicu kegagalan assertion; perbaikannya adalah memindahkan controller ke `StatefulWidget` dialog.
