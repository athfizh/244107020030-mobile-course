import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/prefs.dart';

// ─── Providers ──────────────────────────────────────────────────────────────
final prefsRepositoryProvider = Provider((ref) => PrefsRepository());

final darkModeProvider =
    AsyncNotifierProvider<DarkModeNotifier, bool>(DarkModeNotifier.new);

final lastOpenedProvider = FutureProvider<String?>((ref) {
  return ref.watch(prefsRepositoryProvider).getLastOpened();
});

final forceOfflineProvider =
    AsyncNotifierProvider<ForceOfflineNotifier, bool>(ForceOfflineNotifier.new);

// ─── Notifier ───────────────────────────────────────────────────────────────
class DarkModeNotifier extends AsyncNotifier<bool> {
  @override
  Future<bool> build() => ref.watch(prefsRepositoryProvider).getDarkMode();

  Future<void> toggle() async {
    final next = !(state.value ?? false);
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(prefsRepositoryProvider).setDarkMode(next);
      return next;
    });
  }
}

class ForceOfflineNotifier extends AsyncNotifier<bool> {
  @override
  Future<bool> build() => ref.watch(prefsRepositoryProvider).getForceOffline();

  Future<void> toggle() async {
    final next = !(state.value ?? false);
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(prefsRepositoryProvider).setForceOffline(next);
      return next;
    });
  }
}

// ─── UI ───────────────────────────────────────────────────────────────────────
class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final darkModeAsync = ref.watch(darkModeProvider);
    final forceOfflineAsync = ref.watch(forceOfflineProvider);
    final lastOpenedAsync = ref.watch(lastOpenedProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pengaturan'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ListView(
        children: [
          darkModeAsync.when(
            loading: () => const ListTile(title: Text('Memuat mode gelap...')),
            error: (e, _) => ListTile(title: Text('Error: $e')),
            data: (isDark) => SwitchListTile(
              title: const Text('Mode Gelap'),
              subtitle: const Text('Ganti tema aplikasi'),
              secondary: Icon(isDark ? Icons.dark_mode : Icons.light_mode),
              value: isDark,
              onChanged: (_) => ref.read(darkModeProvider.notifier).toggle(),
            ),
          ),
          forceOfflineAsync.when(
            loading: () => const ListTile(title: Text('Memuat status offline...')),
            error: (e, _) => ListTile(title: Text('Error: $e')),
            data: (isOffline) => SwitchListTile(
              title: const Text('Simulasi Offline'),
              subtitle: const Text('Paksa aplikasi tidak menggunakan internet'),
              secondary: Icon(isOffline ? Icons.wifi_off : Icons.wifi),
              value: isOffline,
              onChanged: (_) => ref.read(forceOfflineProvider.notifier).toggle(),
            ),
          ),
          const Divider(),
          lastOpenedAsync.when(
            loading: () => const ListTile(
              leading: Icon(Icons.access_time),
              title: Text('Terakhir dibuka'),
              subtitle: Text('Memuat...'),
            ),
            error: (e, _) => const ListTile(
              leading: Icon(Icons.error_outline),
              title: Text('Gagal memuat waktu'),
            ),
            data: (time) => ListTile(
              leading: const Icon(Icons.access_time),
              title: const Text('Terakhir dibuka'),
              subtitle: Text(time ?? 'Belum pernah dibuka sebelumnya'),
            ),
          ),
        ],
      ),
    );
  }
}
