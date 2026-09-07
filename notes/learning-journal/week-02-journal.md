# Learning Journal - Week 2

## Topik Utama
- Declarative UI dalam Flutter
- Widget dasar tata letak (`Row`, `Column`, `Container`, `Expanded`, `Spacer`)
- Pembuatan layout responsif menggunakan `LayoutBuilder`
- Integrasi `StatefulWidget` untuk perubahan state (Dark Mode)
- Aksesibilitas di Flutter (`Semantics`)

## Aktivitas Praktikum
1. **Pembuatan Profil Mahasiswa (Warm-up)**
   - Menyusun widget `Row` dan `Column` untuk membangun antarmuka kartu mahasiswa.
   - Mengatasi permasalahan ruang dan proporsi dengan `Expanded` dan `Spacer`.
   - Mengamati penyebab error overflow teks pada sumbu horizontal dan vertikal.

2. **Pembuatan Dashboard Responsif**
   - Menerapkan `LayoutBuilder` untuk mendeteksi perubahan lebar layar (breakpoint).
   - Mengubah struktur jumlah kolom pada `GridView` secara adaptif saat lebar aplikasi lebih dari 700px.
   - Merubah `StatelessWidget` menjadi `StatefulWidget` untuk menampung status tombol switch dark mode.

3. **Academic Overview & Pengecekan AI**
   - Membuat halaman baru yang menampilkan header pengguna secara khusus serta informasi statis.
   - Merefaktor bagian grid menggunakan struktur `Row` dan `Column` yang disesuaikan secara manual melalui logika responsif.
   - Menganalisa hasil perbandingan dan verifikasi prompt AI seputar trade-off performa vs aksesibilitas.
   - Menyusun widget unit test responsif di `academic_overview_test.dart` guna menjamin kebenaran logika UI-nya.

## Catatan Tambahan
Mendapati masalah bahwa meletakkan teks panjang di dalam sumbu silang/mendatar tanpa batas dapat menekan `Expanded` menjadi terlalu sempit. Penanganan yang optimal adalah menaruh batasan jelas melalui lebar yang telah terukur.
