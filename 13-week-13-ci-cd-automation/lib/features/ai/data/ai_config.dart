/// Konfigurasi layanan AI.
///
/// Nama model disimpan di satu tempat agar mudah diganti ketika Google
/// merilis atau menghentikan versi tertentu. Nilai `gemini-3.8-flash`
/// dipakai karena model generasi sebelumnya sudah ditutup untuk pengguna baru.
class AiConfig {
  const AiConfig._();

  static const model = 'gemini-3.8-flash';
  static const baseUrl = 'https://generativelanguage.googleapis.com/v1beta';

  static const systemPrompt =
      'Kamu asisten kampus yang ramah. Jawab dalam Bahasa Indonesia, '
      'maksimal 2 kalimat, dan jangan meminta data pribadi pengguna.';

  /// Endpoint streaming. API key dikirim lewat header `x-goog-api-key`,
  /// bukan query string, supaya tidak muncul pada log URL.
  static Uri streamUri() =>
      Uri.parse('$baseUrl/models/$model:streamGenerateContent?alt=sse');
}
