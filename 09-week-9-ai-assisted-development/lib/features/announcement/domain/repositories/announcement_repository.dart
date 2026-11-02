import '../entities/announcement.dart';

abstract class AnnouncementRepository {
  Future<List<Announcement>> getAnnouncements();
  Future<Announcement> getAnnouncementById(String id);
}
