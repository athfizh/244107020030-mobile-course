import '../entities/announcement.dart';

abstract class AnnouncementRepository {
  /// Mengambil satu halaman pengumuman.
  ///
  /// [limit] menentukan jumlah item per halaman dan [start] menentukan
  /// offset awal, sehingga daftar panjang tidak perlu dimuat sekaligus.
  Future<List<Announcement>> getAnnouncements({int limit = 10, int start = 0});

  Future<Announcement> getAnnouncementById(String id);
}
