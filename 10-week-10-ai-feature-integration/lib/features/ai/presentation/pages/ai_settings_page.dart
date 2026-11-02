import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/ai_providers.dart';

class AiSettingsPage extends ConsumerStatefulWidget {
  const AiSettingsPage({super.key});

  @override
  ConsumerState<AiSettingsPage> createState() => _AiSettingsPageState();
}

class _AiSettingsPageState extends ConsumerState<AiSettingsPage> {
  final _controller = TextEditingController();
  bool _obscure = true;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final value = _controller.text.trim();
    if (value.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('API key tidak boleh kosong.')),
      );
      return;
    }

    await ref.read(aiRepositoryProvider).saveApiKey(value);
    ref.invalidate(aiKeyMaskedProvider);
    if (!mounted) return;
    _controller.clear();
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('API key tersimpan.')));
  }

  Future<void> _clear() async {
    await ref.read(aiRepositoryProvider).clearApiKey();
    ref.invalidate(aiKeyMaskedProvider);
    if (!mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('API key dihapus.')));
  }

  @override
  Widget build(BuildContext context) {
    final maskedKey = ref.watch(aiKeyMaskedProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Pengaturan AI')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'API Key Gemini',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  maskedKey.when(
                    loading: () => const Text('Memuat...'),
                    error: (e, _) => Text('Gagal membaca key: $e'),
                    data: (value) => Text(
                      value == null
                          ? 'Belum diatur. Aplikasi berjalan pada Mode Demo.'
                          : 'Tersimpan: $value',
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _controller,
                    obscureText: _obscure,
                    decoration: InputDecoration(
                      labelText: 'API key baru',
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        tooltip: _obscure ? 'Tampilkan' : 'Sembunyikan',
                        icon: Icon(
                          _obscure ? Icons.visibility : Icons.visibility_off,
                        ),
                        onPressed: () => setState(() => _obscure = !_obscure),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      FilledButton(
                        onPressed: _save,
                        child: const Text('Simpan'),
                      ),
                      const SizedBox(width: 8),
                      TextButton(onPressed: _clear, child: const Text('Hapus')),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Catatan keamanan',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Key disimpan pada penyimpanan terenkripsi perangkat '
                    '(Keystore/Keychain) dan tidak pernah ditulis di kode '
                    'maupun repository. Jangan mengirim NIK, nomor telepon, '
                    'alamat, atau email ke layanan AI.',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
