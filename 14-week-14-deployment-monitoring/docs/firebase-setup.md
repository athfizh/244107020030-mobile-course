# Setup Android dan Firebase - Minggu 14

**Athaulla Hafizh | NIM: 244107020030**

---

Dokumen ini melengkapi README agar project Week 14 bisa dibangun dari clone baru. Folder `android/` tidak di-commit, jadi langkah berikut perlu dijalankan sekali setelah clone.

## 1. Buat folder platform

```bash
cd 14-week-14-deployment-monitoring
flutter create . --platforms=android
flutter pub get
```

## 2. Tambahkan izin INTERNET

Buka `android/app/src/main/AndroidManifest.xml`, lalu tambahkan tepat setelah tag `<manifest ...>`:

```xml
<uses-permission android:name="android.permission.INTERNET"/>
```

Manifest debug sudah memuat izin ini, tetapi manifest release tidak. Tanpa izin ini, build release bisa dibuka tetapi login dan pengumuman gagal.

## 3. Tambahkan plugin Google Services

`android/settings.gradle.kts`:

```kotlin
plugins {
    id("dev.flutter.flutter-plugin-loader") version "1.0.0"
    id("com.android.application") version "9.1.0" apply false
    id("org.jetbrains.kotlin.android") version "2.4.0" apply false
    id("com.google.gms.google-services") version "4.4.2" apply false
}
```

`android/app/build.gradle.kts`:

```kotlin
plugins {
    id("com.android.application")
    id("org.jetbrains.kotlin.android")
    id("com.google.gms.google-services")
    id("dev.flutter.flutter-gradle-plugin")
}
```

`applicationId` harus sama dengan aplikasi yang terdaftar di Firebase:

```kotlin
defaultConfig {
    applicationId = "com.example.week6_auth_fcm"
}
```

## 4. Salin konfigurasi Firebase

```powershell
Copy-Item firebase\google-services.json android\app\google-services.json
```

Berkas ini berisi pengenal klien publik (project ID, app ID, API key klien), bukan keystore atau token. Jangan menambahkan keystore, password, atau service account ke repository.

## 5. Verifikasi

```bash
flutter analyze --fatal-infos
flutter test
flutter build apk --release
adb install -r build/app/outputs/flutter-apk/app-release.apk
adb logcat -s FirebaseCrashlytics FA FA-SVC | findstr /i "beta_feedback_sent enqueued upload"
```

Yang diharapkan:

1. `FirebaseApp initialization successful`
2. `Initializing Firebase Crashlytics ...`
3. `Logging event: origin=app,name=beta_feedback_sent` setelah tombol **Kirim Event Beta** ditekan
4. `Crashlytics report successfully enqueued to DataTransport` setelah tombol **Uji Error Non-Fatal** ditekan

## 6. Distribusi Beta via Firebase App Distribution

Jalur distribusi yang disarankan modul. Disiapkan sebagai workflow `workflow_dispatch`, sehingga service account tidak pernah tersedia untuk pull request.

1. Firebase Console -> **App Distribution** -> Get started.
2. Buat grup tester `internal-testers` dan tambahkan email Anda.
3. Project settings -> **Service accounts** -> Generate new private key (JSON).
4. GitHub repo -> Settings -> Secrets and variables -> Actions:
   - Secret `FIREBASE_SERVICE_ACCOUNT` = isi JSON tersebut.
   - Variable `FIREBASE_APP_ID` = `1:174960433216:android:a61a15e007477bb37a67a5`.
5. Jalankan workflow `distribute-beta` pada tab Actions.
6. Tester menerima email undangan; bukti distribusi dicatat dengan screenshot dashboard App Distribution dan email tester.

Workflow `distribute-beta` mengunduh APK dari release `v1.2.0`, memverifikasi checksum, lalu mendistribusikannya lewat Firebase CLI dengan `GOOGLE_APPLICATION_CREDENTIALS`.

---

## 7. Batasan

1. Dashboard Crashlytics dan Analytics sudah diverifikasi lewat Firebase Console; sampelnya masih kecil (1 active user, 2 event non-fatal).
2. Track Internal Testing Play Console tidak tersedia; distribusi memakai ADB ke perangkat uji.
3. Build memakai debug signing sampai keystore produksi disiapkan.
4. `applicationId` sama dengan aplikasi Minggu 6, jadi build ini menggantikan aplikasi Minggu 6 pada perangkat yang sama.
5. Jika build Windows gagal karena incremental cache Kotlin, tambahkan `kotlin.incremental=false` dan `kotlin.compiler.execution.strategy=in-process` pada `android/gradle.properties`.

1. Dashboard Crashlytics dan Analytics sudah diverifikasi lewat Firebase Console; sampelnya masih kecil (1 active user, 2 event non-fatal).
2. Track Internal Testing Play Console tidak tersedia; distribusi memakai ADB ke perangkat uji.
3. Build memakai debug signing sampai keystore produksi disiapkan.
4. `applicationId` sama dengan aplikasi Minggu 6, jadi build ini menggantikan aplikasi Minggu 6 pada perangkat yang sama.
5. Jika build Windows gagal karena incremental cache Kotlin, tambahkan `kotlin.incremental=false` dan `kotlin.compiler.execution.strategy=in-process` pada `android/gradle.properties`.
