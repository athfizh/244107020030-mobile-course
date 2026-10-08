import 'package:flutter_test/flutter_test.dart';

// =====================================================
// Unit Test: Domain Logic tanpa database/jaringan
// Use Case diuji dengan Repository palsu (Fake)
// =====================================================

import 'package:week7_clean_architecture/features/auth/domain/entities/session.dart';
import 'package:week7_clean_architecture/features/auth/domain/repositories/auth_repository.dart';
import 'package:week7_clean_architecture/features/auth/domain/usecases/login_usecase.dart';
import 'package:week7_clean_architecture/features/auth/domain/usecases/logout_usecase.dart';
import 'package:week7_clean_architecture/features/auth/domain/usecases/get_session_usecase.dart';
import 'package:week7_clean_architecture/features/announcement/domain/entities/announcement.dart';
import 'package:week7_clean_architecture/features/announcement/domain/repositories/announcement_repository.dart';
import 'package:week7_clean_architecture/features/announcement/domain/usecases/get_announcements.dart';
import 'package:week7_clean_architecture/features/announcement/domain/usecases/get_announcement_by_id.dart';

// ---- Fake Auth Repository ----
class FakeAuthRepository implements AuthRepository {
  String? _storedToken;

  @override
  Future<Session> login({required String email, required String password}) async {
    if (email == 'test@test.com' && password == 'password') {
      _storedToken = 'fake-access-token';
      return const Session(
        accessToken: 'fake-access-token',
        refreshToken: 'fake-refresh-token',
      );
    }
    throw Exception('Kredensial tidak valid');
  }

  @override
  Future<String?> getAccessToken() async => _storedToken;

  @override
  Future<void> clearTokens() async => _storedToken = null;
}

// ---- Fake Announcement Repository ----
class FakeAnnouncementRepository implements AnnouncementRepository {
  static final _data = [
    const Announcement(id: '1', title: 'Libur Nasional', body: 'Besok tidak ada kelas.'),
    const Announcement(id: '2', title: 'Ujian Tengah Semester', body: 'UTS dilaksanakan minggu depan.'),
  ];

  @override
  Future<List<Announcement>> getAnnouncements() async => _data;

  @override
  Future<Announcement> getAnnouncementById(String id) async {
    return _data.firstWhere(
      (a) => a.id == id,
      orElse: () => throw Exception('Pengumuman tidak ditemukan'),
    );
  }
}

void main() {
  // =====================================================
  // AUTH USE CASE TESTS
  // =====================================================
  group('LoginUseCase', () {
    late FakeAuthRepository fakeRepo;
    late LoginUseCase loginUseCase;

    setUp(() {
      fakeRepo = FakeAuthRepository();
      loginUseCase = LoginUseCase(fakeRepo);
    });

    test('login berhasil mengembalikan Session dengan token valid', () async {
      final session = await loginUseCase.call(
        email: 'test@test.com',
        password: 'password',
      );
      expect(session.accessToken, equals('fake-access-token'));
      expect(session.refreshToken, equals('fake-refresh-token'));
    });

    test('login gagal melempar exception untuk kredensial salah', () async {
      expect(
        () => loginUseCase.call(email: 'wrong@email.com', password: 'wrong'),
        throwsException,
      );
    });
  });

  group('GetSessionUseCase', () {
    test('mengembalikan false jika belum login', () async {
      final repo = FakeAuthRepository();
      final useCase = GetSessionUseCase(repo);
      expect(await useCase.call(), isFalse);
    });

    test('mengembalikan true setelah login berhasil', () async {
      final repo = FakeAuthRepository();
      await LoginUseCase(repo).call(
        email: 'test@test.com',
        password: 'password',
      );
      final useCase = GetSessionUseCase(repo);
      expect(await useCase.call(), isTrue);
    });
  });

  group('LogoutUseCase', () {
    test('logout membersihkan token sehingga sesi menjadi false', () async {
      final repo = FakeAuthRepository();
      await LoginUseCase(repo).call(
        email: 'test@test.com',
        password: 'password',
      );
      await LogoutUseCase(repo).call();
      expect(await GetSessionUseCase(repo).call(), isFalse);
    });
  });

  // =====================================================
  // ANNOUNCEMENT USE CASE TESTS
  // =====================================================
  group('GetAnnouncements', () {
    late FakeAnnouncementRepository fakeRepo;

    setUp(() => fakeRepo = FakeAnnouncementRepository());

    test('mengembalikan daftar pengumuman tidak kosong', () async {
      final useCase = GetAnnouncements(fakeRepo);
      final result = await useCase.call();
      expect(result, isNotEmpty);
      expect(result.length, equals(2));
    });

    test('item pertama memiliki id=1 dan judul benar', () async {
      final result = await GetAnnouncements(fakeRepo).call();
      expect(result.first.id, equals('1'));
      expect(result.first.title, equals('Libur Nasional'));
    });
  });

  group('GetAnnouncementById', () {
    late FakeAnnouncementRepository fakeRepo;

    setUp(() => fakeRepo = FakeAnnouncementRepository());

    test('mengembalikan pengumuman yang tepat berdasarkan id', () async {
      final useCase = GetAnnouncementById(fakeRepo);
      final ann = await useCase.call('2');
      expect(ann.id, equals('2'));
      expect(ann.title, equals('Ujian Tengah Semester'));
    });

    test('melempar exception untuk id yang tidak ada', () async {
      final useCase = GetAnnouncementById(fakeRepo);
      expect(() => useCase.call('999'), throwsException);
    });
  });
}
