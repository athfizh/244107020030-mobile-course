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
