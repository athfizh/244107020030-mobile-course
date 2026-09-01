# Refleksi – Minggu 1: Mobile Development Ecosystem & Flutter Refresh

**Nama:** Athaulla Hafizh  
**NIM:** 244107020030  
**Tanggal:** 1 September 2026

---

## 1. Kapan native lebih tepat dipilih daripada cross-platform?

**Jawaban singkat:** Ketika performa, akses hardware penuh, atau kepatuhan ketat terhadap UI guidelines platform menjadi keharusan bisnis — bukan sekadar preferensi.

### Perbandingan terstruktur

| Kriteria | Native (Swift/Kotlin) | Cross-platform (Flutter) |
|---|---|---|
| Performa frame rate | 60/120 fps stabil, akses langsung ke GPU | Hampir setara via Skia/Impeller, tapi ada overhead minimal |
| Akses hardware | API lengkap hari-H rilis OS baru | Bergantung pada plugin yang mungkin tertinggal |
| Ukuran tim | Efisien jika tim sudah terspesialisasi per platform | Satu tim untuk semua platform |
| Time-to-market | Lebih lama (dua codebase) | Lebih cepat (satu codebase) |
| Kasus ideal | Game, AR/VR, kamera real-time, fintech premium | SaaS B2B, marketplace, MVP, app dengan UI seragam |

**Kesimpulan personal:** Untuk sebagian besar aplikasi bisnis (e-commerce, produktivitas, edukasi), Flutter adalah pilihan yang sangat kompetitif. Native tetap menjadi pilihan utama ketika akses API platform terbaru sangat kritis atau ketika pengalaman platform-native yang sempurna menjadi diferensiator produk.

---

## 2. Bagaimana perubahan state berhubungan dengan widget tree dan UI deklaratif?

**Konsep inti:** `UI = f(state)` — UI adalah *fungsi murni* dari state saat ini.

### Alur lengkap

```
┌─────────────┐     setState()    ┌──────────────┐
│  User Event │ ────────────────► │  State berubah│
└─────────────┘                   └──────┬───────┘
                                         │
                                   build() dipanggil
                                         │
                                  ┌──────▼───────┐
                                  │ Widget Tree  │ ← Deskripsi UI baru (immutable)
                                  │    Baru      │
                                  └──────┬───────┘
                                         │
                                    Reconciliation
                                  (diff tree lama vs baru)
                                         │
                                  ┌──────▼───────┐
                                  │ RenderObject │ ← Hanya bagian yang berubah
                                  │  diperbarui  │   yang di-repaint
                                  └──────┬───────┘
                                         │
                                  ┌──────▼───────┐
                                  │    Layar     │
                                  └──────────────┘
```

### Poin kunci
- **Widget = blueprint** – widget itu ringan dan immutable, bukan objek visual nyata
- **Element Tree** – Flutter mempertahankan *element tree* sebagai "jembatan" antara widget dan render object untuk efisiensi
- **`setState()` vs state management** – `setState()` cocok untuk state lokal; untuk state global gunakan Provider/Riverpod/BLoC
- **Hot Reload** bekerja karena Flutter bisa membangun ulang widget tree tanpa restart penuh — ini hanya mungkin karena arsitektur deklaratif

---

## 3. Mengapa commit kecil dengan pesan jelas bermanfaat bagi pekerjaan tim dan portfolio?

### Perspektif tim

**Analogi:** Commit adalah *log buku harian proyek*. Tim yang membaca log tersebut harus memahami konteks tanpa harus bertanya kepada penulisnya.

1. **Debugging dengan `git bisect`** – commit kecil mempersempit pencarian bug secara eksponensial
2. **Code review yang manusiawi** – PR 500 baris vs 50 baris: yang mana lebih mungkin direview dengan teliti?
3. **Parallel development** – konflik merge terjadi pada wilayah yang lebih kecil dan lebih mudah diselesaikan
4. **Accountability** – setiap keputusan teknis tercatat; tidak ada "magic change" yang tidak bisa dijelaskan

### Perspektif portfolio

```
# Commit buruk (yang sering dilakukan):
git commit -m "update"
git commit -m "fix stuff"
git commit -m "final FINAL v2"

# Commit baik (yang menunjukkan profesionalisme):
git commit -m "feat(profil): tambah NIM badge dengan pill styling"
git commit -m "test(widget): replace counter template dengan test profil mahasiswa"
git commit -m "docs(readme): tambah refleksi 3 poin dan kendala setup cmdline-tools"
```

**Manfaat konkret untuk portfolio:**
- Perekrut teknis sering membuka tab `Commits` di GitHub untuk menilai *work discipline*
- Riwayat commit yang konsisten menunjukkan kemampuan bekerja dalam tim profesional
- Conventional Commits (`feat:`, `fix:`, `docs:`, `refactor:`) adalah standar industri yang dikenal luas
- Progres terlihat nyata: dari scaffold → fitur dasar → test → dokumentasi

---

## Insight Tambahan Minggu 1

### Hot Reload vs Hot Restart

| | Hot Reload | Hot Restart |
|---|---|---|
| Mempertahankan state? | ✅ Ya | ❌ Tidak |
| Kecepatan | ~1 detik | ~3-5 detik |
| Kapan dipakai | Ubah UI/logika tanpa state reset | Ubah `initState`, konstruktor, atau konstanta |
| Cara trigger | `r` di terminal atau ⚡ di IDE | `R` di terminal atau 🔄 di IDE |

### Dart Null Safety — Insight
`String?` vs `String` bukan sekadar sintaks — ini adalah **kontrak compile-time**. Compiler menolak kode yang bisa menyebabkan `NullPointerException` sebelum runtime. Ini adalah salah satu keunggulan Dart dibanding JavaScript/Python untuk pengembangan mobile yang membutuhkan keandalan tinggi.
