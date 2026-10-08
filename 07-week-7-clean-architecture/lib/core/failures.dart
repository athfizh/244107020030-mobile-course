sealed class Failure {
  const Failure(this.message);
  final String message;
}

class LocalFailure extends Failure {
  const LocalFailure(super.message);
}

class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'Tidak ada koneksi internet.']);
}

class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure() : super('Sesi berakhir, silakan login ulang.');
}

class TimeoutFailure extends Failure {
  const TimeoutFailure() : super('Koneksi habis waktu, coba lagi.');
}

class ServerFailure extends Failure {
  const ServerFailure([super.message = 'Terjadi kesalahan server.']);
}

class UnknownFailure extends Failure {
  const UnknownFailure([super.message = 'Terjadi kesalahan tidak terduga.']);
}
