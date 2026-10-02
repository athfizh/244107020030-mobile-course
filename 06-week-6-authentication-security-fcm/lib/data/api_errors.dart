import 'package:dio/dio.dart';

String getFriendlyErrorMessage(Object error) {
  if (error is DioException) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'Koneksi terputus. Periksa internet Anda.';
      case DioExceptionType.badResponse:
        final code = error.response?.statusCode;
        if (code == 401) return 'Sesi berakhir, silakan login ulang.';
        if (code == 403) return 'Anda tidak memiliki akses.';
        if (code == 404) return 'Data tidak ditemukan.';
        return 'Terjadi kesalahan pada server.';
      case DioExceptionType.connectionError:
        return 'Sedang luring (offline).';
      default:
        return 'Gagal menghubungi server.';
    }
  }
  return error.toString();
}
