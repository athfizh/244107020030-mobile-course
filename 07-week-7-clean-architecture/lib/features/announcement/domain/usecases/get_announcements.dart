import '../entities/announcement.dart';
import '../repositories/announcement_repository.dart';

class GetAnnouncements {
  final AnnouncementRepository _repository;
  const GetAnnouncements(this._repository);

  Future<List<Announcement>> call() => _repository.getAnnouncements();
}
