import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, TargetPlatform;

/// Konfigurasi publik Firebase untuk aplikasi Android Week 14.
///
/// Nilai di berkas ini adalah pengenal klien, bukan rahasia server.
/// Project yang dipakai sama dengan Minggu 6 (`campus-notify-20030`) karena
/// pendaftaran aplikasi Firebase baru memerlukan akses Firebase Console.
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      default:
        throw UnsupportedError(
          'Firebase hanya dikonfigurasi untuk Android pada praktikum ini.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAlXAAcLkDAwsd31akiWZ8JXnNnoMz5EqM',
    appId: '1:174960433216:android:a61a15e007477bb37a67a5',
    messagingSenderId: '174960433216',
    projectId: 'campus-notify-20030',
    storageBucket: 'campus-notify-20030.firebasestorage.app',
  );
}
