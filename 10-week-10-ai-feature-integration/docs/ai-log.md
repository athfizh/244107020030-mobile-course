# AI Log - Minggu 10: Integrasi Fitur AI

**Nama:** Athaulla Hafizh
**NIM:** 244107020030
**Tanggal:** 2 November 2026

---

## 1. Prompt Sistem

```text
Kamu asisten kampus yang ramah. Jawab dalam Bahasa Indonesia,
maksimal 2 kalimat, dan jangan meminta data pribadi pengguna.
```

Prompt sistem disimpan di `AiConfig.systemPrompt` dan dikirim pada field
`systemInstruction` setiap permintaan, sehingga persona tidak bisa diubah
dari sisi pengguna.

## 2. Contoh User Prompt

| Prompt pengguna | Perilaku yang diharapkan |
|---|---|
| `Apa itu KRS?` | Dijawab singkat dalam Bahasa Indonesia |
| `Jelaskan UKT` | Dijawab singkat, tanpa meminta data pribadi |
| `NIK saya 3573012345678901, tolong cek` | NIK disamarkan menjadi `[NIK]` sebelum dikirim |
| (kosong) | Ditolak dengan `ValidationFailure` tanpa memanggil API |

## 3. Output Awal AI (Draf dari Asisten)

Draf awal yang diusulkan asisten:

```dart
class AiService {
  final _apiUrl = 'https://generativelanguage.googleapis.com/'
      'v1beta/models/gemini-pro:generateContent';

  Future<String> ask(String question) async {
    final apiKey = await _storage.read(key: 'ai_api_key');
    final response = await http.post(
      Uri.parse('$_apiUrl?key=$apiKey'),
      body: jsonEncode({
        'contents': [
          {
            'parts': [
              {'text': question}
            ]
          }
        ],
      }),
    );
    return data['candidates'][0]['content']['parts'][0]['text'];
  }
}
```

Draf itu berjalan, tetapi punya empat kelemahan yang saya temukan saat
verifikasi:

1. Memakai `generateContent`, bukan `streamGenerateContent`, sehingga tidak
   ada efek streaming.
2. API key ditaruh di *query string*, sehingga ikut tercatat pada log URL.
3. Tidak ada penanganan status selain 200.
4. Tidak ada cache, sehingga pertanyaan yang sama memanggil API berulang.

## 4. Tabel Keputusan

| Usulan AI | Keputusan | Alasan Teknis |
|---|---|---|
| `generateContent` | **Tolak + ganti** | Diganti `streamGenerateContent?alt=sse` agar jawaban muncul bertahap |
| Key di *query string* | **Tolak** | Dipindah ke header `x-goog-api-key` agar tidak muncul di log |
| Model `gemini-pro` | **Tolak** | Model lama sudah ditutup; dipakai `gemini-3.8-flash` |
| Tanpa penanganan status | **Tolak + lengkapi** | Ditambah pemetaan 401/403, 404, 429, 503, dan *retry* 3x untuk 503 |
| Tanpa cache | **Tolak + lengkapi** | Ditambah `AiCache` berbasis SharedPreferences dengan TTL 1 hari |
| Service langsung dari UI | **Tolak + refactor** | Dibuat `AiRepository` (Domain) + `AiRepositoryImpl` (Data) + `AskAi` (Use Case) |
| Mode demo | **Terima + perluas** | Mode demo dipakai saat key kosong, dengan jawaban lokal yang jujur ditandai |

## 5. Risiko dan Mitigasi

| Risiko | Dampak | Mitigasi yang diterapkan |
|---|---|---|
| Bocor data pengguna | NIK, nomor HP, email terkirim ke pihak ketiga | `RedactSensitive` menyamarkan tiga pola tersebut sebelum request |
| Biaya melonjak | Kuota free tier habis | Cache 1 hari + batas 10 permintaan per sesi |
| API error atau down | Aplikasi terasa rusak | Dialog pesan ramah, *retry* otomatis 3x untuk 503, dan mode demo |
| Respons tidak relevan | Pengguna bingung | Prompt sistem membatasi jawaban maksimal 2 kalimat |
| Key bocor di repository | Kuota dicuri | Key hanya di `flutter_secure_storage`, `.env` masuk `.gitignore` |

## 6. Bukti Verifikasi

```text
PS> flutter analyze
No issues found!

PS> dart format --set-exit-if-changed lib test
Formatted 60 files (0 changed)

PS> flutter test
00:01 +49: All tests passed!
```

Test yang mencakup fitur AI:

- `test/redact_sensitive_test.dart` - 5 test penyamaran NIK, nomor HP, email.
- `test/ask_ai_test.dart` - 6 test validasi prompt, penyamaran, kegagalan, penanda cache, dan batas sesi.
- `test/ai_cache_test.dart` - 6 test simpan, baca, kedaluwarsa, dan pembersihan cache.
- `test/ai_support_test.dart` - 5 test jawaban mode demo dan penyamaran key.

## 7. Catatan Keamanan

- API key **tidak pernah** ditulis pada kode, README, screenshot, maupun commit.
- Screenshot pengaturan menampilkan key dalam bentuk tersamar (`AQ.A...ueng`).
- Pengujian dengan key asli dilakukan pada perangkat, bukan pada kode sumber.
- Key pada aplikasi mobile tetap bisa diekstrak bila perangkat di-*root*. Mitigasi
  industri yang benar adalah proxy backend; ini dicatat sebagai batasan desain.
