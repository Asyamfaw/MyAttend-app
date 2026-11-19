import 'package:attendance_app/firebase_options.dart';
import 'package:attendance_app/screens/config_error/config_error_screen.dart';
import 'package:attendance_app/wrapper/auth_wrapper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';

/// Warna utama aplikasi; ubah konstanta ini pada latihan penyesuaian tema.
const Color kSeedColor = Color(0xFF001735);

ThemeData _buildAppTheme() {
  final colorScheme = ColorScheme.fromSeed(
    seedColor: kSeedColor,
    primary: kSeedColor,
    onPrimary: Colors.white,
    secondary: const Color(0xFF006B58),
    onSecondary: Colors.white,
    secondaryContainer: const Color(0xFF98F4DA),
    onSecondaryContainer: const Color(0xFF005142),
    surface: const Color(0xFFF9F9FF),
    onSurface: const Color(0xFF041B3C),
    onSurfaceVariant: const Color(0xFF44474E),
    surfaceContainerLowest: Colors.white,
    surfaceContainerLow: const Color(0xFFF1F3FF),
    surfaceContainer: const Color(0xFFE8EDFF),
    surfaceContainerHigh: const Color(0xFFE0E8FF),
    surfaceContainerHighest: const Color(0xFFD7E2FF),
    outline: const Color(0xFF74777F),
    outlineVariant: const Color(0xFFC4C6CF),
    error: const Color(0xFFBA1A1A),
  );

  return ThemeData(
    useMaterial3: true,
    colorScheme: colorScheme,
    scaffoldBackgroundColor: const Color(0xFFF9F9FF),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFFF9F9FF),
      foregroundColor: Color(0xFF041B3C),
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
    ),
    cardTheme: CardThemeData(
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(color: Color(0xFFE8EDFF)),
      ),
    ),
  );
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id_ID');

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    runApp(const AttendanceApp());
  } catch (e) {
    runApp(_ConfigErrorApp(error: e));
  }
}

/// Aplikasi utama Presensi Digital.
class AttendanceApp extends StatelessWidget {
  const AttendanceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MyAttend',
      debugShowCheckedModeBanner: false,
      theme: _buildAppTheme(),
      home: const AuthWrapper(),
    );
  }
}

class _ConfigErrorApp extends StatelessWidget {
  const _ConfigErrorApp({required this.error});

  final Object error;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MyAttend',
      debugShowCheckedModeBanner: false,
      theme: _buildAppTheme(),
      home: ConfigErrorScreen(error: error),
    );
  }
}
