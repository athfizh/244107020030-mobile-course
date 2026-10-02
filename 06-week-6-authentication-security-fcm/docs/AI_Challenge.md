# AI Challenge - Firebase Cloud Messaging (Week 6)

## 1. Prompt yang Digunakan
`	ext
Aplikasi Flutter Campus Notification App.
Stack: firebase_messaging, flutter_local_notifications,
flutter_secure_storage, go_router, Riverpod.
Buatkan PushService dengan:
- requestPermission + getToken + onTokenRefresh (kirim ke POST /devices)
- onMessage (tampilkan local notification manual)
- onMessageOpenedApp + getInitialMessage (navigasi ke data.route)
- subscribe/unsubscribe topic pengumuman-kampus
- background handler top-level dengan @pragma('vm:entry-point')
Tandai bagian yang BERBEDA untuk Android 13+ vs iOS,
dan bagian yang tidak boleh mengakses BuildContext.
`

## 2. Output Awal AI (Draft PushService)
AI memberikan rancangan *boilerplate* yang mencakup integrasi irebase_messaging dan lutter_local_notifications. Draf awal tersebut mengatur *permission* menggunakan metode equestPermission, meng-handle *foreground message* dengan lutter_local_notifications menggunakan *Named Parameter* seperti id: message.hashCode, serta mengalihkan pesan background dengan FirebaseMessaging.onBackgroundMessage.

## 3. Daftar Perbaikan Manual
Meski draf awal AI cukup baik, ada beberapa penyesuaian (*manual fixes*) yang dilakukan agar aplikasi benar-benar solid dan memenuhi kriteria keamanan:
1. **Perbaikan Parameter Initialization API:** Pada lutter_local_notifications terbaru, argumen initialize() dan show() tidak lagi menggunakan *positional arguments*, melainkan wajib menggunakan *named parameters* (settings:, id:, dll).
2. **Keamanan Log Token:** Menambahkan pemotongan karakter menggunakan *substring* _fcmToken = token.length > 12 ? '${token.substring(0, 12)}...' : token; agar kunci Token FCM utuh tidak terekspos/tercetak penuh pada terminal *debug console* maupun UI.
3. **Android 13+ Permissions:** Mengubah AndroidManifest.xml secara manual untuk menyuntikkan <uses-permission android:name="android.permission.POST_NOTIFICATIONS"/>. Jika diabaikan, fungsi *requestPermission* dari FCM di Android 13 tidak akan bereaksi sama sekali (berbeda dengan iOS yang langsung otomatis mendeteksi permission bawaan).
4. **Context Safety:** Memastikan navigasi yang dilakukan saat transisi latar belakang selalu dicek status *mounted*-nya dan tidak memanggil *BuildContext* di dalam isolate background handler.

## 4. AI Verification Checklist

| Kriteria Checklist | Hasil Evaluasi & Bukti |
| --- | --- |
| **Apakah background handler berupa fungsi top-level?** | **Lulus.** Menggunakan fungsi irebaseMessagingBackgroundHandler(RemoteMessage message) di luar kelas, dipasangi *annotation* @pragma('vm:entry-point'). |
| **Apakah onTokenRefresh mengirim token baru ke backend?** | **Lulus.** Menggunakan callback FirebaseMessaging.instance.onTokenRefresh.listen(onToken); di mana onToken adalah simulasi blok POST request menggunakan _Dio_. |
| **Apakah foreground memakai local notification manual?** | **Lulus.** Digunakan pemanggilan _local.show(...) saat onMessage.listen() menerima data. Banner muncul di layar meski aplikasi terbuka. |
| **Apakah klik dari ketiga state masuk ke rute yang benar?** | **Lulus.** (Lihat Tabel Matriks Pengujian di bawah). |
| **Apakah rahasia (token) tidak di-log/hardcode penuh?** | **Lulus.** Tampilan log dan UI hanya menayangkan 12 karakter pertama, selebihnya ditandai ellipsis (...). |

## 5. Matriks Pengujian Wajib (Tiga App State)

| State | Yang diharapkan | Cara uji | Hasil |
| --- | --- | --- | --- |
| **Foreground** | Banner lokal muncul, klik masuk ke /pengumuman/3 | Aplikasi terbuka, kirim campaign dari Firebase console dengan *custom data* oute | Berhasil. Muncul pop-up lokal dan berpindah halaman. |
| **Background** | Banner sistem muncul, klik masuk ke rute yang benar | Tekan Home, kirim pesan, lalu klik banner dari sistem operasi | Berhasil. Aplikasi terbuka dan langsung diarahkan melalui onMessageOpenedApp. |
| **Terminated** | Aplikasi terbuka ke rute yang benar via getInitialMessage | Swipe-close (kill) aplikasi dari Recent Apps, kirim pesan, lalu klik banner | Berhasil. Melakukan *cold boot* dan memicu handleTerminated dengan data utuh. |

## 6. Keputusan Final & Alasan Teknis
**Keputusan:** 
Kami sepakat untuk menggunakan arsitektur pemisahan (*separation of concerns*) di mana urusan perizinan dan *background logic* Firebase Messaging mutlak dipisahkan dari *UI Controller* (yang menggunakan Riverpod dan GoRouter). Penanganan *deep link routing* (baik saat App terbuka maupun mati) digabungkan di satu titik agar terpusat.

**Alasan Teknis:**
1. Isolasi Background FCM tidak dapat mengakses _state_ Riverpod di memori utama maupun memanipulasi *UI Thread*. Memaksa logika navigasi UI ke dalam isolasi tersebut bisa mengakibatkan *crashes* dan *Memory Leak*. 
2. Mematuhi kebijakan token rahasia sangat krusial, kebocoran satu token dapat menjadi jalan penyusup untuk membombardir *device* target dengan pesan *spam*.
