# Refleksi - Minggu 6: Authentication, Security & FCM

**Nama:** Athaulla Hafizh  
**NIM:** 244107020030  
**Tanggal:** 2 Oktober 2026

---

## 1. Mengapa refresh token tidak boleh disimpan di SharedPreferences? Apa risikonya bila bocor?
SharedPreferences menyimpan data dalam bentuk *plain-text* murni tanpa enkripsi sedikit pun. Bila perangkat Android di-*root* atau disusupi *malware*, peretas dapat dengan mudah mencuri `refresh_token` (yang biasanya berumur panjang) untuk mengambil alih sesi pengguna penuh (*Account Takeover*).

## 2. Apa yang rusak bila onTokenRefresh diabaikan selama satu semester perkuliahan?
Token identitas unit perangkat (*FCM Token*) sewaktu-waktu dapat dirotasi secara sepihak oleh Google. Jika aplikasi tidak memberikan *callback* penyegaran token baru ini ke backend, maka server kampus akan memegang "Token Basi" (stale). Akibatnya seluruh notifikasi kritis akan selalu gagal dikirimkan (*bouncing*).

## 3. Kapan memakai topik dan kapan memakai token perangkat? Beri contoh pesan kampus untuk masing-masing.
*Topik (Topic)*: Digunakan untuk siaran publik massal. Contoh: "Perkuliahan besok pagi ditiadakan karena libur nasional". 
*Token Perangkat (Device Token)*: Digunakan khusus data konfidensial *One-to-One*. Contoh: Surat peringatan (SP) absensi, atau rilis nilai KHS spesifik milik pengguna tersebut.

## 4. Bagian mana dari draf AI yang Anda tolak atau perbaiki, dan mengapa?
1. **Format Argumen**: Saya memodifikasi format parameter kuno menjadi format *Named Parameter* (`id:`, `title:`, `settings:`) pada `flutter_local_notifications` v22.
2. **Sensor UI & Log**: Saya mencacah pemotongan string variabel token dengan batasan 12 huruf awal (*truncate*) demi kerahasiaan saat *debugging*.
3. **Izin OS**: Saya menolak asumsi Android 13+ otomatis dan menambahkan paksaan `<uses-permission android:name="android.permission.POST_NOTIFICATIONS"/>` langsung di *manifest Native*.
