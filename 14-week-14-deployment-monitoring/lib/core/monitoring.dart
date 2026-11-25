import 'dart:developer' as developer;

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';

import '../firebase_options.dart';

/// Penghubung telemetri rilis beta.
///
/// Bila Firebase gagal disiapkan (misalnya konfigurasi tidak cocok), aplikasi
/// tetap berjalan dan hanya mencatat kejadian ke log perangkat. Ini lebih baik
/// daripada membuat aplikasi tidak bisa dibuka hanya karena monitoring gagal.
class Monitoring {
  Monitoring._();

  static bool enabled = false;
  static String status = 'Belum diinisialisasi';

  static Future<void> init() async {
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );

      await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);

      FlutterError.onError = (details) {
        FirebaseCrashlytics.instance.recordFlutterFatalError(details);
      };

      PlatformDispatcher.instance.onError = (error, stack) {
        FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
        return true;
      };

      enabled = true;
      status = 'Firebase aktif (${Firebase.app().options.projectId})';
      developer.log('Firebase monitoring aktif', name: 'monitoring');
    } catch (error, stack) {
      enabled = false;
      status = 'Mode lokal: $error';
      developer.log(
        'Firebase tidak aktif, memakai log lokal',
        name: 'monitoring',
        error: error,
        stackTrace: stack,
      );
    }
  }

  /// Event non-sensitif: hanya nama layar, tanpa email, token, atau isi form.
  static Future<void> logBetaFeedback(String screenName) async {
    developer.log(
      'beta_feedback_sent screen_name=$screenName',
      name: 'monitoring',
    );
    if (!enabled) return;
    await FirebaseAnalytics.instance.logEvent(
      name: 'beta_feedback_sent',
      parameters: {'screen_name': screenName},
    );
  }

  /// Error buatan untuk membuktikan Crashlytics menerima laporan non-fatal.
  static Future<void> recordTestError() async {
    final error = Exception('Uji error non-fatal Week 14');
    developer.log(
      'Mengirim error non-fatal ke Crashlytics',
      name: 'monitoring',
      error: error,
      stackTrace: StackTrace.current,
    );
    if (!enabled) return;
    await FirebaseCrashlytics.instance.recordError(
      error,
      StackTrace.current,
      reason: 'beta_test_non_fatal',
      fatal: false,
    );
  }
}
