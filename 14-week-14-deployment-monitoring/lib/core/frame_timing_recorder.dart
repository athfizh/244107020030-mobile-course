import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart';

/// Mencatat waktu build dan raster setiap frame ke log.
///
/// Hanya aktif pada mode profile/debug agar tidak membebani build rilis.
/// Data dipakai untuk membandingkan performa sebelum dan sesudah optimasi.
class FrameTimingRecorder {
  FrameTimingRecorder._();

  static final List<FrameTiming> _timings = [];
  static bool _installed = false;

  static List<FrameTiming> get timings => List.unmodifiable(_timings);

  static void install() {
    if (_installed) return;
    if (!kProfileMode && !kDebugMode) return;
    _installed = true;
    SchedulerBinding.instance.addTimingsCallback(_onTimings);
  }

  static void _onTimings(List<FrameTiming> timings) {
    _timings.addAll(timings);
    for (final timing in timings) {
      debugPrint(
        'FRAME build=${timing.buildDuration.inMicroseconds} '
        'raster=${timing.rasterDuration.inMicroseconds} '
        'total=${timing.totalSpan.inMicroseconds}',
      );
    }
  }

  static void reset() => _timings.clear();

  /// Ringkasan sederhana untuk ditampilkan atau dicatat.
  static ({int frames, double avgBuildMs, double avgRasterMs, int janky})
  summarize({double budgetMs = 16.67}) {
    if (_timings.isEmpty) {
      return (frames: 0, avgBuildMs: 0, avgRasterMs: 0, janky: 0);
    }

    var buildTotal = 0;
    var rasterTotal = 0;
    var janky = 0;

    for (final timing in _timings) {
      buildTotal += timing.buildDuration.inMicroseconds;
      rasterTotal += timing.rasterDuration.inMicroseconds;
      final totalMs = timing.totalSpan.inMicroseconds / 1000.0;
      if (totalMs > budgetMs) janky++;
    }

    final count = _timings.length;
    return (
      frames: count,
      avgBuildMs: buildTotal / count / 1000.0,
      avgRasterMs: rasterTotal / count / 1000.0,
      janky: janky,
    );
  }
}
