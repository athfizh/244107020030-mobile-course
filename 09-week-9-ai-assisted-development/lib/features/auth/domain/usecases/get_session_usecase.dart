import '../repositories/auth_repository.dart';

class GetSessionUseCase {
  final AuthRepository _repository;
  const GetSessionUseCase(this._repository);

  Future<bool> call() async {
    final token = await _repository.getAccessToken();
    return token != null;
  }
}
