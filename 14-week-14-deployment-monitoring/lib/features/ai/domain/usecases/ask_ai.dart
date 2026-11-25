import '../../../../core/failures.dart';
import '../repositories/ai_repository.dart';
import 'redact_sensitive.dart';

/// Use Case utama fitur AI.
///
/// Tanggung jawabnya tiga: memvalidasi prompt, menyamarkan data pribadi,
/// dan membatasi jumlah permintaan per sesi.
class AskAi {
  AskAi(this._repository, {this.maxRequests = 10, RedactSensitive? redact})
    : _redact = redact ?? const RedactSensitive();

  final AiRepository _repository;
  final RedactSensitive _redact;
  final int maxRequests;

  int _used = 0;

  int get usedRequests => _used;
  int get remainingRequests => (maxRequests - _used).clamp(0, maxRequests);

  /// Mengembalikan aliran jawaban, atau aliran berisi satu kegagalan validasi.
  Stream<({String chunk, bool fromCache, Failure? failure})> call(
    String prompt,
  ) async* {
    final trimmed = prompt.trim();
    if (trimmed.isEmpty) {
      yield (
        chunk: '',
        fromCache: false,
        failure: const ValidationFailure('Pertanyaan tidak boleh kosong.'),
      );
      return;
    }

    if (_used >= maxRequests) {
      yield (
        chunk: '',
        fromCache: false,
        failure: const ValidationFailure(
          'Batas demo tercapai. Coba lagi pada sesi berikutnya.',
        ),
      );
      return;
    }

    _used++;

    try {
      await for (final event in _repository.ask(_redact(trimmed))) {
        yield (chunk: event.chunk, fromCache: event.fromCache, failure: null);
      }
    } on Failure catch (failure) {
      yield (chunk: '', fromCache: false, failure: failure);
    } catch (error) {
      yield (
        chunk: '',
        fromCache: false,
        failure: UnknownFailure('Gagal menghubungi layanan AI: $error'),
      );
    }
  }
}
