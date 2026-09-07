import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Penentuan batas lebar layar untuk berubah dari 1 kolom menjadi 2 kolom.
// Menggunakan konstanta global (Refactoring Challenge) agar tidak ada hardcode berulang.
const double kWideBreakpoint = 700;

void main() => runApp(const AcademicOverviewApp());

class AcademicOverviewApp extends StatefulWidget {
  const AcademicOverviewApp({super.key});

  @override
  State<AcademicOverviewApp> createState() => _AcademicOverviewAppState();
}

class _AcademicOverviewAppState extends State<AcademicOverviewApp> {
  // State untuk menyimpan preferensi tema (gelap atau terang)
  bool isDark = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // Konfigurasi tema terang mengikuti Material 3 otomatis
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.indigo,
      ),
      // Konfigurasi tema gelap
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorSchemeSeed: Colors.indigo,
      ),
      // Menentukan mode tema berdasarkan state saat ini
      themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
      home: AcademicOverviewPage(
        isDark: isDark,
        onThemeChanged: (value) {
          setState(() {
            isDark = value;
          });
        },
      ),
    );
  }
}

class AcademicOverviewPage extends StatelessWidget {
  final bool isDark;
  final ValueChanged<bool> onThemeChanged;

  const AcademicOverviewPage({
    super.key,
    required this.isDark,
    required this.onThemeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Academic Overview'),
        actions: [
          Row(
            children: [
              Icon(isDark ? Icons.dark_mode : Icons.light_mode),
              const SizedBox(width: 8),
              // Memberikan deskripsi kepada screen reader tentang tombol switch
              Semantics(
                label: 'Sakelar tema gelap',
                toggled: isDark,
                child: CupertinoSwitch(
                  value: isDark,
                  onChanged: onThemeChanged,
                ),
              ),
              const SizedBox(width: 16),
            ],
          ),
        ],
      ),
      // LayoutBuilder bertugas mendeteksi batasan lebar perangkat saat ini
      body: LayoutBuilder(
        builder: (context, constraints) {
          // Bernilai true jika lebar perangkat >= 700 pixel
          final isWideScreen = constraints.maxWidth >= kWideBreakpoint;

          // SingleChildScrollView menjaga agar layar tidak overflow vertikal jika layarnya pendek
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Komponen Header ditaruh paling atas
                const ProfileHeader(),
                const SizedBox(height: 24),
                
                // --- Percabangan Tata Letak Responsif ---
                // Jika layar lebar, gunakan baris (Row) yang berisi 2 kolom kartu.
                if (isWideScreen)
                  const Column(
                    children: [
                      Row(
                        children: [
                          Expanded(child: InfoCard(title: 'SKS Ditempuh', value: '84', icon: Icons.book)),
                          SizedBox(width: 16),
                          Expanded(child: InfoCard(title: 'IPK', value: '3.85', icon: Icons.grade)),
                        ],
                      ),
                      SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(child: InfoCard(title: 'Kehadiran', value: '95%', icon: Icons.event_available)),
                          SizedBox(width: 16),
                          Expanded(child: InfoCard(title: 'Tugas Aktif', value: '3', icon: Icons.assignment)),
                        ],
                      ),
                    ],
                  )
                // Jika layar sempit (HP), tumpuk kartu ke bawah (1 kolom).
                else
                  const Column(
                    children: [
                      InfoCard(title: 'SKS Ditempuh', value: '84', icon: Icons.book),
                      SizedBox(height: 16),
                      InfoCard(title: 'IPK', value: '3.85', icon: Icons.grade),
                      SizedBox(height: 16),
                      InfoCard(title: 'Kehadiran', value: '95%', icon: Icons.event_available),
                      SizedBox(height: 16),
                      InfoCard(title: 'Tugas Aktif', value: '3', icon: Icons.assignment),
                    ],
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// Widget untuk Header Profil menggunakan Container, Row, Column, dan Expanded
class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        // Penggunaan Theme.of(context) agar warna menyesuaikan mode otomatis
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 30,
            child: Icon(Icons.person, size: 32),
          ),
          const SizedBox(width: 16),
          // Expanded berfungsi mengambil sisa ruang agar teks bisa membungkus ke bawah jika perlu
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Athaulla Hafizh',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Teknik Informatika (TI-3F)',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Widget Reusable (InfoCard) sesuai kriteria Refactoring Challenge
// Dengan memisahkan widget ini, kode untuk membuat kartu menjadi lebih rapi dan tidak duplikat
class InfoCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const InfoCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    // Membungkus card dengan semantics agar aksesibilitas lebih baik (dibaca 1 kesatuan)
    return Semantics(
      label: 'Informasi $title: $value',
      container: true,
      child: Card(
        elevation: 2,
        margin: EdgeInsets.zero,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Icon(icon, size: 28, color: Theme.of(context).colorScheme.primary),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      value,
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
