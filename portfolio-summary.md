# Portfolio Summary – 16 Minggu Mobile Development
**Athaulla Hafizh | NIM: 244107020030**  
**Program Studi:** Teknik Informatika  
**Mata Kuliah:** Pemrograman Mobile

---

## Progress Overview

| Minggu | Topik | Status | Link |
|--------|-------|--------|------|
| 01 | Mobile Development Ecosystem & Flutter Refresh | ✅ Selesai | [Folder](01-week-1-mobile-development-ecosystem-flutter-refresh/) |
| 02 | Declarative UI & Responsive Design | ✅ Selesai | [Folder](02-week-2-declarative-ui-responsive-design/) |
| 03 | Navigation & State Management | ⏳ Belum | [Folder](03-week-3-navigation-state-management/) |
| 04 | Networking & REST API | ⏳ Belum | [Folder](04-week-4-networking-rest-api/) |
| 05 | Local Storage & Offline First | ⏳ Belum | [Folder](05-week-5-local-storage-offline-first/) |
| 06 | Authentication, Security & FCM | ⏳ Belum | [Folder](06-week-6-authentication-security-fcm/) |
| 07 | Clean Architecture | ⏳ Belum | [Folder](07-week-7-clean-architecture/) |
| 08 | Mid-Project Review | ⏳ Belum | [Folder](08-week-8-mid-project-review/) |
| 09 | AI-Assisted Development | ⏳ Belum | [Folder](09-week-9-ai-assisted-development/) |
| 10 | AI Feature Integration | ⏳ Belum | [Folder](10-week-10-ai-feature-integration/) |
| 11 | Performance Optimization | ⏳ Belum | [Folder](11-week-11-performance-optimization/) |
| 12 | Testing & Quality Assurance | ⏳ Belum | [Folder](12-week-12-testing-quality-assurance/) |
| 13 | CI/CD Automation | ⏳ Belum | [Folder](13-week-13-ci-cd-automation/) |
| 14 | Deployment & Monitoring | ⏳ Belum | [Folder](14-week-14-deployment-monitoring/) |
| 15 | Secure Mobile Development | ⏳ Belum | [Folder](15-week-15-secure-mobile-development/) |
| 16 | Final Project Expo | ⏳ Belum | [Folder](16-week-16-final-project-expo/) |

---

## Minggu 1 – Highlight

### Mini Assignment: Aplikasi Profil Mahasiswa
- **NIM:** `244107020030` ditampilkan sebagai badge biru
- **Widget tambahan:** `_InfoCard` reusable untuk Program Studi, Angkatan, Minat Utama, Platform
- **Test:** 8 widget tests memverifikasi nama, NIM, AppBar, ikon, dan struktur widget
- **Screenshot:** tersedia di `01-week-1.../screenshots/`

### Refleksi Kunci Minggu 1
1. **Native vs Cross-platform** → Pilih native untuk performa kritis & API platform terbaru; Flutter untuk produktivitas tim & codebase tunggal
2. **State & Widget Tree** → `UI = f(state)` — setState() memicu rebuild, Flutter diff tree untuk update minimal
3. **Commit Disiplin** → Commit kecil + pesan Conventional Commits = portfolio profesional + kolaborasi tim yang efektif

---

## Minggu 2 – Highlight

### Tugas Utama: Academic Overview & Dashboard Responsif
- **Layout Responsif:** Menggunakan `LayoutBuilder` dengan breakpoint `700px` (`kWideBreakpoint`) untuk beralih antara 1 kolom (layar sempit) dan 2 kolom (layar lebar).
- **Interaktivitas Tema:** Implementasi `StatefulWidget` dengan `CupertinoSwitch` untuk mengganti tema terang dan gelap secara *real-time*.
- **Aksesibilitas & Reusable Widget:** Ekstraksi komponen kartu menjadi widget `InfoCard` serta penambahan `Semantics` untuk *screen reader*.
- **Testing & Analisis:** Berhasil melewati verifikasi `flutter analyze` tanpa error serta lulus seluruh widget test di folder `test/`.

### Refleksi & Referensi Minggu 2
1. **Imperative vs Declarative UI** → Imperative mengubah UI langkah demi langkah secara manual; Declarative merekonstruksi UI secara reaktif berdasarkan state saat ini (`UI = f(state)`).
2. **Peran Expanded** → Sangat membantu dalam membagi ruang proporsional di dalam `Row`/`Column`, namun memicu error constraint unconstrained jika diletakkan di dalam container scroll horizontal/vertikal yang tak bertepi.
3. **Breakpoint & Theme** → Memastikan adaptasi visual optimal di berbagai ukuran perangkat serta meningkatkan kenyamanan dan aksesibilitas pengguna.

---

*Diperbarui: 3 September 2026*
