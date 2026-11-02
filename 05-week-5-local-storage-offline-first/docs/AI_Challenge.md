# AI Challenge - Local Storage & Offline First (Week 5)

## 1. Prompt yang Digunakan
```text
Aplikasi Flutter Offline Notes: CRUD catatan + preferensi tema.
Bandingkan SharedPreferences, Hive, sqflite (SQLite), dan Drift
untuk dua kebutuhan ini. Requirements:
- Kriteria: kompleksitas query, kebutuhan relasi, reaktivitas (stream),
  type-safety, ukuran boilerplate, dan kemudahan testing.
- Beri rekomendasi final: mana untuk preferensi, mana untuk catatan,
  beserta alasannya dalam 1 tabel.
- Tunjukkan skema tabel/kotak untuk 1000+ catatan.
Jelaskan trade-off setiap pilihan.
```

## 2. Output Awal AI (Draft Arsitektur)

AI menyusun matriks perbandingan empat opsi penyimpanan lokal:

- **SharedPreferences** untuk data skalar kecil (tema, waktu buka terakhir).
- **sqflite** untuk data relasional dengan query SQL murni.
- **Hive** untuk penyimpanan *key-value* cepat berbasis objek Dart.
- **Drift** untuk data reaktif dengan *stream* dan *type-safety* hasil *codegen*.

Namun AI juga mendorong penggunaan **Drift di semua kondisi** karena dianggap paling modern dan reaktif. AI menyertakan skema tabel dengan *build runner* dan contoh `watch()` untuk memantau perubahan data.

## 3. Perbandingan Opsi (Ringkasan Matriks AI)

| Kriteria | SharedPreferences | Hive | sqflite | Drift |
|---|---|---|---|---|
| Kompleksitas query | Sangat rendah | Rendah | Tinggi (SQL penuh) | Tinggi |
| Kebutuhan relasi | Tidak cocok | Terbatas | Cocok | Cocok |
| Reaktivitas (*stream*) | Tidak | Ada | Manual | Bawaan (`watch`) |
| *Type-safety* | Lemah | Sedang | Sedang | Kuat |
| Ukuran *boilerplate* | Minimal | Kecil | Sedang | Besar (*codegen*) |
| Kemudahan *testing* | Mudah | Mudah | Perlu *mock* DB | Perlu *mock* DB |

## 4. Daftar Perbaikan Manual

Meski matriks AI cukup akurat, ada beberapa keputusan yang saya sesuaikan:

1. **Menolak Drift sebagai default.** Saya menolak saran memakai Drift di seluruh kondisi karena biaya *build runner* dan *boilerplate codegen* tidak sepadan untuk skala praktikum.
2. **Mempertahankan sqflite.** Query SQL mentah lebih dekat ke fundamental dan cukup untuk kebutuhan tabel catatan dengan *dirty flag*.
3. **Menambah index.** AI hanya menulis skema dasar, lalu saya tambahkan index pada kolom `dirty` dan `updated_at` agar sinkronisasi tidak memindai seluruh tabel.
4. **Memisahkan tanggung jawab.** Preferensi tema tetap di SharedPreferences, sedangkan daftar catatan sepenuhnya di SQLite.

## 5. AI Verification Checklist

| Kriteria Verifikasi | Hasil Evaluasi & Bukti |
|---|---|
| Apakah AI menempatkan daftar catatan di SharedPreferences? | **Lulus.** AI menempatkannya di SQLite untuk menghindari *Out-of-Memory*. |
| Apakah skema AI mendukung antrean sync (*dirty flag* / `updated_at`)? | **Lulus.** Skema menyertakan index pendukung mutasi pada kolom `dirty` dan `updated_at`. |
| Apakah klaim "real-time" AI didukung mekanisme nyata? | **Lulus.** AI benar menyebut Drift reaktif lewat `watch()`, sedangkan sqflite butuh *invalidate* manual. |
| Apakah estimasi *boilerplate* AI masuk akal? | **Lulus.** AI jujur memperingatkan waktu *build* Drift yang lebih lama. |
| Apakah pilihan akhir lolos `flutter analyze` dan `flutter test`? | **Lulus.** Seluruh pemeriksaan hijau tanpa galat. |

## 6. Keputusan Final

Arsitektur perpaduan **SharedPreferences + sqflite** dipilih sebagai opsi paling wajar:

- **SharedPreferences** untuk data konfigurasi kecil (tema dan waktu kunjungan terakhir).
- **sqflite** untuk tabel catatan dengan sistem sinkronisasi asinkron (*Last-Write-Wins*).
- **Drift ditolak** karena *codegen* menambah waktu build dan kompleksitas yang tidak sebanding untuk kebutuhan praktikum.
