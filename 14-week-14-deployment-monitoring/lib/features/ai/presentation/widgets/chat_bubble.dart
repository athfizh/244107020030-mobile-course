import 'package:flutter/material.dart';

import '../../domain/entities/chat_message.dart';

class ChatBubble extends StatelessWidget {
  const ChatBubble({super.key, required this.message});

  final ChatMessage message;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isUser = message.fromUser;

    // RepaintBoundary mengisolasi gelembung ini sehingga aliran teks pada
    // gelembung AI terakhir tidak memaksa seluruh daftar chat digambar ulang.
    return RepaintBoundary(
      child: Align(
        alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 4),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          constraints: const BoxConstraints(maxWidth: 300),
          decoration: BoxDecoration(
            color: isUser
                ? scheme.primaryContainer
                : scheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                message.text.isEmpty ? '...' : message.text,
                style: TextStyle(
                  color: isUser ? scheme.onPrimaryContainer : scheme.onSurface,
                ),
              ),
              if (message.fromCache)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    'dari cache',
                    style: TextStyle(
                      fontSize: 10,
                      color: scheme.outline,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
