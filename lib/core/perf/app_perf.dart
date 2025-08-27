import 'package:flutter/widgets.dart';

/// Lightweight performance bootstrapper.
/// Keeps API surface tiny: just call `await AppPerf.init();` in main().
class AppPerf {
  static Future<void> init() async {
    // Ensure binding is ready before any other initialization.
    WidgetsFlutterBinding.ensureInitialized();
    // You can add more perf toggles here (e.g. HTTP overrides, image cache sizing, etc.).
    // For example: PaintingBinding.instance.imageCache.maximumSizeBytes = 256 << 20; // 256MB
  }
}