import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'core/services/cache_service.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize cache service
  await CacheService().init();

  // Pre-cache Roboto font - downloads once and caches for offline use
  GoogleFonts.config.allowRuntimeFetching = true;

  // Pre-load Roboto font to cache it on first run
  try {
    await Future.wait([
      GoogleFonts.pendingFonts([GoogleFonts.roboto()]),
    ]);
  } catch (e) {
    // If offline or font loading fails, app will use fallback fonts
    debugPrint('Font pre-caching failed: $e');
  }

  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  runApp(const MyApp());
}
