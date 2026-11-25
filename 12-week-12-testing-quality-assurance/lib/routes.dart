class AppRoutes {
  static const login = '/login';
  static const home = '/';
  static const announcements = '/pengumuman';
  static const announcementDetail = '/pengumuman/:id';
  static const notes = '/notes';
  static const ai = '/ai';
  static const aiSettings = '/ai/pengaturan';

  static String announcementDetailPath(String id) => '/pengumuman/$id';
}
