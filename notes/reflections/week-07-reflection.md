# Refleksi - Minggu 7: Clean Architecture

**Nama:** Athaulla Hafizh  
**NIM:** 244107020030  
**Tanggal:** 8 Oktober 2026

---

## 1. Mengapa interface repository harus tinggal di domain, bukan di data? Apa yang rusak bila dibalik?
Interface (*abstract class*) hidup di Domain sebagai kontrak (aturan). Jika Interface dipindah ke Data, maka Domain (Use Case) harus mengimpor file dari layer Data agar mengetahui tipe balikan datanya. Ini melanggar *Dependency Rule* di mana Domain tidak boleh tahu-menahu soal Data layer. Selain itu, ini akan menghambat kemampuan melakukan *mocking* untuk *unit testing*.

## 2. Kapan use case benar-benar dibutuhkan, dan kapan repository langsung ke notifier sudah cukup?
*Use Case* sangat penting saat sebuah proses melibatkan lebih dari 1 repository (misalnya: *fetch* dari internet API, lalu simpan datanya ke SQLite lokal) atau jika terdapat perhitungan matematis dan validasi bisnis yang kompleks. Sebaliknya, *Repository* langsung ditembak melalui *Notifier* cukup bila operasinya hanya sekadar "CRUD satu-baris" murni (baca langsung tampilkan) tanpa manipulasi apa-apa.

## 3. Apa biaya over-engineering (use case per CRUD satu-baris) bagi tim kecil? Kapan biayanya sepadan?
Bagi tim kecil, membuat Use Case kosong hanya untuk meneruskan pemanggilan satu baris fungsi Repository akan menguras waktu, menambah ribuan *boilerplate code*, dan membingungkan rekrutan baru. Biayanya akan sepadan hanya pada proyek *Enterprise* raksasa yang mungkin harus bisa me-*swap* framework (misal dari React Native ke Flutter tapi logic Dart tetap) dan memfasilitasi tim *Quality Assurance* independen.

## 4. Bagian mana dari usulan AI yang Anda tolak atau sederhanakan, dan mengapa?
Pada awal draf struktur (terekam pada `docs/AI_Challenge.md`), AI mengusulkan pemakaian _package_ fungsional `dartz` agar fungsi mereturn `Either<Failure, T>`. Saya menolaknya secara tegas dan menggantinya dengan fitur bawaan Dart 3.0 yaitu *Records* (`({T? data, Failure? failure})`) dipadukan dengan `AsyncValue.guard` dari Riverpod. Langkah ini menekan ketergantungan pada *library* pihak ketiga sambil mendapatkan hasil yang identik secara fungsional (bebas lemparan *exception* tak terduga).
