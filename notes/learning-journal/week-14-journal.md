# Learning Journal - Semester Mobile Development

**Athaulla Hafizh | NIM: 244107020030**

---

## Minggu 14 - Deployment & Monitoring

**Tanggal:** 22 November 2026

### Yang Dipelajari
- Alur kandidat rilis: versi, build number, AAB, distribusi, dan umpan balik tester.
- Perbedaan track Internal Testing, Firebase App Distribution, dan distribusi privat lewat ADB.
- Inisialisasi Firebase Crashlytics dan Analytics, serta penanganan error global di Flutter.
- Event Analytics minimal: nama event dan nama layar tanpa data pribadi.
- Triage sinyal rilis: crash-free users, jumlah pengguna terdampak, versi, dan laporan tester.
- Menyamarkan log sebelum dikirim ke AI: hapus token, ID, URL privat, dan payload.

### Yang Dikerjakan
- [x] Menyalin project Minggu 13 menjadi `week14_deploy` dengan versi `1.2.0+3`.
- [x] Menambahkan `firebase_core`, `firebase_analytics`, dan `firebase_crashlytics`.
- [x] Mengisi `lib/firebase_options.dart` dan `firebase/google-services.json` dari project Minggu 6.
- [x] Membuat `Monitoring.init()` dengan penanganan `FlutterError.onError` dan `PlatformDispatcher.onError`.
- [x] Membuat halaman Umpan Balik Beta untuk event dan error non-fatal.
- [x] Membangun APK 52,23 MB dan AAB 52,21 MB.
- [x] Memasang build beta di emulator dan memverifikasi versi `1.2.0+3`.
- [x] Memverifikasi event `beta_feedback_sent` dan upload Analytics HTTP 204 lewat logcat pada build uji versi yang sama.
- [x] Memastikan report non-fatal Crashlytics sampai tahap enqueue DataTransport; upload finalnya tidak diklaim karena tidak muncul di log.
- [x] Menulis `docs/release-report.md` dan `docs/ai-log-analysis.md`.
- [x] Menjalankan analyze, format, dan 65 tes sampai hijau.

### Kendala & Solusi
- **Masalah:** Firebase gagal init dan Analytics melaporkan `Missing google_app_id` meskipun `firebase_options.dart` sudah diisi.
- **Solusi:** Plugin `com.google.gms.google-services` dan `google-services.json` ditambahkan; setelah itu `FirebaseApp initialization successful`.
- **Masalah:** Crashlytics mencatat non-fatal tetapi report belum terlihat terkirim.
- **Solusi:** Report diantrekan ke DataTransport setelah aplikasi dibuka ulang. HTTP 204 yang muncul berasal dari Analytics, bukan Crashlytics, sehingga status Crashlytics dicatat sebagai **diantrekan**, bukan **terkirim**.
- **Masalah:** Build release gagal login karena izin `INTERNET` hanya ada di manifest debug.
- **Solusi:** Izin dipindahkan ke manifest utama dan build diuji ulang di emulator.
- **Masalah:** Firebase Console dan Play Console tidak dapat diakses.
- **Solusi:** Distribusi memakai ADB dan verifikasi memakai logcat; keterbatasan dicatat eksplisit di release report.
- **Masalah:** Build release masih memakai debug signing.
- **Solusi:** Tidak dipalsukan sebagai rilis produksi; keputusan rilis ditahan pada beta internal.

### Key Takeaway
> Rilis bukan sekadar build berhasil. Bukti bahwa event Analytics benar-benar terkirim, bahwa error tercatat sampai antrean, bahwa tidak ada data pribadi yang bocor, dan bahwa keterbatasan dicatat jujur jauh lebih penting daripada dashboard yang terlihat hijau.
