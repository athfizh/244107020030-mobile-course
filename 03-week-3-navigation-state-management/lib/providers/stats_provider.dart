// AI Challenge — Provider statistik dengan simulasi kegagalan 30% (stats_provider.dart)
// AsyncNotifier dipilih karena data diambil secara asinkron (simulasi network).
// Random().nextDouble() < 0.3 mensimulasikan kegagalan 30% seperti kondisi jaringan nyata.

import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StatsNotifier extends AsyncNotifier<List<String>> {
  @override
  Future<List<String>> build() async {
    // Panggil _fetchStats() saat provider pertama kali diinisialisasi
    return await _fetchStats();
  }

  // Method internal untuk fetch data — dipisah agar bisa dipanggil ulang di retry()
  Future<List<String>> _fetchStats() async {
    // Simulasi network delay 2 detik — selama ini UI tampil loading
    await Future.delayed(const Duration(seconds: 2));

    // Simulasi kegagalan 30%: angka random 0.0–1.0, gagal jika < 0.3
    if (Random().nextDouble() < 0.3) {
      throw Exception('Gagal mengambil data statistik');
    }

    // State success — return list 3 item statistik
    return ['Total Pengguna: 1.240', 'Sesi Aktif: 87', 'Error Rate: 0.3%'];
  }

  // Retry: set ke AsyncLoading dulu, lalu jalankan ulang fetch
  // AsyncValue.guard otomatis tangkap exception → AsyncError (tidak perlu try/catch manual)
  Future<void> retry() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_fetchStats);
  }
}

// Provider dideklarasikan dengan tipe eksplisit — tidak ambigu dan compile-safe
final statsProvider =
    AsyncNotifierProvider<StatsNotifier, List<String>>(StatsNotifier.new);
