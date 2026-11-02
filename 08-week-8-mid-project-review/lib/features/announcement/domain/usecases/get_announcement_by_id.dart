import '../entities/announcement.dart';
import '../repositories/announcement_repository.dart';

class GetAnnouncementById {
  final AnnouncementRepository _repository;
  const GetAnnouncementById(this._repository);

  Future<Announcement> call(String id) =>
      _repository.getAnnouncementById(id);
}
