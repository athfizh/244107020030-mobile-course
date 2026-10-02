# Jurnal Belajar: Minggu 5 (Local Storage & Offline-First)

## Identitas
- **Nama:** Athfizh
- **NIM:** 244107020030
- **Tanggal:** 27 September 2026

## Ringkasan Materi
Pada minggu ke-5, materi difokuskan pada persistensi data secara lokal untuk memenuhi standar industri *Offline-First Application*. Pembelajaran mencakup:
1. Pemisahan tipe penyimpanan lokal: `SharedPreferences` untuk skalar, dan `SQLite (sqflite)` untuk data terstruktur/kolektif.
2. Mekanisme antrean sinkronisasi (_Queue Sync_) menggunakan `dirty flag`.
3. Teknik `Cache-first` pada aplikasi (langsung menampilkan data lokal saat offline, me-refresh _background_ jika online).
4. Pemisahan logika aplikasi (_Refactoring_): `SyncService` terpisah, *Repository Pattern*, dan *Unit Testing* yang mem-_mock_ interaksi basis data.

## Tantangan & AI Challenge
Tantangan utamanya adalah mengintegrasikan _GoRouter_ serta me-_refactor_ UI yang saling tumpang tindih. Pada AI Challenge, eksplorasi membandingkan *SharedPreferences, Hive, sqflite, dan Drift* berhasil menghasilkan matriks yang menjustifikasi arsitektur final yang dipilih (kombinasi SharedPreferences + sqflite) demi menghindari *Out of Memory* dan mempercepat *build time*. Seluruh dokumen uji dan justifikasi telah di-*commit* di folder `docs/`.

## Screenshot Pendukung
> *Screenshots bukti (praktikum 1-3, mode offline, test sukses, dan struktur folder) dilampirkan langsung pada laporan GitHub repository ini.*
