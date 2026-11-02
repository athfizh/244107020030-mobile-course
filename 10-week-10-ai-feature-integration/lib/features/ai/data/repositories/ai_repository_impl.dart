import '../../domain/repositories/ai_repository.dart';
import '../ai_cache.dart';
import '../ai_key_store.dart';
import '../ai_service.dart';
import '../demo_answers.dart';

class AiRepositoryImpl implements AiRepository {
  AiRepositoryImpl({AiService? service, AiKeyStore? keyStore, AiCache? cache})
    : _service = service ?? AiService(),
      _keyStore = keyStore ?? const AiKeyStore(),
      _cache = cache ?? AiCache();

  final AiService _service;
  final AiKeyStore _keyStore;
  final AiCache _cache;

  @override
  Stream<({String chunk, bool fromCache})> ask(String prompt) async* {
    final cached = await _cache.read(prompt);
    if (cached != null) {
      yield (chunk: cached, fromCache: true);
      return;
    }

    final apiKey = await _keyStore.read();
    if (apiKey == null) {
      yield (chunk: DemoAnswers.answerFor(prompt), fromCache: false);
      return;
    }

    final buffer = StringBuffer();
    await for (final chunk in _service.stream(prompt, apiKey: apiKey)) {
      buffer.write(chunk);
      yield (chunk: chunk, fromCache: false);
    }

    if (buffer.isNotEmpty) {
      await _cache.write(prompt, buffer.toString());
    }
  }

  @override
  Future<String?> maskedApiKey() async {
    final key = await _keyStore.read();
    return key == null ? null : AiKeyStore.mask(key);
  }

  @override
  Future<void> saveApiKey(String apiKey) => _keyStore.write(apiKey);

  @override
  Future<void> clearApiKey() => _keyStore.delete();
}
