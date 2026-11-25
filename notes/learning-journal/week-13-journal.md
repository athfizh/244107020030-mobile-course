# Learning Journal - Semester Mobile Development

**Athaulla Hafizh | NIM: 244107020030**

---

## Minggu 13 - CI/CD & Automation

**Tanggal:** 13 November 2026

### Yang Dipelajari
- Alur CI/CD dari commit sampai artefak: checkout, setup Flutter, format, analyze, test, build, upload.
- Perbedaan `pull_request`, `push`, dan `workflow_dispatch` serta kapan memakainya.
- `permissions: contents: read` dan `concurrency` untuk membatasi akses dan run usang.
- `actions/upload-artifact@v4` dan arti `if-no-files-found: error`.
- Semantic versioning `1.1.0+2` serta hubungan versi, build number, dan artefak.
- Batasan secret: `--dart-define` bukan tempat menyimpan password.

### Yang Dikerjakan
- [x] Menyalin project Minggu 12 menjadi `week13_ci` dengan versi `1.1.0+2`.
- [x] Membuat `.github/workflows/flutter-ci.yml` untuk format, analyze, test, build, dan upload.
- [x] Menjalankan perintah yang sama secara lokal sebelum push.
- [x] Membangun APK release 51,05 MB dan AAB release 50,21 MB.
- [x] Memasang APK release di emulator dan memverifikasi `versionName=1.1.0`, `versionCode=2`.
- [x] Memeriksa tidak ada keystore, `.env`, atau API key pada berkas yang dilacak.
- [x] Menambahkan Week 12-14 ke matriks CI repository.
- [x] Menambahkan langkah build dan upload artefak untuk Week 13 pada CI.
- [x] Push ke `develop` dan memverifikasi run #35: 7 job matriks sukses, artefak 73,6 MB.

### Kendala & Solusi
- **Masalah:** Build release berhasil dipasang, tetapi login gagal tanpa pesan yang jelas.
- **Solusi:** `adb logcat` menunjukkan tidak ada koneksi; ternyata izin `INTERNET` hanya ada di manifest debug. Izin ditambahkan ke `AndroidManifest.xml` utama, lalu build diuji ulang.
- **Masalah:** Workflow tidak dapat dibuktikan berjalan sebelum perubahan di-push.
- **Solusi:** Pemeriksaan lokal dijalankan lebih dulu dengan perintah identik; setelah push ke `develop`, run #35 sukses pada 7 job dan artefak `week13-android-builds` (73,6 MB) dapat diunduh.
- **Masalah:** Build pertama lambat dan memakan RAM karena Gradle memakai 8 GB heap.
- **Solusi:** Heap diturunkan ke 3 GB, worker dibatasi 4, dan emulator dijalankan headless.
- **Masalah:** Artefak besar tidak boleh masuk repository.
- **Solusi:** Hanya checksum, ukuran, dan screenshot yang dicatat; berkas APK/AAB tetap di `build/` yang di-ignore.

### Key Takeaway
> Pipeline yang berguna adalah pipeline yang menjalankan perintah yang sama dengan mesin lokal. CI tidak memperbaiki kode; ia hanya memastikan pemeriksaan yang sudah benar dijalankan pada setiap perubahan, tanpa bisa dilewati.
