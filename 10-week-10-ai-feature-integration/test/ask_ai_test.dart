import 'package:flutter_test/flutter_test.dart';
import 'package:week10_ai_feature/core/failures.dart';
import 'package:week10_ai_feature/features/ai/domain/repositories/ai_repository.dart';
import 'package:week10_ai_feature/features/ai/domain/usecases/ask_ai.dart';

class FakeAiRepository implements AiRepository {
  FakeAiRepository({
    this.chunks = const ['Halo', ' dari AI'],
    this.error,
    this.fromCache = false,
  });

  final List<String> chunks;
  final Failure? error;
  final bool fromCache;
  final List<String> prompts = [];

  @override
  Stream<({String chunk, bool fromCache})> ask(String prompt) async* {
    prompts.add(prompt);
    if (error != null) throw error!;
    for (final chunk in chunks) {
      yield (chunk: chunk, fromCache: fromCache);
    }
  }

  @override
  Future<String?> maskedApiKey() async => null;

  @override
  Future<void> saveApiKey(String apiKey) async {}

  @override
  Future<void> clearApiKey() async {}
}

void main() {
  group('AskAi', () {
    test('prompt kosong ditolak tanpa memanggil repository', () async {
      final repo = FakeAiRepository();
      final events = await AskAi(repo).call('   ').toList();

      expect(events, hasLength(1));
      expect(events.single.failure, isA<ValidationFailure>());
      expect(repo.prompts, isEmpty);
    });

    test('prompt valid dialirkan bertahap', () async {
      final repo = FakeAiRepository();
      final events = await AskAi(repo).call('Apa itu KRS?').toList();

      expect(events.map((e) => e.chunk).join(), 'Halo dari AI');
      expect(events.every((e) => e.failure == null), isTrue);
      expect(repo.prompts.single, 'Apa itu KRS?');
    });

    test('data pribadi disamarkan sebelum dikirim', () async {
      final repo = FakeAiRepository();
      await AskAi(repo).call('NIK 3573012345678901, email a@b.co').toList();

      expect(repo.prompts.single.contains('3573012345678901'), isFalse);
      expect(repo.prompts.single.contains('a@b.co'), isFalse);
      expect(repo.prompts.single, contains('[NIK]'));
      expect(repo.prompts.single, contains('[EMAIL]'));
    });

    test('kegagalan dari repository diteruskan sebagai Failure', () async {
      final repo = FakeAiRepository(error: const AiQuotaFailure());
      final events = await AskAi(repo).call('Halo').toList();

      expect(events.single.failure, isA<AiQuotaFailure>());
    });

    test('penanda fromCache diteruskan ke pemanggil', () async {
      final repo = FakeAiRepository(
        chunks: const ['dari cache'],
        fromCache: true,
      );
      final events = await AskAi(repo).call('Apa itu KRS?').toList();

      expect(events.single.fromCache, isTrue);
    });

    test('batas permintaan per sesi ditegakkan', () async {
      final repo = FakeAiRepository(chunks: const ['ok']);
      final askAi = AskAi(repo, maxRequests: 2);

      await askAi.call('satu').toList();
      await askAi.call('dua').toList();
      final third = await askAi.call('tiga').toList();

      expect(askAi.remainingRequests, 0);
      expect(third.single.failure, isA<ValidationFailure>());
      expect(repo.prompts, hasLength(2));
    });
  });
}
