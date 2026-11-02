import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/announcement_repository_impl.dart';
import '../../domain/entities/announcement.dart';
import '../../domain/repositories/announcement_repository.dart';
import '../../domain/usecases/get_announcements.dart';
import '../../domain/usecases/get_announcement_by_id.dart';
import '../../data/dio_client.dart';

final announcementRepositoryProvider = Provider<AnnouncementRepository>((ref) {
  return AnnouncementRepositoryImpl(dio: announcementDio);
});

final getAnnouncementsProvider = Provider<GetAnnouncements>((ref) {
  return GetAnnouncements(ref.watch(announcementRepositoryProvider));
});

final getAnnouncementByIdProvider = Provider<GetAnnouncementById>((ref) {
  return GetAnnouncementById(ref.watch(announcementRepositoryProvider));
});

final announcementsProvider = FutureProvider<List<Announcement>>((ref) async {
  return ref.watch(getAnnouncementsProvider).call();
});

final announcementDetailProvider = FutureProvider.family<Announcement, String>((ref, id) async {
  return ref.watch(getAnnouncementByIdProvider).call(id);
});
