// Entity bisnis murni: tidak ada fromJson/toMap di sini.

class Announcement {
  final String id;
  final String title;
  final String body;

  const Announcement({
    required this.id,
    required this.title,
    required this.body,
  });
}
