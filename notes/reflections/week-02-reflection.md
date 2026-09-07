# Refleksi – Minggu 2: Declarative UI & Responsive Design

**Nama:** Athaulla Hafizh  
**NIM:** 244107020030  
**Tanggal:** 7 September 2026

---

## 1. Apa perbedaan cara berpikir imperative dan declarative saat membangun UI?

- **Imperative UI**: Developer secara manual mengubah status dan properti elemen UI satu per satu ketika terjadi perubahan data (contoh: `textView.setText("Hello")` di Android SDK lama).
- **Declarative UI**: Developer mendeskripsikan bentuk UI berdasarkan state saat itu (`UI = f(state)`). Ketika state berubah, Flutter membangun ulang widget tree dan menyesuaikan tampilan secara otomatis.

---

## 2. Kapan `Expanded` membantu dan kapan penggunaannya justru menghasilkan layout error?

- **Membantu**: Saat kita ingin membagi sisa ruang kosong secara proporsional di dalam widget perata seperti `Row` atau `Column`.
- **Menghasilkan Error**: Jika ditempatkan di dalam wadah *scrollable* dengan ukuran tanpa batas (seperti `SingleChildScrollView` horizontal untuk `Row`), `Expanded` akan memicu *render flex error* karena berusaha memenuhi ruang tak terhingga.

---

## 3. Bagaimana breakpoint dan theme memengaruhi pengalaman pengguna?

- **Breakpoint**: Memastikan layout aplikasi beradaptasi dengan ukuran layar perangkat (ponsel vs tablet/desktop), mencegah UI terlihat terlalu kosong atau terhimpit.
- **Theme**: Memberikan kenyamanan visual (seperti *dark mode*) pada kondisi pencahayaan rendah dan meningkatkan aksesibilitas kontras teks.

---

## 4. Apa yang Anda verifikasi dari rekomendasi AI setelah tugas inti selesai?

Saya memverifikasi tiga hal utama dari saran AI:
1. **Tingkat Responsivitas**: Memastikan aplikasi benar-benar berpindah ke tata letak 1 kolom pada layar di bawah 700px dan 2 kolom saat di atasnya.
2. **Dampak Aksesibilitas**: Mengecek penggunaan widget `Semantics` apakah memberi kejelasan pembacaan pada *screen reader* tanpa merusak tata letak yang ada.
3. **Ketersediaan Widget**: Mengonfirmasi bahwa komponen pendukung seperti `CupertinoSwitch` dan `LayoutBuilder` beroperasi stabil tanpa masalah versi pada SDK terbaru.
