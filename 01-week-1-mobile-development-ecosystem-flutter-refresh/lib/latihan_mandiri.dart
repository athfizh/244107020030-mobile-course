void main() {
  // 1. Memanggil fungsi hitungLuasPersegiPanjang
  double luas = hitungLuasPersegiPanjang(10.5, 5.0);
  print('Luas persegi panjang: $luas');

  // 2 & 3. Inisialisasi class Profil dan menangani email kosong
  Profil profilSaya = Profil(
    nama: 'Athaulla Hafizh',
    nim: '244107020030',
    // email sengaja tidak diisi (null) untuk menguji null safety
  );

  // Penanganan null dengan operator ??
  String emailTampil = profilSaya.email ?? 'BELUM DIISI';
  print(
    'Nama: ${profilSaya.nama} | NIM: ${profilSaya.nim} | Email: $emailTampil',
  );
}

// Fungsi dengan parameter double
double hitungLuasPersegiPanjang(double panjang, double lebar) {
  return panjang * lebar;
}

// Class dengan properti yang boleh null (String?)
class Profil {
  String nama;
  String nim;
  String? email;

  Profil({required this.nama, required this.nim, this.email});
}
