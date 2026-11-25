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
| Firebase Crashlytics | Error fatal dan non-fatal dicatat, termasuk `FlutterError.onError` |
| Firebase Analytics | Event `beta_feedback_sent` hanya membawa `screen_name` |
| Halaman Umpan Balik Beta | Memicu event dan error uji tanpa data pribadi |
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
5. Langkah lengkap untuk membangun ulang folder Android dan Firebase dari clone baru ada di [docs/firebase-setup.md](docs/firebase-setup.md).
5. Untuk build release dari clone baru, tambahkan `<uses-permission android:name="android.permission.INTERNET"/>` pada `android/app/src/main/AndroidManifest.xml`; manifest debug sudah memuatnya, manifest release tidak.

---

## Hasil yang Dicapai

Kandidat `1.2.0+3` berhasil dibangun dan dipasang pada emulator. Firebase aktif dan terverifikasi lewat logcat: `FirebaseApp initialization successful`, event `beta_feedback_sent` masuk pipeline Analytics, dan error non-fatal diantrekan lalu di-upload dengan HTTP 204 pada build uji versi yang sama. Seluruh 65 tes lulus, integration test login sampai catatan juga lulus di emulator, `flutter analyze --fatal-infos` bersih, dan format nol perubahan. Dashboard Firebase Console tidak dapat diakses, sehingga keputusan rilis ditahan pada beta internal dan tidak diperluas.

---

## Artefak dan Versi

| Item | Nilai |
|---|---|
| Versi aplikasi | `1.2.0` |
| Build number | `3` |
| APK | 52,23 MB |
| AAB | 52,21 MB |
| SHA-256 APK | `8F8AA2799351AC0E52701B95A8F7F6F751CDA54D6039E9BB43EA1161144AD6B6` |
| SHA-256 AAB | `97EA1981C3C8DFC8E02B571663A573979383A7E45AFD445565F7FE5B85B9CEEB` |
| Perangkat uji | Pixel 8, Android 17 (API 37) |

Artefak build tidak di-commit. Angka dan checksum di atas dihasilkan dari build pada 25 November 2026.

---

## Tahapan Praktikum

### Praktikum 1: Kandidat Rilis dan Build AAB

<img src="screenshots/Praktikum 1 - Versi Kandidat Beta.png" width="700" alt="Versi Kandidat Beta">

> **Keterangan gambar**
> - Versi dinaikkan dari `1.1.0+2` menjadi `1.2.0+3`.
> - Kenaikan minor dipakai karena ada fitur baru (monitoring beta), dan build number naik untuk unggahan baru.
> - Commit kandidat dicatat agar artefak bisa dihubungkan ke source.

<img src="screenshots/Praktikum 1 - Build AAB Release.png" width="700" alt="Build AAB Release">

> **Keterangan gambar**
> - `flutter build appbundle --release` menghasilkan AAB 52,2 MB.
> - `flutter build apk --release` menghasilkan APK 52,2 MB untuk instalasi langsung.
> - Keduanya memakai debug signing; ini cukup untuk uji internal, tetapi belum layak untuk Play Store.

### Praktikum 2: Distribusi Beta ke Perangkat Uji

<img src="screenshots/Praktikum 2 - Instalasi Build Beta.png" width="700" alt="Instalasi Build Beta">

> **Keterangan gambar**
> - APK dipasang dengan `adb install -r` pada emulator Pixel 8.
> - `dumpsys package` membuktikan perangkat menerima `versionName=1.2.0` dan `versionCode=3`.
> - Cara ini dipakai karena Play Console dan Firebase App Distribution memerlukan akses console yang tidak tersedia.

<img src="screenshots/Praktikum 2 - Aplikasi Beta di Emulator.png" width="300" alt="Aplikasi Beta di Emulator">

> **Keterangan gambar**
> - Build release berhasil login dan menampilkan Home.
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
> - Halaman ini hanya mengirim nama event dan nama layar.
> - Tombol **Uji Error Non-Fatal** memicu error buatan untuk membuktikan Crashlytics menerima laporan.

<img src="screenshots/Praktikum 3 - Event Beta Dikirim.png" width="300" alt="Event Beta Dikirim">

> **Keterangan gambar**
> - Snackbar menegaskan event dikirim tanpa data pribadi.
> - Event yang dikirim bernama `beta_feedback_sent` dengan parameter `screen_name=beta_feedback_page`.

<img src="screenshots/Praktikum 3 - Error Non Fatal Dikirim.png" width="300" alt="Error Non Fatal Dikirim">

> **Keterangan gambar**
> - Snackbar menegaskan error non-fatal dikirim ke Crashlytics.
> - Error yang dikirim adalah error buatan `Uji error non-fatal Week 14` tanpa data pengguna.

<img src="screenshots/Praktikum 3 - Event Analytics Terkirim.png" width="700" alt="Event Analytics Terkirim">

> **Keterangan gambar**
> - Log `FA-SVC` menampilkan `Logging event: origin=app,name=beta_feedback_sent`.
> - Parameter yang tercatat hanya `screen_name=beta_feedback_page`.
> - Tidak ada email, token, atau isi catatan pada event.

<img src="screenshots/Praktikum 3 - Error Non Fatal Terkirim.png" width="700" alt="Error Non Fatal Terkirim">

> **Keterangan gambar**
> - Crashlytics mencatat `Persisting non-fatal event`, lalu `successfully enqueued to DataTransport` pada build uji `1.2.0+3`.
> - Setelah aplikasi dibuka ulang, report di-upload dan server membalas HTTP 204.
> - Baris `Successful upload. Got network response` adalah bukti upload, bukan sekadar pencatatan lokal.

### Praktikum 4: Triage dan Release Report

<img src="screenshots/Praktikum 4 - Verifikasi Telemetri.png" width="700" alt="Verifikasi Telemetri">

> **Keterangan gambar**
> - Ringkasan bukti Analytics dan Crashlytics dikumpulkan dalam satu tampilan.
> - Verifikasi memakai logcat karena dashboard Firebase Console tidak dapat diakses.
> - HTTP 204 pada upload Crashlytics menunjukkan server menerima report.

<img src="screenshots/Praktikum 4 - Triage Rilis.png" width="700" alt="Triage Rilis">

> **Keterangan gambar**
> - Alur utama release lulus di emulator.
> - Analytics dan Crashlytics terkirim, tetapi dashboard belum ditinjau.
> - Keputusan: lanjutkan beta internal dengan syarat, tahan rilis publik.

<img src="screenshots/Praktikum 4 - Release Report.png" width="700" alt="Release Report">

> **Keterangan gambar**
> - `docs/release-report.md` memuat artefak, checksum, hasil pemeriksaan, temuan, keputusan, dan langkah berikutnya.
> - Setiap temuan punya keputusan eksplisit: diperbaiki, diterima, atau ditahan.
> - Keterbatasan ditulis apa adanya, termasuk dashboard dan Play Console yang tidak tersedia.

### Refactoring & Testing

<img src="screenshots/Refactoring - Flutter Analyze dan Test.png" width="600" alt="Flutter Analyze dan Test"> <img src="screenshots/Refactoring - Hasil Flutter Format.png" width="500" alt="Hasil Flutter Format">

> **Keterangan gambar**
> - `flutter analyze --fatal-infos` bersih tanpa isu.
> - Seluruh 65 tes lulus pada project Week 14.
> - `dart format` melaporkan nol file berubah.

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

1. **Dashboard belum diverifikasi.** Tidak ada akses Firebase Console, sehingga tidak ada tangkapan layar dashboard. Bukti yang sah adalah logcat dan status aplikasi.
2. **Distribusi bukan track resmi.** ADB install tidak punya opt-in, daftar tester, atau rollback.
3. **Signing debug.** APK/AAB belum layak untuk Play Store.
4. **Project Firebase dipakai bersama Minggu 6.** Data telemetry masuk ke project yang sama.
5. **Symbol native belum diunggah.** Crashlytics menerima laporan Dart, tetapi mapping native belum dikonfigurasi.

---

## AI Prompt Challenge

Prompt untuk menganalisis log rilis beta sudah disamarkan dan dicatat lengkap di [`docs/ai-log-analysis.md`](docs/ai-log-analysis.md).

### Ringkasan Saran AI dan Keputusan

| Saran AI | Keputusan | Alasan Teknis |
|---|---|---|
| `enqueued` belum berarti `uploaded` | **Diterima** | Upload dibuktikan baris HTTP 204 |
| Cek dashboard sebelum memperluas beta | **Diterima** | Dashboard adalah sinyal agregat yang tidak bisa diganti log satu perangkat |
| Hitung crash-free rate dari logcat | **Ditolak** | Log satu perangkat tidak mewakili populasi |
| Kirim `user_id` untuk analisis | **Ditolak** | Melanggar minimalisasi data |
| Tambahkan event untuk setiap layar | **Ditolak** | Menambah noise dan risiko data pribadi tanpa pertanyaan yang jelas |
| Simpan log mentah di repository | **Ditolak** | Log dapat memuat identifier perangkat |

---

## Refleksi

**1. Bukti apa yang diperlukan sebelum memperluas distribusi beta?**

Bukti bahwa build yang sama sudah diuji pada beberapa perangkat, tidak ada crash fatal dalam 24 jam, dashboard menunjukkan crash-free users yang tinggi, dan tidak ada temuan yang menghalangi alur utama. Untuk praktikum ini, bukti yang ada baru satu perangkat dan satu event; itu cukup untuk uji internal, belum untuk memperluas.

**2. Bagaimana Anda memutuskan untuk menahan atau melanjutkan rilis?**

Saya menahan perluasan karena tiga syarat belum terpenuhi: signing produksi, dashboard monitoring, dan tester eksternal. Saya tetap melanjutkan beta internal karena alur utama lulus dan telemetry terbukti terkirim. Keputusan ini dicatat eksplisit di `docs/release-report.md`, bukan disimpulkan diam-diam.

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
