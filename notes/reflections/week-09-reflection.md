# Refleksi - Minggu 9: AI-Assisted Development / Vibe Coding

**Nama:** Athaulla Hafizh  
**NIM:** 244107020030  
**Tanggal:** 2 November 2026

---

## 1. Satu halusinasi AI apa yang Anda temukan dan bagaimana membuktikannya?
AI mengklaim `String.contains` sudah cukup untuk pencarian tanpa memedulikan huruf besar dan kecil. Klaim itu salah. Saya membuktikannya dengan menulis test yang mencari `belanja` pada daftar berisi `Belanja Bulanan`; test tersebut gagal dengan `Expected: length of 2, Actual: []`. Setelah `toLowerCase()` ditambahkan pada kedua sisi, test menjadi hijau. Bukti visualnya tersedia pada `screenshots/Praktikum 2 - Filter Case-Insensitive.png`.

## 2. Prompt mana yang paling membantu dan apa yang Anda ubah?
Prompt yang paling membantu adalah versi lima slot dengan batas eksplisit "jangan ubah arsitektur, maksimal 80 baris, jangan panggil SQLite dari widget". Batas itu membuat AI tidak melebar ke fitur lain. Yang saya ubah adalah bagian tugas: awalnya hanya "pencarian judul", lalu saya perluas menjadi "judul dan isi" setelah uji manual menunjukkan pencarian isi lebih berguna.

## 3. Satu refactor apa yang Anda lakukan pada kode AI?
Saya memindahkan fungsi filter dari `notes_page.dart` ke `domain/usecases/search_notes.dart`. Dampaknya besar: aturan pencarian kini bisa diuji dengan enam unit test tanpa membangun widget, dan file halaman kembali fokus pada tampilan. Saya juga mengganti variabel lokal di dalam `build` menjadi `filteredNotesProvider` agar state kata kunci punya satu sumber kebenaran.

## 4. Keputusan terima/tolak mana yang paling sulit?
Keputusan tersulit adalah memperluas pencarian ke `body`. AI hanya mengusulkan judul sesuai instruksi awal, dan instruksi saya juga menyebut judul. Setelah mencoba mencari kata "telur" pada catatan `Belanja Bulanan`, tidak ada hasil padahal kata itu ada di isi. Saya memilih memperluas cakupan karena lebih sesuai harapan pengguna, sambil menjaga `SearchNotes` tetap sederhana dan tetap bisa diuji.
