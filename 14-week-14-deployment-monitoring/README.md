# Minggu 14 Deployment & Monitoring

**Nama:** Athaulla Hafizh  
**NIM:** 244107020030  

---

## Tujuan

Praktikum ini membawa project hasil Minggu 13 ke tahap kandidat rilis: versi dinaikkan, AAB dan APK release dibangun, build dipasang pada perangkat uji, lalu Crashlytics dan Analytics dikonfigurasi. Fokusnya adalah bukti yang bisa ditelusuri, bukan klaim bahwa aplikasi sudah siap publik.

---

## Fitur Utama

| Fitur | Keterangan |
|---|---|
| Kandidat Rilis | Versi `1.2.0+3` dengan catatan perubahan dari Minggu 13 |
| Build Release | APK 52,23 MB dan AAB 52,21 MB dengan checksum SHA-256 |
| Distribusi Privat | APK dipasang pada emulator Pixel 8 melalui `adb install` |
| Distribusi App Distribution | Workflow `distribute-beta` siap dijalankan untuk kirim APK ke grup tester |
| Firebase Crashlytics | Error fatal dan non-fatal dicatat, termasuk `FlutterError.onError` |
| Firebase Analytics | Event `beta_feedback_sent` hanya membawa `screen_name` |
| Halaman Umpan Balik Beta | Memicu event dan error uji tanpa data pribadi |
| Verifikasi Dashboard | Crashlytics dan Analytics DebugView diperiksa langsung di Firebase Console |
| Fallback Lokal | Bila Firebase gagal init, aplikasi tetap jalan dan mencatat ke logcat |
| Release Report | `docs/release-report.md` berisi bukti, temuan, keputusan, dan langkah berikutnya |
| Analisis Log dengan AI | `docs/ai-log-analysis.md` memakai log yang sudah disamarkan |

---

## Stack Teknologi
1. Bahasa Dart 3.13.2
2. Framework Flutter SDK 3.47.2
3. Package `flutter_riverpod` 2.6.1, `go_router` 14.8.1, `dio` 5.8.0, `flutter_secure_storage` 9.2.4, `sqflite` 2.4.4, `path` 1.9.1, `intl` 0.20.3, `http` 1.2.0, `shared_preferences` 2.5.5
4. Firebase `firebase_core` 5.1.0, `firebase_analytics` 13.1.0, `firebase_crashlytics` 6.1.0
5. Tools Android Studio, Git, Flutter CLI, `adb`
6. Perangkat: Emulator Pixel 8, Android 17 (API 37), x86_64, 1080x2400

---

## Cara Menjalankan
```bash
cd 14-week-14-deployment-monitoring

flutter pub get

flutter analyze --fatal-infos

flutter test

flutter build appbundle --release

flutter build apk --release
```

Memasang kandidat beta pada perangkat uji:
```bash
adb install -r build/app/outputs/flutter-apk/app-release.apk
adb shell am start -n com.example.week6_auth_fcm/com.example.week14_deploy.MainActivity
```

Keterangan konfigurasi:
1. `lib/firebase_options.dart` memuat konfigurasi klien project `campus-notify-20030`.
2. `firebase/google-services.json` disalin dari Minggu 6 dan dipakai plugin Gradle.
3. `applicationId` disamakan dengan aplikasi yang terdaftar di Firebase, yaitu `com.example.week6_auth_fcm`.
4. Keystore, password, dan token tidak ada di repository.
5. `applicationId` sengaja sama dengan aplikasi Minggu 6 agar konfigurasi Firebase yang sudah terdaftar berlaku; memasang build ini akan menggantikan aplikasi Minggu 6 pada perangkat yang sama.
6. Langkah lengkap untuk membangun ulang folder Android dan Firebase dari clone baru ada di [docs/firebase-setup.md](docs/firebase-setup.md).
5. Untuk build release dari clone baru, tambahkan `<uses-permission android:name="android.permission.INTERNET"/>` pada `android/app/src/main/AndroidManifest.xml`; manifest debug sudah memuatnya, manifest release tidak.

---

## Hasil yang Dicapai

Kandidat `1.2.0+3` berhasil dibangun dan dipasang pada emulator. Firebase aktif dan terverifikasi lewat logcat: `FirebaseApp initialization successful`, event `beta_feedback_sent` masuk pipeline Analytics dan upload Analytics berhasil dengan HTTP 204. Error non-fatal terverifikasi di dashboard Crashlytics: issue `Monitoring.recordTestError` pada versi `1.2.0 (3)`, 2 event / 2 installation ID, dengan stack trace `monitoring.dart:78`. Seluruh 65 tes lulus, integration test login sampai catatan juga lulus di emulator, `flutter analyze --fatal-infos` bersih, dan format nol perubahan. Dashboard Crashlytics dan Analytics sudah ditinjau langsung; keputusan tetap menahan rilis publik karena signing, Play Console, dan sampel tester masih kurang.

---

## Artefak dan Versi

| Item | Nilai |
|---|---|
| Versi aplikasi | `1.2.0` |
| Build number | `3` |
| APK | 52,23 MB |
| AAB | 52,21 MB |
| SHA-256 APK | `D55641F8D95B945C3F494863F52D7DB72CFE67C354352883B4E9BC88E6EEDE71` |
| SHA-256 AAB | `249E68EC69D8A8A6ED12B5749A111B0C24A44E43EBF566E9A7D55D20C96ECC88` |
| Perangkat uji | Pixel 8, Android 17 (API 37) |

Artefak build tidak di-commit. Angka dan checksum di atas dihasilkan dari build pada 25 November 2026.

---

## Tahapan Praktikum

### Praktikum 1: Kandidat Rilis dan Build AAB

<img src="screenshots/Praktikum 1 - Versi Kandidat Beta.png" width="700" alt="Versi Kandidat Beta">

> **Keterangan gambar**
> - Versi dinaikkan dari `1.1.0+2` menjadi `1.2.0+3`.
> - Kenaikan minor dipakai karena ada fitur baru (monitoring beta), dan build number naik untuk unggahan baru.
> - Commit yang tampil adalah `dacca92`, source yang dipakai untuk build akhir.

<img src="screenshots/Praktikum 1 - Build AAB Release.png" width="700" alt="Build AAB Release">

> **Keterangan gambar**
> - `flutter build appbundle --release` menghasilkan AAB 52,2 MB.
> - `flutter build apk --release` menghasilkan APK 52,2 MB untuk instalasi langsung.
> - Keduanya memakai debug signing; ini cukup untuk uji internal, tetapi belum layak untuk Play Store.

### Praktikum 2: Distribusi Beta ke Perangkat Uji

<img src="screenshots/Praktikum 2 - Integration Test Beta.png" width="700" alt="Integration Test Beta">

> **Keterangan gambar**
> - Integration test dijalankan pada source final `dacca92` di emulator Pixel 8.
> - Alur login sampai catatan tersimpan lulus (`All tests passed!`) tanpa crash.
> - Ini bukti tambahan bahwa perbaikan teks status tidak merusak alur utama.

<img src="screenshots/Praktikum 2 - Instalasi Build Beta.png" width="700" alt="Instalasi Build Beta">

> **Keterangan gambar**
> - APK dipasang dengan `adb install -r` pada emulator Pixel 8.
> - `dumpsys package` membuktikan perangkat menerima `versionName=1.2.0` dan `versionCode=3`.
> - Cara ini dipakai sebagai bukti instalasi lokal. Jalur resmi distribusi beta, Firebase App Distribution, disiapkan lewat workflow `distribute-beta` (lihat `docs/firebase-setup.md` bagian 6).

<img src="screenshots/Praktikum 2 - Aplikasi Beta di Emulator.png" width="300" alt="Aplikasi Beta di Emulator">

> **Keterangan gambar**
> - Build release dipasang, lalu login berhasil dan menampilkan Home (screenshot diambil setelah aplikasi dipastikan foreground).
> - Halaman Home menampilkan penanda `Deployment & Monitoring - Week 14`.
> - Ikon umpan balik di kanan atas membuka halaman pengujian telemetri.

### Praktikum 3: Crashlytics, Analytics, dan Verifikasi

<img src="screenshots/Praktikum 3 - Firebase Terinisialisasi.png" width="700" alt="Firebase Terinisialisasi">

> **Keterangan gambar**
> - `FirebaseApp initialization successful` muncul pada build release.
> - Crashlytics 21.1.0 terinisialisasi untuk `com.example.week6_auth_fcm`.
> - Inisialisasi berhasil karena plugin `com.google.gms.google-services` dan `google-services.json` sudah dipasang.

<img src="screenshots/Praktikum 3 - Halaman Umpan Balik Beta.png" width="300" alt="Halaman Umpan Balik Beta">

> **Keterangan gambar**
> - Status monitoring ditampilkan jujur: `Firebase aktif (campus-notify-20030)`.
> - Halaman ini tidak mengirim email, token, atau isi catatan; hanya nama event, nama layar, dan error uji.
> - Tombol **Uji Error Non-Fatal** memicu error buatan untuk membuktikan Crashlytics mencatat dan mengantrekan laporan.

<img src="screenshots/Praktikum 3 - Event Beta Dikirim.png" width="300" alt="Event Beta Dikirim">

> **Keterangan gambar**
> - Snackbar menegaskan event dikirim tanpa data pribadi.
> - Event yang dikirim bernama `beta_feedback_sent` dengan parameter `screen_name=beta_feedback_page`.

<img src="screenshots/Praktikum 3 - Error Non Fatal Diantrekan di Aplikasi.png" width="300" alt="Error Non Fatal Diantrekan di Aplikasi">

> **Keterangan gambar**
> - Snackbar menegaskan error non-fatal diantrekan ke Crashlytics, bukan diklaim sudah terkirim.
> - Error yang diproses adalah error buatan `Uji error non-fatal Week 14` tanpa data pengguna.

<img src="screenshots/Praktikum 3 - Event Analytics Terkirim.png" width="700" alt="Event Analytics Terkirim">

> **Keterangan gambar**
> - Log `FA-SVC` menampilkan `Logging event: origin=app,name=beta_feedback_sent`.
> - Parameter yang tercatat hanya `screen_name=beta_feedback_page`.
> - Tidak ada email, token, atau isi catatan pada event.
> - Baris `Network upload successful ... 204` adalah bukti upload Analytics, bukan Crashlytics.

<img src="screenshots/Praktikum 3 - Error Non Fatal Diantrekan.png" width="700" alt="Error Non Fatal Diantrekan">

> **Keterangan gambar**
> - Crashlytics mencatat `Persisting non-fatal event`, lalu `successfully enqueued to DataTransport` pada build uji `1.2.0+3`.
> - Gambar ini menggabungkan dua cuplikan logcat dari build yang sama: event non-fatal dan antrean DataTransport.
> - Report diantrekan ke DataTransport, lalu berkas report lokal dihapus. Upload final Crashlytics tidak muncul di log, jadi statusnya **diantrekan**, bukan **terkirim**.

### Praktikum 4: Verifikasi Dashboard dan Triage

<img src="screenshots/Praktikum 4 - Dashboard Crashlytics.png" width="700" alt="Dashboard Crashlytics">

> **Keterangan gambar**
> - Dashboard Crashlytics menampilkan release `1.2.0 (3)` dan 1 active user.
> - Non-fatals berjumlah 2 dengan 2 users; crash-free 100% pada sampel sekecil ini belum bermakna statistik.
> - Angka non-fatal tampil di panel Trends karena filter masih `Event type = "Crashes" and 1 more`.

<img src="screenshots/Praktikum 4 - Stack Trace Crashlytics.png" width="700" alt="Stack Trace Crashlytics">

> **Keterangan gambar**
> - Issue `Monitoring.recordTestError` tercatat sebagai non-fatal pada versi `1.2.0 (3)`.
> - Stack trace menunjuk `monitoring.dart:78` lalu `beta_feedback_page.dart:33`, sesuai tombol **Uji Error Non-Fatal**.
> - Ini membuktikan report yang diantrekan di logcat benar-benar diterima Crashlytics.

<img src="screenshots/Praktikum 4 - Dashboard Analytics.png" width="700" alt="Dashboard Analytics">

> **Keterangan gambar**
> - Analytics DebugView menampilkan event `beta_feedback_sent` secara real-time.
> - Event dikirim dari build release dengan `debug.firebase.analytics.app` aktif.
> - Yang tampil hanya nama event; tidak ada email, token, atau isi catatan.

<img src="screenshots/Praktikum 4 - Verifikasi Telemetri.png" width="700" alt="Verifikasi Telemetri">

> **Keterangan gambar**
> - Ringkasan logcat: event Analytics, upload HTTP 204, dan antrean Crashlytics.
> - Dashboard sudah dikonfirmasi terpisah; logcat tetap disimpan sebagai bukti teknis.
> - HTTP 204 berasal dari `FA-SVC` (Analytics), sedangkan Crashlytics dibuktikan lewat dashboard.

<img src="screenshots/Praktikum 4 - Triage Rilis.png" width="700" alt="Triage Rilis">

> **Keterangan gambar**
> - Alur utama release lulus di emulator.
> - Analytics dan Crashlytics terverifikasi di dashboard, bukan hanya di logcat.
> - Keputusan: lanjutkan beta internal dengan syarat, tahan rilis publik.

<img src="screenshots/Praktikum 4 - Release Report.png" width="700" alt="Release Report">

> **Keterangan gambar**
> - `docs/release-report.md` memuat artefak, checksum, hasil pemeriksaan, temuan, keputusan, dan langkah berikutnya.
> - Setiap temuan punya keputusan eksplisit: diperbaiki, diterima, atau ditahan.
> - Keterbatasan ditulis apa adanya; dashboard sudah diverifikasi, Play Console dan signing belum.

### Refactoring & Testing

<img src="screenshots/Refactoring - Flutter Analyze dan Test.png" width="600" alt="Flutter Analyze dan Test"> <img src="screenshots/Refactoring - Hasil Flutter Format.png" width="500" alt="Hasil Flutter Format">

> **Keterangan gambar**
> - `flutter analyze --fatal-infos` bersih tanpa isu.
> - Seluruh 65 tes lulus pada project Week 14.
> - `dart format` melaporkan nol file berubah.

---

## Rilis

| Item | Nilai |
|---|---|
| PR rilis | #19 (`develop` -> `main`) |
| Merge commit | `0eb842d` |
| Tag | `v1.2.0` |
| GitHub Release | Pre-release `Week 14 Beta 1.2.0+3` |
| Issue tertutup | #1 dan #2 otomatis lewat PR |
| Check CI PR | 14 check sukses |
| Artefak | APK 52,23 MB dan AAB 52,21 MB terlampir di GitHub Release |

Rilis ditandai **pre-release** karena build masih memakai debug signing dan distribusi baru lewat ADB. Detail ada di [`docs/release-report.md`](docs/release-report.md) bagian 12.

---

## Catatan Implementasi

| Berkas | Peran |
|---|---|
| `lib/core/monitoring.dart` | Inisialisasi Firebase, event Analytics, error Crashlytics, fallback lokal |
| `lib/firebase_options.dart` | Konfigurasi klien Firebase untuk Android |
| `lib/features/beta/presentation/pages/beta_feedback_page.dart` | Halaman uji telemetri tanpa data sensitif |
| `firebase/google-services.json` | Konfigurasi Google Services untuk build Android |
| `docs/release-report.md` | Laporan rilis lengkap |
| `docs/ai-log-analysis.md` | Catatan penggunaan AI untuk membaca log |

Alur inisialisasi:

```text
main()
  -> WidgetsFlutterBinding.ensureInitialized()
  -> Monitoring.init()
       -> Firebase.initializeApp(firebase_options)
       -> setCrashlyticsCollectionEnabled(true)
       -> FlutterError.onError = recordFlutterFatalError
       -> PlatformDispatcher.onError = recordError(fatal: true)
  -> runApp(ProviderScope(MyApp))
```

Bila `Firebase.initializeApp` gagal, `Monitoring.enabled` bernilai false, status berubah menjadi **Mode lokal**, dan aplikasi tetap dapat dipakai.

---

## Risiko dan Keterbatasan

1. **Sampel dashboard masih kecil.** Dashboard sudah diverifikasi, tetapi hanya 1 active user dan 2 event non-fatal dari 2 installation ID. Angka itu belum cukup untuk menyimpulkan kestabilan aplikasi secara umum.
2. **Distribusi App Distribution belum dijalankan.** Workflow `distribute-beta` sudah disiapkan, tetapi masih menunggu grup tester dan secret service account diaktifkan; ADB install dipakai sebagai bukti instalasi lokal.
3. **Signing debug.** APK/AAB belum layak untuk Play Store.
4. **Project Firebase dipakai bersama Minggu 6.** Data telemetry masuk ke project yang sama.
5. **Symbol native belum diunggah.** Crashlytics mencatat laporan Dart, tetapi mapping native belum dikonfigurasi.

---

## AI Prompt Challenge

Prompt untuk menganalisis log rilis beta sudah disamarkan dan dicatat lengkap di [`docs/ai-log-analysis.md`](docs/ai-log-analysis.md).

### Ringkasan Saran AI dan Keputusan

| Saran AI | Keputusan | Alasan Teknis |
|---|---|---|
| `enqueued` belum berarti `uploaded` | **Diterima** | HTTP 204 adalah upload Analytics; Crashlytics dibuktikan lewat dashboard |
| Cek dashboard sebelum memperluas beta | **Diterima** | Dashboard menampilkan `Monitoring.recordTestError` dan `beta_feedback_sent` |
| Hitung crash-free rate dari logcat | **Ditolak** | Log satu perangkat tidak mewakili populasi |
| Kirim `user_id` untuk analisis | **Ditolak** | Melanggar minimalisasi data |
| Tambahkan event untuk setiap layar | **Ditolak** | Menambah noise dan risiko data pribadi tanpa pertanyaan yang jelas |
| Simpan log mentah di repository | **Ditolak** | Log dapat memuat identifier perangkat |

---

## Refleksi

**1. Bukti apa yang diperlukan sebelum memperluas distribusi beta?**

Bukti bahwa build yang sama sudah diuji pada beberapa perangkat, tidak ada crash fatal dalam 24 jam, dashboard menunjukkan crash-free users yang tinggi pada sampel yang memadai, dan tidak ada temuan yang menghalangi alur utama. Untuk praktikum ini, dashboard sudah menunjukkan crash-free 100%, tetapi hanya dari 1 active user dan 2 event; itu cukup untuk uji internal, belum untuk memperluas.

**2. Bagaimana Anda memutuskan untuk menahan atau melanjutkan rilis?**

Saya menahan perluasan karena tiga syarat belum terpenuhi: signing produksi, Play Console, dan tester eksternal. Dashboard sudah saya tinjau: Crashlytics menerima issue `Monitoring.recordTestError` dan Analytics menerima `beta_feedback_sent`. Namun sampelnya baru 1 active user dan 2 event, jadi belum cukup untuk memperluas beta. Keputusan ini dicatat eksplisit di `docs/release-report.md`.

**3. Data apa yang tidak perlu dikirim ke layanan monitoring?**

Email, token, isi catatan, riwayat chat, NIK, nomor HP, dan identifier perangkat yang tidak diperlukan. Event `beta_feedback_sent` hanya mengirim nama event dan nama layar. Untuk analisis AI, log disamarkan lebih dulu dengan menghapus app ID, installation ID, session ID, dan timestamp.

---

## Referensi

- [Codelab Minggu 14: Deployment dan Monitoring](https://jti-polinema.github.io/flutter-codelab/14-minggu-14-deployment-monitoring/index.html)
- [Slide Minggu 14: Deployment dan Monitoring](https://jti-polinema.github.io/flutter-codelab/00-slides/Week_14_Deployment_Monitoring.html)
- [Flutter: Build and release an Android app](https://docs.flutter.dev/deployment/android)
- [Google Play: Internal testing](https://support.google.com/googleplay/android-developer/answer/9845334)
- [Firebase Crashlytics for Flutter](https://firebase.google.com/docs/crashlytics/flutter/get-started)
- [Firebase Analytics for Flutter](https://firebase.google.com/docs/analytics/get-started?platform=flutter)
- [Firebase App Distribution](https://firebase.google.com/docs/app-distribution)
