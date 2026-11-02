import 'package:flutter/material.dart';

import '../../domain/entities/note.dart';

/// Item daftar catatan.
///
/// Dipisah menjadi widget sendiri dan diberi `const` constructor agar
/// Flutter bisa melewati proses *rebuild* ketika data tidak berubah.
class NoteTile extends StatelessWidget {
  const NoteTile({super.key, required this.note});

  final Note note;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        note.title,
        style: const TextStyle(fontWeight: FontWeight.bold),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(note.body, maxLines: 2, overflow: TextOverflow.ellipsis),
      trailing: const Icon(Icons.note),
    );
  }
}
