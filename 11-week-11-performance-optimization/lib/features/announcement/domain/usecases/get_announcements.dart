import '../entities/announcement.dart';
import '../repositories/announcement_repository.dart';

class GetAnnouncements {
  const GetAnnouncements(this._repository);

  final AnnouncementRepository _repository;

  Future<List<Announcement>> call({int limit = 10, int start = 0}) =>
      _repository.getAnnouncements(limit: limit, start: start);
}
