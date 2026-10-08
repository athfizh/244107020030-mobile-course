import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import '../../domain/usecases/get_session_usecase.dart';
import '../../data/secure_storage.dart';

// Provider untuk repository (implementasi di data layer)
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(storage: secureStorageInstance);
});

// Use Case providers
final loginUseCaseProvider = Provider<LoginUseCase>((ref) {
  return LoginUseCase(ref.watch(authRepositoryProvider));
});
final logoutUseCaseProvider = Provider<LogoutUseCase>((ref) {
  return LogoutUseCase(ref.watch(authRepositoryProvider));
});
final getSessionUseCaseProvider = Provider<GetSessionUseCase>((ref) {
  return GetSessionUseCase(ref.watch(authRepositoryProvider));
});

// State Notifier
final authStateProvider = AsyncNotifierProvider<AuthNotifier, bool>(AuthNotifier.new);

class AuthNotifier extends AsyncNotifier<bool> {
  @override
  Future<bool> build() async {
    return ref.watch(getSessionUseCaseProvider).call();
  }

  Future<void> login(String email, String password) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(loginUseCaseProvider).call(email: email, password: password);
      return true;
    });
  }

  Future<void> logout() async {
    await ref.read(logoutUseCaseProvider).call();
    ref.invalidateSelf();
  }
}
