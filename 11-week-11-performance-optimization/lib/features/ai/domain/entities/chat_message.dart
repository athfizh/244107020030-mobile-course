class ChatMessage {
  const ChatMessage({
    required this.text,
    required this.fromUser,
    this.fromCache = false,
  });

  final String text;
  final bool fromUser;
  final bool fromCache;

  ChatMessage copyWith({String? text, bool? fromCache}) => ChatMessage(
    text: text ?? this.text,
    fromUser: fromUser,
    fromCache: fromCache ?? this.fromCache,
  );
}
