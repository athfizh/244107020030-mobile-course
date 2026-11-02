# Review Checklist - Minggu 8

**Nama:** Athaulla Hafizh
**NIM:** 244107020030
**Tanggal:** 2 November 2026

---

## 1. Audit Riwayat Git

Perintah yang dijalankan pada repository:

```powershell
git log --oneline -15
git branch -a
git status
```

### Temuan audit

| No | Temuan | Bukti | Tindakan |
|---|---|---|---|
| 1 | Seluruh commit lama langsung masuk ke `main` tanpa branch integrasi | `git branch -a` sebelum Minggu 8 hanya menampilkan `main` | Membuat branch `develop` sebagai target default Pull Request |
| 2 | Pesan commit lama tidak memakai format konvensional | Riwayat berisi `fix bug`, `update`, `final fix beneran` pada commit awal | Menulis ulang tiga pesan commit ke format `tipe(scope): deskripsi` |
| 3 | Tidak ada branch fitur berumur pendek | Tidak ada `feature/*` maupun `fix/*` | Membuat `feat/notes-validation`, `fix/announcement-route`, `style/week8-format`, `chore/week8-scaffold` |
| 4 | Tidak ada issue yang menutup PR | Tidak ada issue di repository | Membuat issue #1 dan #2 sebagai pemicu PR |
| 5 | File platform ikut tersentuh status | `git status` bersih, `.gitignore` sudah menutup `android/`, `ios/`, `build/`, `.dart_tool/` | Tidak ada perubahan, aturan dipertahankan |

## 2. Tiga Commit Lama vs Versi Konvensional

| Commit Lama | Versi Baru | Alasan |
|---|---|---|
| `fix bug` | `fix(notes): cegah simpan judul kosong + test` | Menyebut apa yang diperbaiki, di modul mana, dan bukti pengujiannya |
| `update` | `docs(week7): perbarui README dan screenshot` | Menyebut objek perubahan sehingga reviewer tahu tidak ada kode yang berubah |
| `final fix beneran` | `feat(notes): tambah validasi form catatan` | Menyebut jenis perubahan dan cakupan fitur, bukan status emosional penulis |

Aturan yang dipakai: satu commit = satu perubahan logis yang bisa direview dan di-revert. Tipe yang dipakai hanya `feat`, `fix`, `refactor`, `test`, `docs`, `chore`, `style`.

## 3. Tabel Kesiapan Tengah Semester

| Kriteria | Status | Bukti |
|---|---|---|
| Struktur feature-first terbukti | Lulus | Folder `lib/features/{auth,announcement,notes}` masing-masing berisi `presentation`, `domain`, `data` |
| Tiga grep sterilisasi Minggu 7 | Lulus | Lihat bagian 4 di bawah |
| `flutter analyze` bersih | Lulus | `No issues found!` |
| `dart format --set-exit-if-changed lib test` rapi | Lulus | `Formatted 39 files (0 changed)` |
| `flutter test` hijau | Lulus | `All tests passed!` (19 tes) |
| PR kecil dan commit jelas | Lulus | 5 PR (#3-#7), masing-masing di bawah 300 baris perubahan kecuali PR scaffold yang bersifat salinan mekanis |
| README, screenshot, cara menjalankan lengkap | Lulus | Lihat `README.md` Week 8 |
| Semua komentar review ditindaklanjuti | Lulus | Review pada PR #5 dan #6, tindak lanjut di `docs/pr-notes.md` |

## 4. Tiga Grep Sterilisasi

```powershell
# 1. Presentation bebas akses data mentah
PS> Select-String -Path "lib\features\*\presentation\*\*.dart" -Pattern "Dio\(|openDatabase|getDatabasesPath|FlutterSecureStorage|SharedPreferences\.getInstance|jsonDecode"
(0 hasil)

# 2. Domain bebas framework dan package infrastruktur
PS> Select-String -Path "lib\features\*\domain\*\*.dart", "lib\core\*.dart" -Pattern "import 'package:flutter|import 'package:dio|import 'package:sqflite|import 'package:firebase"
(0 hasil)

# 3. Widget tidak memanggil repository secara langsung
PS> Select-String -Path "lib\features\*\presentation\pages\*.dart" -Pattern "noteRepositoryProvider|announcementRepositoryProvider"
(0 hasil setelah PR #2)
```

Ketiga grep di atas menjadi bukti bahwa `Dependency Rule` Minggu 7 masih utuh setelah perubahan Minggu 8.

## 5. Hasil Mesin

```text
PS> flutter analyze
No issues found! (ran in 2.4s)

PS> dart format --set-exit-if-changed lib test
Formatted 39 files (0 changed) in 0.09 seconds.

PS> flutter test
00:00 +14: All tests passed!
```

## 6. Kesimpulan

Fondasi paruh semester dinilai layak dilanjutkan. Tiga masalah nyata ditemukan lewat review dan sudah diperbaiki pada PR terpisah: route detail yang rusak akibat escape karakter, pemanggilan repository langsung dari widget, serta tidak adanya validasi judul catatan.
