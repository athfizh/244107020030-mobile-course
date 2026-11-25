import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/ai_repository_impl.dart';
import '../../domain/entities/chat_message.dart';
import '../../domain/repositories/ai_repository.dart';
import '../../domain/usecases/ask_ai.dart';

final aiRepositoryProvider = Provider<AiRepository>((ref) {
  return AiRepositoryImpl();
});

final askAiProvider = Provider<AskAi>((ref) {
  return AskAi(ref.watch(aiRepositoryProvider));
});

final aiKeyMaskedProvider = FutureProvider<String?>((ref) {
  return ref.watch(aiRepositoryProvider).maskedApiKey();
});

final aiChatProvider = NotifierProvider<AiChatNotifier, List<ChatMessage>>(
  AiChatNotifier.new,
);

class AiChatNotifier extends Notifier<List<ChatMessage>> {
  bool _streaming = false;

  bool get isStreaming => _streaming;

  @override
  List<ChatMessage> build() => const [];

  Future<void> send(String prompt) async {
    if (_streaming) return;

    final question = prompt.trim();
    if (question.isEmpty) return;

    _streaming = true;
    state = [...state, ChatMessage(text: question, fromUser: true)];

    final index = state.length;
    state = [...state, const ChatMessage(text: '', fromUser: false)];

    final buffer = StringBuffer();
    var fromCache = false;

    try {
      await for (final event in ref.read(askAiProvider).call(question)) {
        if (event.failure != null) {
          state = [
            ...state.take(index),
            ChatMessage(text: event.failure!.message, fromUser: false),
          ];
          break;
        }

        fromCache = event.fromCache;
        buffer.write(event.chunk);
        state = [
          ...state.take(index),
          ChatMessage(
            text: buffer.toString(),
            fromUser: false,
            fromCache: fromCache,
          ),
        ];
      }
    } finally {
      _streaming = false;
    }
  }

  void clear() {
    state = const [];
  }
}
