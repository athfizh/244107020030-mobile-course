/// Kontrak integrasi layanan AI.
///
/// Antarmuka ini sengaja tidak mengimpor Flutter, Dio, http, maupun
/// shared_preferences agar tetap berada di Domain Layer.
abstract class AiRepository {
  /// Mengirim prompt lalu mengalirkan potongan jawaban.
  ///
  /// Setiap potongan membawa penanda `fromCache` agar UI bisa membedakan
  /// jawaban baru dari layanan AI dan jawaban yang diambil dari cache lokal.
  Stream<({String chunk, bool fromCache})> ask(String prompt);

  /// Mengembalikan API key dalam bentuk tersamar, atau null bila belum diatur.
  Future<String?> maskedApiKey();

  /// Menyimpan API key pada penyimpanan terenkripsi.
  Future<void> saveApiKey(String apiKey);

  /// Menghapus API key yang tersimpan.
  Future<void> clearApiKey();
}
