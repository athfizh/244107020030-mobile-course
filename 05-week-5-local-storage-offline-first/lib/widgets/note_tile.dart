import 'package:flutter/material.dart';
import '../data/local/note.dart';

class NoteTile extends StatelessWidget {
  final Note note;
  final VoidCallback onDelete;
  final VoidCallback onTap;

  const NoteTile({
    super.key,
    required this.note,
    required this.onDelete,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: note.dirty
          ? const Icon(Icons.cloud_off, color: Colors.orange, size: 20)
          : const Icon(Icons.cloud_done, color: Colors.green, size: 20),
      title: Text(
        note.title,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (note.body.isNotEmpty)
            Text(
              note.body,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          Text(
            _formatDate(note.updatedAt),
            style: Theme.of(context).textTheme.labelSmall,
          ),
        ],
      ),
      trailing: IconButton(
        icon: const Icon(Icons.delete_outline, color: Colors.red),
        onPressed: onDelete,
      ),
      onTap: onTap,
    );
  }

  String _formatDate(DateTime dt) {
    return '${dt.day}/${dt.month}/${dt.year} ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }
}
