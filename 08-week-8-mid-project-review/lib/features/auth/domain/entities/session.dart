// Entity murni Dart: tidak ada toMap/fromJson di sini.
// Hanya merepresentasikan sesi pengguna yang sudah login.

class Session {
  final String accessToken;
  final String refreshToken;

  const Session({
    required this.accessToken,
    required this.refreshToken,
  });
}
