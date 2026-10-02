# Learning Journal — Semester Mobile Development

**Athaulla Hafizh | NIM: 244107020030**

---

## Minggu 6 — Authentication, Security & FCM

**Tanggal:** 2 Oktober 2026

### Yang Dipelajari
- Penerapan otentikasi tiruan via token JWT untuk perputaran sesi *login* dan perlindungan jalur (*route guards*) melalui perantara *GoRouter*.
- Pemanfaatan *Keychain / Keystore* natif lewat pustaka `flutter_secure_storage` untuk merantai rahasia (seperti *access* dan *refresh token*).
- Rancangan intersepsi sentral (melalui *Dio Interceptors*) untuk menyegarkan sesi secara diam-diam (*silent refresh*) saat akses pengguna ditolak (HTTP 401).
- Ekstraksi konektivitas *Push Notifications* (FCM) pada berbagai tahap kesadaran perangkat (*foreground, background*, hingga ter-*kill* total).

### Yang Dikerjakan
- [x] Menyelesaikan Praktikum 1: Setup GoRouter Guard dan memproteksi Token JWT via flutter_secure_storage.
- [x] Menyelesaikan Praktikum 2: Mengintegrasikan library FCM dan request permission di Android 13+.
- [x] Menyelesaikan Praktikum 3: Memicu notifikasi lokal pada state Foreground, Background, dan Terminated.
- [x] Menyelesaikan Tugas Mandiri (AI Challenge): Mengeksplorasi pembuatan boilerplate dengan AI Prompt dan memperbaikinya.
- [x] Merapikan alur error (DioException mapper) dan Unit Testing yang tervalidasi 100%.
