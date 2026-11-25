# Minggu 13 CI/CD & Automation

**Nama:** Athaulla Hafizh  
**NIM:** 244107020030  

---

## Tujuan

Praktikum ini mengubah pemeriksaan manual yang berulang menjadi pipeline otomatis. Setiap perubahan menjalani format, analisis statis, dan test; bila lulus, APK dan AAB dibangun lalu disimpan sebagai artefak. Versi aplikasi juga dinaikkan dan dikaitkan dengan artefak agar rilis dapat ditelusuri.

---

## Fitur Utama

| Fitur | Keterangan |
|---|---|
| Workflow CI | `.github/workflows/flutter-ci.yml` menjalankan format, analyze, test, build, dan upload artefak |
| Pemeriksaan Lokal | Perintah yang sama dijalankan sebelum push agar kegagalan tidak baru diketahui di runner |
| Build APK Release | Menghasilkan `app-release.apk` yang bisa dipasang langsung |
| Build AAB Release | Menghasilkan `app-release.aab` untuk alur distribusi Google Play |
| Upload Artefak | APK dan AAB disimpan 7 hari dan dapat diunduh dari tab Actions |
| Versioning | Versi dinaikkan dari `1.0.0+1` menjadi `1.1.0+2` mengikuti semantic versioning |
| Permission Minimum | Workflow hanya meminta `contents: read` |
| Concurrency | Run lama pada branch yang sama dibatalkan agar tidak menumpuk |
| Pemeriksaan Secret | Tidak ada keystore, `.env`, atau API key pada berkas yang dilacak |

---

## Stack Teknologi
1. Bahasa Dart 3.13.2
2. Framework Flutter SDK 3.47.2
3. Package `flutter_riverpod` 2.6.1, `go_router` 14.8.1, `dio` 5.8.0, `flutter_secure_storage` 9.2.4, `sqflite` 2.4.4, `path` 1.9.1, `intl` 0.20.3, `http` 1.2.0, `shared_preferences` 2.5.5
4. CI/CD: GitHub Actions (`actions/checkout@v4`, `subosito/flutter-action@v2`, `actions/upload-artifact@v4`)
5. Tools Android Studio, Git, Flutter CLI, `adb`
6. Perangkat: Emulator Pixel 8, Android 17 (API 37), x86_64, 1080x2400

---

## Cara Menjalankan
```bash
cd 13-week-13-ci-cd-automation

flutter pub get

flutter analyze --fatal-infos

dart format --output=none --set-exit-if-changed lib test integration_test

flutter test

flutter build apk --release

flutter build appbundle --release
```

Workflow dijalankan otomatis saat push ke `main`/`develop`, saat pull request, atau manual lewat `workflow_dispatch`. Artefak dapat diunduh dari halaman run GitHub Actions pada bagian **Artifacts**.

Keterangan versi:
1. `1.1.0` adalah versi aplikasi; fitur pengujian dan pipeline dianggap penambahan kompatibel.
2. `2` adalah build number yang wajib naik untuk setiap unggahan baru.
3. Versi pada perangkat diverifikasi lewat `adb shell dumpsys package com.example.week13_ci`.

---

## Hasil yang Dicapai

Workflow berhasil menjalankan seluruh tahap pada project ini: format nol perubahan, `flutter analyze --fatal-infos` bersih, 65 tes lulus, lalu build APK 51,05 MB dan AAB 50,21 MB. Setelah perubahan di-push ke `develop`, GitHub Actions menjalankan 7 job matriks (Week 8-14) dan semuanya sukses; job Week 13 selesai dalam 6 menit 5 detik pada run audit #41 dan menghasilkan artefak `week13-android-builds` berukuran 73,6 MB. APK release dipasang pada emulator Pixel 8 dan menampilkan `versionName=1.1.0`, `versionCode=2`. Checksum build lokal: APK `D3DEBCEC1185670DFB1D64C24336EB5A813E57C114F2C2865973C47E95BCE05A` dan AAB `13960AE4E9C7C1D44D8907C766017960B80AC18C993B8913BF7E68F24B787769`. Tidak ada material signing produksi yang dibuat; build memakai debug signing agar bisa diuji, dan itu dicatat sebagai risiko yang belum diselesaikan.

---

## Tahapan Praktikum

### Praktikum 1: Workflow Format, Analyze, dan Test

<img src="screenshots/Praktikum 1 - Workflow Flutter CI.png" width="700" alt="Workflow Flutter CI">

> **Keterangan gambar**
> - Workflow memakai `flutter-version: 3.47.2` agar hasil runner sama dengan mesin lokal.
> - `permissions: contents: read` membatasi token hanya untuk membaca kode.
> - `concurrency` membatalkan run lama pada branch yang sama sehingga runner tidak dipenuhi build usang.

<img src="screenshots/Praktikum 1 - Format Analyze Test Lokal.png" width="700" alt="Format Analyze Test Lokal">

> **Keterangan gambar**
> - Pemeriksaan lokal dijalankan sebelum push untuk menangkap kegagalan lebih awal.
> - `dart format` melaporkan 71 file diperiksa dan 0 berubah.
> - `flutter analyze --fatal-infos` bersih, dan seluruh 65 tes lulus.

### Praktikum 2: Build APK, AAB, dan Artefak

<img src="screenshots/Praktikum 2 - Build APK dan AAB Release.png" width="700" alt="Build APK dan AAB">

> **Keterangan gambar**
> - `flutter build apk --release` menghasilkan APK 51,1 MB untuk instalasi dan uji internal.
> - `flutter build appbundle --release` menghasilkan AAB 50,2 MB untuk alur Google Play.
> - Kedua build memakai signing debug karena keystore produksi tidak dibuat pada praktikum ini.

<img src="screenshots/Praktikum 2 - Artefak Android.png" width="700" alt="Artefak Android">

> **Keterangan gambar**
> - Artefak nyata tersimpan di `build/app/outputs/`: APK 51,05 MB dan AAB 50,21 MB beserta checksum SHA-256.
> - Pada GitHub Actions, `actions/upload-artifact@v4` mengunggah kedua berkas itu dengan `if-no-files-found: error`.
> - Retensi 7 hari cukup untuk peninjauan, tanpa menyimpan artefak selamanya.

### Praktikum 3: Versioning, Secrets, dan Verifikasi

<img src="screenshots/Praktikum 3 - Workflow Actions Sukses.png" width="700" alt="Workflow Actions Sukses">

> **Keterangan gambar**
> - Run audit #41 pada commit `f21a595` menjalankan 7 job matriks Week 8-14 dan semuanya sukses.
> - Job Week 13 menyelesaikan format, analyze, test, build APK/AAB, dan upload artefak dalam 6 menit 5 detik.
> - Artefak `week13-android-builds` berukuran 73,6 MB tersedia pada bagian **Artifacts**.
> - Anotasi `Node.js 20 deprecated` berasal dari action pihak ketiga, bukan kegagalan build.

<img src="screenshots/Praktikum 3 - Versi Aplikasi di Perangkat.png" width="700" alt="Versi Aplikasi di Perangkat">

> **Keterangan gambar**
> - `pubspec.yaml` mencatat `version: 1.1.0+2`.
> - `adb shell dumpsys package` membuktikan perangkat menerima `versionName=1.1.0` dan `versionCode=2`.
> - Versi dan build number ini yang harus dicantumkan pada catatan rilis.

<img src="screenshots/Praktikum 3 - Aplikasi Release di Emulator.png" width="300" alt="Aplikasi Release di Emulator"> <img src="screenshots/Praktikum 3 - Home Aplikasi Release.png" width="300" alt="Home Aplikasi Release">

> **Keterangan gambar**
> - Screenshot pertama menunjukkan halaman login build release; screenshot kedua menunjukkan Home setelah login berhasil.
> - Build release sempat gagal login karena manifest utama belum memuat izin `INTERNET`; masalah diperbaiki dengan menambahkannya ke `AndroidManifest.xml` utama, bukan hanya manifest debug.
> - Halaman Home menampilkan penanda `CI/CD & Automation - Week 13`.

<img src="screenshots/Praktikum 3 - Secrets dan Risiko.png" width="700" alt="Secrets dan Risiko">

> **Keterangan gambar**
> - Pemeriksaan nama berkas tidak menemukan keystore, `google-services.json`, `.env`, atau `key.properties`.
> - API key Gemini pada aplikasi disimpan lewat input pengguna di `flutter_secure_storage`, bukan ditanam di kode.
> - Risiko tersisa: workflow belum menandatangani APK/AAB dengan keystore produksi. Untuk rilis nyata, keystore dan password harus disimpan di GitHub Actions Secrets dan hanya dipakai pada workflow rilis terbatas.

<img src="screenshots/Praktikum 3 - Rilis v1.2.0.png" width="700" alt="Rilis v1.2.0">

> **Keterangan gambar**
> - Tag `v1.2.0` dibuat dari `main` setelah PR rilis #19 merge.
> - GitHub Release ditandai **Pre-release** karena build masih debug signing dan distribusi baru lewat ADB.
> - Rilis ini menautkan source, log CI, dan artefak APK/AAB sesuai aturan versioning Modul 13.

### Refactoring & Testing

<img src="screenshots/Refactoring - Flutter Analyze dan Test.png" width="600" alt="Flutter Analyze dan Test"> <img src="screenshots/Refactoring - Hasil Flutter Format.png" width="500" alt="Hasil Flutter Format">

> **Keterangan gambar**
> - `flutter analyze --fatal-infos` bersih tanpa isu.
> - Seluruh 65 tes lulus pada project Week 13.
> - `dart format` melaporkan nol file berubah, sehingga pemeriksaan format tidak menghalangi pipeline.

---

## Catatan Workflow

Workflow pada folder modul ini adalah salinan mandiri untuk project Week 13. Pada repository monorepo ini, workflow yang benar-benar dieksekusi GitHub berada di `.github/workflows/` pada root repository dan menjalankan project Week 8 sampai Week 14. Keduanya menjalankan format, analyze, dan test. Workflow mandiri memakai `--fatal-infos` dan format `.`; CI root memakai `flutter analyze` dan format `lib test` agar tetap kompatibel dengan Week 8-11. Yang berbeda juga `working-directory`.

| Tahap | Perintah | Gagal berarti |
|---|---|---|
| Format | `dart format --output=none --set-exit-if-changed .` | Ada berkas yang belum diformat |
| Analisis | `flutter analyze --fatal-infos` | Ada error, warning, atau info linter |
| Test | `flutter test --coverage` | Ada perilaku yang tidak sesuai |
| Build APK | `flutter build apk --release` | Konfigurasi Android rusak |
| Build AAB | `flutter build appbundle --release` | Konfigurasi bundling rusak |
| Upload | `actions/upload-artifact@v4` | Artefak tidak ditemukan |

---

## Risiko Keamanan yang Belum Ditangani

1. **Signing produksi.** Build memakai debug key. Untuk Play Store, keystore produksi harus dibuat dan disimpan di luar repository.
2. **Secret di log.** Workflow ini tidak mencetak secret, tetapi penambahan langkah signing nanti harus memakai `secrets.*` dan tidak boleh `echo`.
3. **Dependensi pihak ketiga.** `subosito/flutter-action` dan `actions/*` dipakai dengan tag mayor, bukan commit SHA. Untuk keamanan rantai pasok, versi dapat dipatok ke SHA.
4. **`--dart-define` bukan secret.** Nilai yang dikompilasi ke aplikasi dapat diekstrak; jangan pernah memakai `--dart-define` untuk password atau token.

---

## AI Prompt Challenge

```text
Konteks: repository Flutter monorepo berisi project per minggu. CI sekarang
menjalankan analyze, format, dan test untuk Week 8-11. Saya menambah Week 12-14.

Tugas: tinjau rancangan workflow berikut dan tunjukkan risiko nyata:
- trigger push main/develop, pull_request, workflow_dispatch
- permissions contents: read
- concurrency dengan cancel-in-progress
- build APK dan AAB, upload artifact 7 hari

Batasan: jangan menyarankan menambah layanan berbayar, jangan mengubah
arsitektur aplikasi, dan jangan menyarankan menyimpan keystore di repository.
```

### Ringkasan Saran AI dan Keputusan

| Saran AI | Keputusan | Alasan Teknis |
|---|---|---|
| Tambahkan `permissions: contents: read` | **Diterima** | Token tidak perlu izin tulis untuk membaca kode |
| Tambahkan `concurrency` | **Diterima** | Mencegah build usang menumpuk dan menghabiskan kuota |
| Upload APK dan AAB sebagai artefak | **Diterima** | Memudahkan peninjauan tanpa membangun ulang |
| Pakai `flutter build apk --split-per-abi` | **Ditolak** | Menambah jumlah artefak tanpa kebutuhan; ukuran bukan masalah utama |
| Simpan keystore sebagai base64 di repository | **Ditolak** | Melanggar aturan keamanan; gunakan Actions Secrets |
| Jalankan `flutter test` di setiap matrix project | **Diterima** | Regresi harus terdeteksi pada project yang berubah |
| Hapus `dart format` agar pipeline cepat | **Ditolak** | Format adalah pemeriksaan termurah dan paling sering mencegah diff berisik |

Saran yang diterima diuji dengan menjalankan perintah yang sama secara lokal. Klaim AI bahwa "artifact upload otomatis menandatangani APK" salah; signing tetap harus dikonfigurasi terpisah.

---

## Refleksi

**1. Masalah apa yang ditemukan otomatis sebelum perubahan di-merge?**

Format yang tidak konsisten, error analisis statis, dan regresi perilaku yang tertangkap 65 tes. Yang paling nyata pada praktikum ini adalah build release yang gagal login karena izin `INTERNET` hanya ada di manifest debug. Masalah itu tidak terlihat dari `flutter test`, tetapi terlihat saat APK release diuji di perangkat. Artinya pipeline tetap perlu ditambah uji asap pada build release.

**2. Informasi apa yang Anda butuhkan untuk menyelidiki build yang gagal?**

Nama job dan step yang gagal, commit SHA, versi Flutter, log perintah, dan artefak bila ada. Untuk kegagalan perangkat, saya juga butuh `adb logcat` dan versi aplikasi yang terpasang. Tanpa commit SHA, artefak tidak bisa dihubungkan ke source yang tepat.

**3. Bagian mana yang masih perlu persetujuan atau pemeriksaan manual sebelum rilis?**

Signing, isi catatan rilis, izin aplikasi, dan uji asap pada perangkat. Pipeline ini membuktikan kode dapat dibangun, bukan bahwa aplikasi layak dirilis. Pemeriksaan manual juga diperlukan untuk memastikan tidak ada data pribadi yang tercetak di log.

---

## Referensi

- [Codelab Minggu 13: CI/CD dan Otomatisasi](https://jti-polinema.github.io/flutter-codelab/13-minggu-13-ci-cd-automation/index.html)
- [Slide Minggu 13: CI/CD dan Otomatisasi](https://jti-polinema.github.io/flutter-codelab/00-slides/Week_13_CICD_Automation.html)
- [GitHub Actions documentation](https://docs.github.com/actions)
- [Continuous delivery with Flutter](https://docs.flutter.dev/deployment/cd)
- [Build and release an Android app](https://docs.flutter.dev/deployment/android)
- [Using secrets in GitHub Actions](https://docs.github.com/actions/security-guides/using-secrets-in-github-actions)
- [Semantic Versioning](https://semver.org/)
