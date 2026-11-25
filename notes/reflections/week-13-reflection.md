# Refleksi - Minggu 13: CI/CD & Automation

**Nama:** Athaulla Hafizh  
**NIM:** 244107020030  
**Tanggal:** 13 November 2026

---

## 1. Masalah apa yang ditemukan otomatis sebelum perubahan di-merge?
Format yang tidak konsisten, error analisis statis, dan regresi perilaku yang tertangkap 65 tes. Yang paling nyata pada praktikum ini adalah build release yang gagal login karena izin `INTERNET` hanya ada di manifest debug. Masalah itu tidak terlihat dari `flutter test`, tetapi terlihat saat APK release diuji di perangkat. Artinya pipeline tetap perlu ditambah uji asap pada build release.

## 2. Informasi apa yang Anda butuhkan untuk menyelidiki build yang gagal?
Nama job dan step yang gagal, commit SHA, versi Flutter, log perintah, dan artefak bila ada. Untuk kegagalan perangkat, saya juga butuh `adb logcat` dan versi aplikasi yang terpasang. Tanpa commit SHA, artefak tidak bisa dihubungkan ke source yang tepat.

## 3. Bagian mana yang masih perlu persetujuan atau pemeriksaan manual sebelum rilis?
Signing, isi catatan rilis, izin aplikasi, dan uji asap pada perangkat. Pipeline ini membuktikan kode dapat dibangun, bukan bahwa aplikasi layak dirilis. Pemeriksaan manual juga diperlukan untuk memastikan tidak ada data pribadi yang tercetak di log.
