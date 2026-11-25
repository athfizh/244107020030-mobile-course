import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../../core/failures.dart';
import 'ai_config.dart';

/// Klien HTTP untuk Gemini API dengan mode streaming.
class AiService {
  AiService({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  static const _maxAttempts = 3;

  /// Mengalirkan potongan teks dari endpoint `streamGenerateContent`.
  ///
  /// Kode 503 (layanan sedang sibuk) dicoba ulang maksimal tiga kali
  /// dengan jeda bertingkat sebelum menyerah.
  Stream<String> stream(String prompt, {required String apiKey}) async* {
    http.StreamedResponse? response;

    for (var attempt = 1; attempt <= _maxAttempts; attempt++) {
      final request = http.Request('POST', AiConfig.streamUri())
        ..headers['x-goog-api-key'] = apiKey
        ..headers['Content-Type'] = 'application/json'
        ..body = jsonEncode({
          'systemInstruction': {
            'parts': [
              {'text': AiConfig.systemPrompt},
            ],
          },
          'contents': [
            {
              'role': 'user',
              'parts': [
                {'text': prompt},
              ],
            },
          ],
        });

      try {
        // Model generasi baru bisa butuh lebih dari dua menit sebelum
        // mengirim byte pertama, jadi tidak ada batas waktu di tahap ini.
        response = await _client.send(request);
      } catch (_) {
        throw const NetworkFailure();
      }

      if (response.statusCode != 503) break;

      if (attempt < _maxAttempts) {
        await response.stream.drain<void>();
        await Future<void>.delayed(Duration(seconds: attempt * 2));
      }
    }

    if (response == null) {
      throw const AiServiceFailure();
    }

    if (response.statusCode == 401 || response.statusCode == 403) {
      throw const AiKeyMissingFailure(
        'API key ditolak. Periksa kembali key Anda.',
      );
    }
    if (response.statusCode == 429) {
      throw const AiQuotaFailure();
    }
    if (response.statusCode == 404) {
      throw const AiServiceFailure(
        'Model AI tidak tersedia. Periksa konfigurasi model pada kode.',
      );
    }
    if (response.statusCode == 503) {
      throw const AiServiceFailure(
        'Layanan AI sedang sibuk setelah tiga percobaan. Coba lagi nanti.',
      );
    }
    if (response.statusCode != 200) {
      throw AiServiceFailure(
        'Layanan AI mengembalikan kode ${response.statusCode}.',
      );
    }

    final buffer = StringBuffer();

    // Endpoint SSE Gemini kadang tidak menutup koneksi setelah jawaban
    // selesai, dan byte pertama bisa lama karena model berpikir lebih dulu.
    // Timeout diam 5 menit dipakai sebagai jaring pengaman agar aliran
    // berhenti sendiri ketika benar-benar tidak ada data baru.
    final lines = response.stream
        .timeout(
          const Duration(seconds: 300),
          onTimeout: (sink) => sink.close(),
        )
        .transform(utf8.decoder)
        .transform(const LineSplitter());

    await for (final line in lines) {
      final trimmed = line.trim();
      if (!trimmed.startsWith('data:')) continue;

      final payload = trimmed.substring(5).trim();
      if (payload.isEmpty || payload == '[DONE]') continue;

      final chunk = _extractText(payload);
      if (chunk == null || chunk.isEmpty) continue;

      buffer.write(chunk);
      yield chunk;
    }

    if (buffer.isEmpty) {
      throw const AiServiceFailure('Jawaban AI kosong. Coba lagi.');
    }
  }

  String? _extractText(String payload) {
    try {
      final data = jsonDecode(payload);
      if (data is! Map<String, dynamic>) return null;

      final candidates = data['candidates'];
      if (candidates is! List || candidates.isEmpty) return null;

      final content = (candidates.first as Map<String, dynamic>)['content'];
      if (content is! Map<String, dynamic>) return null;

      final parts = content['parts'];
      if (parts is! List || parts.isEmpty) return null;

      final text = (parts.first as Map<String, dynamic>)['text'];
      return text is String ? text : null;
    } catch (_) {
      return null;
    }
  }

  void dispose() => _client.close();
}
