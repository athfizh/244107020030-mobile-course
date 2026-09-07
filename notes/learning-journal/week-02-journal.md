# Learning Journal – Semester Mobile Development

**Athaulla Hafizh | NIM: 244107020030**

---

## Minggu 2 – Declarative UI & Responsive Design

**Tanggal:** 3 September 2026

### Yang Dipelajari
- Declarative UI dalam Flutter
- Widget dasar tata letak (`Row`, `Column`, `Container`, `Expanded`, `Spacer`)
- Pembuatan layout responsif menggunakan `LayoutBuilder`
- Integrasi `StatefulWidget` untuk perubahan state (Dark Mode)
- Aksesibilitas di Flutter (`Semantics`)

### Yang Dikerjakan
- [x] Pembuatan Profil Mahasiswa (Warm-up)
- [x] Pembuatan Dashboard Responsif & Academic Overview
- [x] Integrasi `CupertinoSwitch` untuk Dark/Light mode
- [x] Penambahan widget `Semantics` untuk aksesibilitas
- [x] Widget testing responsif di `academic_overview_test.dart`
- [x] AI Prompt Challenge & Refactoring

### Kendala & Solusi
- **Masalah:** Teks "Email" terpotong menjadi dua baris ("Ema il") ketika `Expanded` ditaruh di label dengan teks nilai yang panjang.
- **Solusi:** Memindahkan `Expanded` ke teks nilai email, menyesuaikan `font-size`, dan meratakan posisi menggunakan `Spacer` / `textAlign`.

### Key Takeaway
> Pendekatan declarative UI pada Flutter menyederhanakan pengelolaan tampilan dengan menjadikan UI sebagai fungsi dari state (`UI = f(state)`), di mana perubahan state secara otomatis memicu pembaruan widget tree tanpa manipulasi view imperatif.
