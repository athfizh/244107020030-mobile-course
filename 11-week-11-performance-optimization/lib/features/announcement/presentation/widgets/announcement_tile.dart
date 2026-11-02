import 'package:flutter/material.dart';

import '../../domain/entities/announcement.dart';

/// Item daftar pengumuman.
///
/// Dipisah menjadi widget `const` sendiri agar Flutter tidak membangun
/// ulang seluruh item ketika hanya satu bagian halaman berubah.
class AnnouncementTile extends StatelessWidget {
  const AnnouncementTile({super.key, required this.item, required this.onTap});

  final Announcement item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(child: Text(item.id)),
      title: Text(
        item.title,
        style: const TextStyle(fontWeight: FontWeight.bold),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(item.body, maxLines: 2, overflow: TextOverflow.ellipsis),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
