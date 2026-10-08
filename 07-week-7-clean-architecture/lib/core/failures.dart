// Domain: objek kegagalan murni Dart (tidak bergantung pada Dio/Flutter).
abstract class Failure {
  final String message;
  const Failure(this.message);
}

class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure() : super('Sesi berakhir, silakan login ulang.');
}

class NetworkFailure extends Failure {
  const NetworkFailure() : super('Tidak ada koneksi internet.');
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
