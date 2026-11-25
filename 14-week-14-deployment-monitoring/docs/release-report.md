# Release Report - Minggu 14

**Nama:** Athaulla Hafizh  
**NIM:** 244107020030  
**Tanggal:** 25 November 2026  
**Kandidat:** `1.2.0+3`  
**Commit kandidat:** `3cb7d9c` (build dibuat dari working tree yang sama; dokumentasi rilis di `d3821f7`)  
**Perangkat uji:** Emulator Pixel 8, Android 17 (API 37), x86_64, 1080x2400

---

## 1. Ringkasan

Kandidat rilis Week 14 dibangun dari project Week 13 dengan tambahan Firebase Crashlytics dan Analytics. Build release berhasil dibuat, dipasang pada emulator, dan diuji alur utama. Satu event Analytics non-sensitif (`beta_feedback_sent`) dan satu error non-fatal berhasil dikirim serta terverifikasi lewat logcat. Dashboard Firebase Console tidak dapat diakses pada praktikum ini, sehingga verifikasi dilakukan dari log perangkat dan status di aplikasi.

---

## 2. Artefak Rilis

| Artefak | Ukuran | SHA-256 |
|---|---:|---|
| `app-release.apk` | 52,23 MB | `8F8AA2799351AC0E52701B95A8F7F6F751CDA54D6039E9BB43EA1161144AD6B6` |
| `app-release.aab` | 52,21 MB | `97EA1981C3C8DFC8E02B571663A573979383A7E45AFD445565F7FE5B85B9CEEB` |

Lokasi build:

```text
build/app/outputs/flutter-apk/app-release.apk
build/app/outputs/bundle/release/app-release.aab
```

Keduanya memakai **debug signing** karena keystore produksi tidak dibuat pada praktikum ini. Build ini hanya untuk pengujian internal, bukan untuk diunggah ke Play Store.

---

## 3. Pemeriksaan Sebelum Distribusi

| Pemeriksaan | Perintah | Hasil |
|---|---|---|
| Format | `dart format --output=none --set-exit-if-changed lib test integration_test` | 0 file berubah |
| Analisis | `flutter analyze --fatal-infos` | Tidak ada isu |
| Test | `flutter test` | 65 tes lulus |
| Build APK | `flutter build apk --release` | 52,23 MB |
| Build AAB | `flutter build appbundle --release` | 52,21 MB |
| Versi perangkat | `adb shell dumpsys package com.example.week6_auth_fcm` | `versionName=1.2.0`, `versionCode=3` |

---

## 4. Distribusi Beta

Play Console dan Firebase App Distribution tidak tersedia karena memerlukan akun dan akses console. Distribusi dilakukan secara privat ke perangkat uji memakai ADB:

```bash
adb install -r build/app/outputs/flutter-apk/app-release.apk
adb shell am start -n com.example.week6_auth_fcm/com.example.week14_deploy.MainActivity
```

Perangkat uji bertindak sebagai satu-satunya tester internal. Ini bukan pengganti track Internal Testing yang sesungguhnya; keterbatasannya dicatat pada bagian 8.

Bukti:
- `screenshots/Praktikum 2 - Instalasi Build Beta.png`
- `screenshots/Praktikum 2 - Aplikasi Beta di Emulator.png`

---

## 5. Konfigurasi Monitoring

### Firebase

Project Firebase yang dipakai adalah `campus-notify-20030`, project yang sama dengan Minggu 6. Aplikasi Android memakai `applicationId` `com.example.week6_auth_fcm` agar cocok dengan aplikasi yang sudah terdaftar. Pendaftaran aplikasi Firebase baru memerlukan akses Firebase Console, sehingga opsi itu tidak dipakai.

Konfigurasi klien disimpan di `lib/firebase_options.dart` dan `firebase/google-services.json`. Nilai `apiKey` pada berkas tersebut adalah pengenal klien publik, bukan rahasia server. Yang tidak boleh masuk repository adalah keystore, password, dan token.

### Inisialisasi

`Monitoring.init()` memanggil `Firebase.initializeApp`, memasang `FlutterError.onError` dan `PlatformDispatcher.instance.onError`, lalu mengaktifkan koleksi Crashlytics. Bila inisialisasi gagal, aplikasi tetap berjalan dengan status **Mode lokal** dan mencatat kejadian ke logcat.

### Event dan error uji

| Nama | Jenis | Parameter | Data sensitif |
|---|---|---|---|
| `beta_feedback_sent` | Analytics | `screen_name=beta_feedback_page` | Tidak ada |
| `beta_test_non_fatal` | Crashlytics non-fatal | `reason`, stack trace | Tidak ada |

Halaman **Umpan Balik Beta** dipakai untuk memicu keduanya. Halaman ini tidak mengirim email, token, isi catatan, atau data pribadi.

---

## 6. Hasil Verifikasi Telemetri

### Analytics

```text
V/FA-SVC: Logging event: origin=app,name=beta_feedback_sent,
params=Bundle[{screen_name=beta_feedback_page, ga_event_origin(_o)=app, ...}]
V/FA-SVC:       name: beta_feedback_sent
V/FA-SVC:         string_value: beta_feedback_page
```

### Crashlytics

Verifikasi non-fatal dilakukan pada build uji `1.2.0+3`. Build release juga menginisialisasi Crashlytics, tetapi upload report pada sesi release tidak muncul di log; report yang sama terverifikasi pada build uji dengan applicationId dan versi identik.

```text
D/FirebaseCrashlytics: Persisting non-fatal event for session ...
D/FirebaseCrashlytics: Crashlytics report successfully enqueued to DataTransport: ...
D/FirebaseCrashlytics: Deleted report file: .../reports/...
V/FA-SVC: Network upload successful with code, uploadAttempted: 204, true
V/FA-SVC: Successful upload. Got network response. code, size: 204, 0
```

### Inisialisasi

```text
I/FirebaseInitProvider: FirebaseApp initialization successful
I/FirebaseCrashlytics: Initializing Firebase Crashlytics 21.1.0 for com.example.week6_auth_fcm
```

Bukti:
- `screenshots/Praktikum 3 - Firebase Terinisialisasi.png`
- `screenshots/Praktikum 3 - Event Analytics Terkirim.png`
- `screenshots/Praktikum 3 - Event Beta Dikirim.png`
- `screenshots/Praktikum 3 - Error Non Fatal Dikirim.png`
- `screenshots/Praktikum 4 - Verifikasi Telemetri.png`

---

## 7. Temuan dan Tindak Lanjut

| No | Temuan | Dampak | Keputusan |
|:--:|---|---|---|
| 1 | Build release gagal login karena izin `INTERNET` hanya ada di manifest debug | Alur utama tidak bisa dipakai pada build release | **Diperbaiki**: izin ditambahkan ke `android/app/src/main/AndroidManifest.xml` |
| 2 | Firebase gagal init sebelum plugin `com.google.gms.google-services` dipasang | Analytics melaporkan `Missing google_app_id` | **Diperbaiki**: plugin dan `google-services.json` ditambahkan |
| 3 | Crashlytics report baru terkirim setelah aplikasi dibuka ulang | Verifikasi dashboard tertunda | **Diterima**: report diantrekan ke DataTransport lalu di-upload pada sesi berikutnya |
| 4 | Dashboard Firebase Console tidak dapat diakses | Tidak ada tangkapan layar dashboard | **Dicatat sebagai keterbatasan**; verifikasi memakai logcat |
| 5 | Play Console tidak tersedia | Tidak ada track Internal Testing | **Dicatat**; distribusi memakai ADB ke perangkat uji |
| 6 | Build memakai debug signing | Tidak layak untuk Play Store | **Ditahan** untuk rilis publik sampai keystore produksi disiapkan |

---

## 8. Keputusan Rilis

**Lanjutkan beta internal dengan syarat**, bukan rilis publik.

Alasannya: alur utama berjalan pada build release, event Analytics dan error non-fatal terverifikasi terkirim, dan tidak ada data sensitif yang dikirim. Namun build belum ditandatangani dengan keystore produksi, dashboard monitoring belum ditinjau langsung, dan belum ada tester selain emulator. Karena itu distribusi tidak diperluas.

Kriteria untuk memperluas distribusi:
1. Keystore produksi dibuat dan disimpan di GitHub Actions Secrets.
2. AAB ditandatangani dan diunggah ke track Internal Testing.
3. Dashboard Crashlytics/Analytics ditinjau pada versi yang sama.
4. Minimal tiga tester eksternal menyelesaikan alur login, pengumuman, catatan, dan AI.
5. Tidak ada crash fatal pada 24 jam pertama.

---

## 9. Data yang Tidak Boleh Dikirim ke Monitoring

- Email, password, token akses, dan refresh token.
- Isi catatan pribadi dan riwayat chat AI.
- NIK, nomor HP, dan alamat.
- URL privat atau payload API.
- Identifier perangkat yang tidak diperlukan.

Event `beta_feedback_sent` hanya membawa `screen_name`. Logika `RedactSensitive` dari Minggu 10 tetap berlaku untuk prompt AI, tetapi tidak dipakai pada telemetry.

---

## 10. Keterbatasan

1. **Dashboard tidak diverifikasi.** Tidak ada akses Firebase Console, sehingga tidak ada tangkapan layar dashboard. Bukti yang tersedia adalah logcat dan status aplikasi.
2. **Distribusi bukan track resmi.** ADB install tidak memiliki mekanisme opt-in, daftar tester, atau rollback seperti Play Console.
3. **Signing debug.** APK/AAB tidak dapat dipublikasikan ke Play Store.
4. **Project Firebase dipakai bersama Minggu 6.** Data Analytics/Crashlytics masuk ke project yang sama; ini disengaja karena pendaftaran aplikasi baru butuh akses console.
5. **Symbol upload belum dikonfigurasi.** Crashlytics menerima laporan Dart, tetapi symbol native belum diunggah lewat Gradle plugin Crashlytics.

---

## 11. Langkah Berikutnya

1. Daftarkan aplikasi Week 14 sebagai app baru di Firebase project, lalu ganti `applicationId` dan `google-services.json`.
2. Aktifkan Crashlytics symbol upload dan mapping file pada workflow rilis.
3. Tambahkan `FirebaseAnalyticsObserver` pada GoRouter untuk `screen_view` otomatis.
4. Siapkan track Internal Testing di Play Console dan undang tester.
5. Tambahkan uji asap build release ke pipeline CI.
