# Release Report - Minggu 14

**Nama:** Athaulla Hafizh  
**NIM:** 244107020030  
**Tanggal:** 25 November 2026  
**Kandidat:** `1.2.0+3` (build akhir setelah perbaikan teks status monitoring)  
**Commit kandidat:** `dacca92`; dirilis ke `main` lewat PR #19 (`0eb842d`) dan tag `v1.2.0`  
**Perangkat uji:** Emulator Pixel 8, Android 17 (API 37), x86_64, 1080x2400

---

## 1. Ringkasan

Kandidat rilis Week 14 dibangun dari project Week 13 dengan tambahan Firebase Crashlytics dan Analytics. Build release berhasil dibuat, dipasang pada emulator, dan diuji alur utama. Satu event Analytics non-sensitif (`beta_feedback_sent`) terkirim dan terverifikasi lewat logcat (HTTP 204) serta Analytics DebugView. Satu error non-fatal terverifikasi di dashboard Crashlytics sebagai issue `Monitoring.recordTestError` pada versi `1.2.0 (3)`, dengan 2 event dari 2 installation ID dan stack trace `monitoring.dart:78`.

---

## 2. Artefak Rilis

| Artefak | Ukuran | SHA-256 |
|---|---:|---|
| `app-release.apk` | 52,23 MB | `D55641F8D95B945C3F494863F52D7DB72CFE67C354352883B4E9BC88E6EEDE71` |
| `app-release.aab` | 52,21 MB | `249E68EC69D8A8A6ED12B5749A111B0C24A44E43EBF566E9A7D55D20C96ECC88` |

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

Dashboard Analytics DebugView menampilkan event `beta_feedback_sent` secara real-time dari build release, dan logcat mencatat upload berhasil dengan HTTP 204.

```text
V/FA-SVC: Logging event: origin=app,name=beta_feedback_sent,
params=Bundle[{screen_name=beta_feedback_page, ga_event_origin(_o)=app, ...}]
V/FA-SVC:       name: beta_feedback_sent
V/FA-SVC:         string_value: beta_feedback_page
V/FA-SVC: Network upload successful with code, uploadAttempted: 204, true
V/FA-SVC: Successful upload. Got network response. code, size: 204, 0
```

### Crashlytics

Logcat menunjukkan report diantrekan ke DataTransport. Dashboard Crashlytics kemudian mengonfirmasi penerimaan: issue `Monitoring.recordTestError` tercatat sebagai non-fatal pada versi `1.2.0 (3)`, dengan 2 event dari 2 installation ID dan stack trace `monitoring.dart:78` -> `beta_feedback_page.dart:33`.

```text
D/FirebaseCrashlytics: Persisting non-fatal event for session ...
D/FirebaseCrashlytics: Crashlytics report successfully enqueued to DataTransport: ...
D/FirebaseCrashlytics: Deleted report file: .../reports/...
```

Dashboard:

| Metrik | Nilai |
|---|---|
| Release | `1.2.0 (3)` |
| Active users | 1 |
| Non-fatal events | 2 |
| Users terdampak | 2 installation ID |
| Crash-free users | 100% (sampel kecil) |
| Perangkat | 100% Google, Android 17 |

### Inisialisasi

```text
I/FirebaseInitProvider: FirebaseApp initialization successful
I/FirebaseCrashlytics: Initializing Firebase Crashlytics 21.1.0 for com.example.week6_auth_fcm
```

Bukti:
- `screenshots/Praktikum 3 - Firebase Terinisialisasi.png`
- `screenshots/Praktikum 3 - Event Analytics Terkirim.png`
- `screenshots/Praktikum 3 - Event Beta Dikirim.png`
- `screenshots/Praktikum 3 - Error Non Fatal Diantrekan di Aplikasi.png`
- `screenshots/Praktikum 3 - Error Non Fatal Diantrekan.png`
- `screenshots/Praktikum 4 - Dashboard Crashlytics.png`
- `screenshots/Praktikum 4 - Stack Trace Crashlytics.png`
- `screenshots/Praktikum 4 - Dashboard Analytics.png`
- `screenshots/Praktikum 4 - Verifikasi Telemetri.png`

---

## 7. Temuan dan Tindak Lanjut

| No | Temuan | Dampak | Keputusan |
|:--:|---|---|---|
| 1 | Build release gagal login karena izin `INTERNET` hanya ada di manifest debug | Alur utama tidak bisa dipakai pada build release | **Diperbaiki**: izin ditambahkan ke `android/app/src/main/AndroidManifest.xml` |
| 2 | Firebase gagal init sebelum plugin `com.google.gms.google-services` dipasang | Analytics melaporkan `Missing google_app_id` | **Diperbaiki**: plugin dan `google-services.json` ditambahkan |
| 3 | Crashlytics report baru diantrekan setelah aplikasi dibuka ulang | Dashboard sempat belum menunjukkan issue | **Diterima dan terverifikasi**: issue `Monitoring.recordTestError` muncul di dashboard versi `1.2.0 (3)` |
| 4 | Sampel dashboard sangat kecil: 1 active user, 2 event non-fatal | Belum bisa menyimpulkan kestabilan umum | **Dicatat sebagai keterbatasan**; perlu tester eksternal |
| 5 | Play Console tidak tersedia | Tidak ada track Internal Testing | **Dicatat**; distribusi memakai ADB ke perangkat uji |
| 6 | Build memakai debug signing | Tidak layak untuk Play Store | **Ditahan** untuk rilis publik sampai keystore produksi disiapkan |

---

## 8. Keputusan Rilis

**Lanjutkan beta internal dengan syarat**, bukan rilis publik.

Alasannya: alur utama berjalan pada build release, event Analytics terkirim (HTTP 204), dan error non-fatal terverifikasi di dashboard Crashlytics. Tidak ada data sensitif yang dikirim. Namun build belum ditandatangani dengan keystore produksi, Play Console belum tersedia, dan sampel dashboard baru 1 active user dari emulator. Karena itu distribusi tidak diperluas.

Kriteria untuk memperluas distribusi:
1. Keystore produksi dibuat dan disimpan di GitHub Actions Secrets.
2. AAB ditandatangani dan diunggah ke track Internal Testing.
3. Dashboard Crashlytics/Analytics ditinjau pada versi yang sama dengan minimal tiga perangkat berbeda.
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

1. **Sampel dashboard masih kecil.** Dashboard sudah diverifikasi, tetapi hanya 1 active user dan 2 event non-fatal dari 2 installation ID. Angka itu belum cukup untuk menyimpulkan kestabilan aplikasi secara umum.
2. **Distribusi bukan track resmi.** ADB install tidak memiliki mekanisme opt-in, daftar tester, atau rollback seperti Play Console.
3. **Signing debug.** APK/AAB tidak dapat dipublikasikan ke Play Store.
4. **Project Firebase dipakai bersama Minggu 6.** Data Analytics/Crashlytics masuk ke project yang sama dan `applicationId` juga sama, sehingga memasang build Week 14 akan menggantikan aplikasi Minggu 6 di perangkat uji. Ini disengaja karena pendaftaran aplikasi baru butuh akses console.
5. **Symbol upload belum dikonfigurasi.** Crashlytics mencatat laporan Dart, tetapi symbol native belum diunggah lewat Gradle plugin Crashlytics.

---

## 11. Langkah Berikutnya

1. Daftarkan aplikasi Week 14 sebagai app baru di Firebase project, lalu ganti `applicationId` dan `google-services.json`.
2. Aktifkan Crashlytics symbol upload dan mapping file pada workflow rilis.
3. Tambahkan `FirebaseAnalyticsObserver` pada GoRouter untuk `screen_view` otomatis.
4. Siapkan track Internal Testing di Play Console dan undang tester.
5. Tambahkan uji asap build release ke pipeline CI.

---

## 12. Distribusi dan Rilis

| Item | Nilai |
|---|---|
| PR rilis | #19 (develop -> main) |
| Merge commit | `0eb842d` |
| Tag | `v1.2.0` |
| GitHub Release | Pre-release Week 14 Beta 1.2.0+3 |
| Check CI PR | 14 check sukses (7 job x 2 event) |
| Issue tertutup | #1 dan #2, otomatis lewat PR |

Build tetap memakai debug signing dan tidak diunggah ke Play Store. Release ditandai pre-release agar tidak disalahartikan sebagai rilis produksi.

---

## 13. Penggunaan AI

Log yang dikirim ke AI sudah disamarkan: app ID, installation ID, session ID, dan timestamp dihapus. Prompt, ringkasan jawaban, serta cara verifikasi tiap saran dicatat di [i-log-analysis.md](ai-log-analysis.md). Klaim yang tidak bisa dibuktikan dari log, seperti crash-free rate, ditolak.
