/// Jawaban lokal untuk Mode Demo.
///
/// Dipakai ketika API key belum diatur, sehingga aplikasi tetap bisa
/// didemokan tanpa memanggil layanan eksternal.
class DemoAnswers {
  const DemoAnswers._();

  static const _fallback =
      'Mode Demo aktif. API key Gemini belum diatur, jadi saya menjawab dari '
      'data lokal. Buka Pengaturan AI untuk menambahkan key.';

  static const _answers = <String, String>{
    'krs':
        'KRS adalah Kartu Rencana Studi yang diisi setiap awal semester. '
        'Isinya daftar mata kuliah yang akan diambil beserta jumlah SKS-nya.',
    'sks':
        'SKS adalah Satuan Kredit Semester. Satu SKS setara sekitar 50 menit '
        'tatap muka per minggu dalam satu semester.',
    'ukt':
        'UKT adalah Uang Kuliah Tunggal yang dibayarkan setiap semester. '
        'Besarnya ditentukan berdasarkan kelompok kemampuan ekonomi mahasiswa.',
    'uts':
        'UTS adalah Ujian Tengah Semester yang biasanya dilaksanakan pada '
        'pekan ke-8 perkuliahan.',
    'uas':
        'UAS adalah Ujian Akhir Semester yang dilaksanakan pada akhir '
        'semester sebelum masa libur.',
    'ipk':
        'IPK adalah Indeks Prestasi Kumulatif, rata-rata nilai seluruh '
        'semester yang dihitung dari total mutu dibagi total SKS.',
    'libur':
        'Jadwal libur nasional dan cuti bersama diumumkan lewat kanal '
        'resmi kampus. Cek halaman Pengumuman untuk informasi terbaru.',
  };

  static String answerFor(String prompt) {
    final lower = prompt.toLowerCase();
    for (final entry in _answers.entries) {
      if (lower.contains(entry.key)) return entry.value;
    }
    return _fallback;
  }
}
