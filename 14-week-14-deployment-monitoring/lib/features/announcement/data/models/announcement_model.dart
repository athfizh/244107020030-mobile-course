// Model: parsing JSON + mapping ke Entity.

import '../../domain/entities/announcement.dart';

class AnnouncementModel {
  final String id;
  final String title;
  final String body;

  const AnnouncementModel({
    required this.id,
    required this.title,
    required this.body,
  });

  factory AnnouncementModel.fromJson(Map<String, dynamic> json) {
    return AnnouncementModel(
      id: json['id']?.toString() ?? '',
      title: json['title'] as String? ?? 'Tanpa Judul',
      body: json['body'] as String? ?? '',
    );
  }

  Announcement toEntity() => Announcement(id: id, title: title, body: body);
}
