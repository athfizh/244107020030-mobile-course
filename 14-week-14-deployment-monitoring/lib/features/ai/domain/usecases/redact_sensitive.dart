/// Menyamarkan data pribadi sebelum prompt dikirim ke layanan AI.
///
/// Aturan yang dipakai:
/// - NIK 16 digit menjadi `[NIK]`
/// - Nomor HP berawalan 08 menjadi `[NO_HP]`
/// - Alamat email menjadi `[EMAIL]`
class RedactSensitive {
  const RedactSensitive();

  static final _nik = RegExp(r'\b\d{16}\b');
  static final _phone = RegExp(r'\b08\d{8,11}\b');
  static final _email = RegExp(r'[\w.+-]+@[\w-]+\.[\w.]+');

  String call(String input) {
    var result = input;
    result = result.replaceAll(_nik, '[NIK]');
    result = result.replaceAll(_phone, '[NO_HP]');
    result = result.replaceAll(_email, '[EMAIL]');
    return result;
  }
}
