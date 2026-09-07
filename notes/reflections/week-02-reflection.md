# Refleksi - Week 2

1. **Apa perbedaan cara berpikir imperative dan declarative saat membangun UI?**
   Pendekatan imperative mengharuskan developer mengubah UI secara manual langkah demi langkah setiap kali state/data berubah (misal: `textView.setText("Baru")`). Sedangkan pendekatan declarative pada Flutter bersifat reaktif; developer mendeskripsikan *blueprint* UI untuk setiap kemungkinan state (`UI = f(state)`). Ketika state berubah, Flutter secara otomatis merender ulang (rebuild) bagian widget tree yang terdampak tanpa perlu intervensi manual.

2. **Kapan `Expanded` membantu dan kapan penggunaannya justru menghasilkan layout error?**
   `Expanded` sangat membantu saat kita ingin membagi sisa ruang kosong secara proporsional dalam `Row` atau `Column`. Namun, `Expanded` akan menyebabkan *layout error* (overflow atau constraint tidak terbatas) jika ditempatkan di dalam widget scroll (seperti `SingleChildScrollView` horizontal untuk `Row` atau vertikal untuk `Column`) atau di dalam parent yang tidak memberikan batasan ukuran secara tegas.

3. **Bagaimana breakpoint dan theme memengaruhi pengalaman pengguna?**
   Breakpoint memastikan bahwa layout aplikasi beradaptasi dengan ukuran layar perangkat (misal: ponsel vs tablet/desktop), sehingga mencegah UI terlihat terlalu kosong di layar besar atau terhimpit di layar kecil. Theme (khususnya *dark mode*) memengaruhi kenyamanan visual pengguna saat berinteraksi di kondisi pencahayaan rendah, mengurangi kelelahan mata, dan meningkatkan aksesibilitas kontras teks.

4. **Apa yang Anda verifikasi dari rekomendasi AI setelah tugas inti selesai?**
   Saya memverifikasi tiga hal utama dari saran AI:
   - **Tingkat Responsivitas**: Memastikan aplikasi benar-benar berpindah ke tata letak 1 kolom pada layar di bawah 700px dan 2 kolom saat di atasnya.
   - **Dampak Aksesibilitas**: Mengecek penggunaan widget `Semantics` apakah memberi kejelasan pembacaan pada *screen reader* tanpa merusak tata letak yang ada.
   - **Ketersediaan Widget**: Mengonfirmasi bahwa komponen pendukung seperti `CupertinoSwitch` dan `LayoutBuilder` beroperasi stabil tanpa masalah versi pada SDK terbaru.
