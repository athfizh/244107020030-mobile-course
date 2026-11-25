# Refleksi - Minggu 14: Deployment & Monitoring

**Nama:** Athaulla Hafizh  
**NIM:** 244107020030  
**Tanggal:** 22 November 2026

---

## 1. Bukti apa yang diperlukan sebelum memperluas distribusi beta?
Bukti bahwa build yang sama sudah diuji pada beberapa perangkat, tidak ada crash fatal dalam 24 jam, dashboard menunjukkan crash-free users yang tinggi pada sampel yang memadai, dan tidak ada temuan yang menghalangi alur utama. Untuk praktikum ini, dashboard sudah menunjukkan crash-free 100%, tetapi hanya dari 1 active user dan 2 event; itu cukup untuk uji internal, belum untuk memperluas.

## 2. Bagaimana Anda memutuskan untuk menahan atau melanjutkan rilis?
Saya menahan perluasan karena tiga syarat belum terpenuhi: signing produksi, Play Console, dan tester eksternal. Saya tetap melanjutkan beta internal karena alur utama lulus, event Analytics terlihat di DebugView, dan error non-fatal muncul sebagai issue `Monitoring.recordTestError` di dashboard Crashlytics. Sampelnya baru 1 active user dan 2 event, jadi rilis publik tetap ditahan. Keputusan ini dicatat eksplisit di `docs/release-report.md`.

## 3. Data apa yang tidak perlu dikirim ke layanan monitoring?
Email, token, isi catatan, riwayat chat, NIK, nomor HP, dan identifier perangkat yang tidak diperlukan. Event `beta_feedback_sent` hanya mengirim nama event dan nama layar. Untuk analisis AI, log disamarkan lebih dulu dengan menghapus app ID, installation ID, session ID, dan timestamp.
