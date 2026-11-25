import 'package:flutter/material.dart';

import '../../../../core/monitoring.dart';

/// Halaman kecil untuk menguji telemetri rilis beta tanpa data sensitif.
///
/// Yang dikirim hanya nama event dan nama layar. Tidak ada email, token,
/// isi catatan, maupun data pribadi lain.
class BetaFeedbackPage extends StatefulWidget {
  const BetaFeedbackPage({super.key});

  @override
  State<BetaFeedbackPage> createState() => _BetaFeedbackPageState();
}

class _BetaFeedbackPageState extends State<BetaFeedbackPage> {
  bool _sending = false;

  Future<void> _sendEvent() async {
    setState(() => _sending = true);
    await Monitoring.logBetaFeedback('beta_feedback_page');
    if (!mounted) return;
    setState(() => _sending = false);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Event beta_feedback_sent dikirim tanpa data pribadi.'),
      ),
    );
  }

  Future<void> _sendError() async {
    setState(() => _sending = true);
    await Monitoring.recordTestError();
    if (!mounted) return;
    setState(() => _sending = false);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Error non-fatal dikirim ke Crashlytics.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Umpan Balik Beta')),
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
                    'Status Monitoring',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(Monitoring.status),
                  const SizedBox(height: 4),
                  const Text(
                    'Versi kandidat: 1.2.0+3',
                    style: TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Data yang dikirim hanya nama event dan nama layar. '
            'Jangan pernah mengirim email, token, atau isi catatan ke layanan '
            'monitoring.',
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: _sending ? null : _sendEvent,
            icon: const Icon(Icons.analytics_outlined),
            label: const Text('Kirim Event Beta'),
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: _sending ? null : _sendError,
            icon: const Icon(Icons.bug_report_outlined),
            label: const Text('Uji Error Non-Fatal'),
          ),
          const SizedBox(height: 24),
          const Text(
            'Catatan: event dan error hanya terkirim bila Firebase berhasil '
            'diinisialisasi. Bila status menunjukkan Mode lokal, kejadian tetap '
            'tercatat di logcat dengan tag monitoring.',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
