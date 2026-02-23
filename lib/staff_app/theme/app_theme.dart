import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // 🌈 BRAND COLORS
  static const Color primary = Color(0xFF6C63FF);
  static const Color accent = Color(0xFF00C896);
  static const Color danger = Color(0xFFFF6B6B);

  // ☀️ LIGHT COLORS
  static const Color lightBackground = Color(0xFFF5F6FA);
  static const Color lightCard = Colors.white;

  // 🌙 DARK COLORS (MATCH YOUR SCREENSHOT)
  static const Color darkBackground = Color(0xFF0F0F12);
  static const Color darkCard = Colors.black;

  // ================= LIGHT THEME =================
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    useMaterial3: true,
    primaryColor: primary,
    scaffoldBackgroundColor: lightBackground,
    cardColor: lightCard,
    dividerColor: Colors.grey.withValues(alpha: 0.1),
    colorScheme: ColorScheme.fromSeed(
      seedColor: primary,
      brightness: Brightness.light,
      primary: primary,
      secondary: accent,
      error: danger,
    ),
    textTheme: GoogleFonts.poppinsTextTheme(ThemeData.light().textTheme)
        .copyWith(
          bodyLarge: const TextStyle(color: Colors.black),
          bodyMedium: const TextStyle(color: Colors.black),
          titleLarge: const TextStyle(color: Colors.black),
        ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      elevation: 0,
    ),
  );

  // ================= DARK THEME =================
  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    useMaterial3: true,
    primaryColor: primary,
    scaffoldBackgroundColor: darkBackground,
    cardColor: darkCard,
    dividerColor: Colors.white.withValues(alpha: 0.2),
    colorScheme: ColorScheme.fromSeed(
      seedColor: primary,
      brightness: Brightness.dark,
      primary: primary,
      secondary: accent,
      error: danger,
      surface: darkCard,
      surfaceContainer: darkCard,
      outlineVariant: Colors.white.withValues(alpha: 0.2),
    ),
    textTheme: GoogleFonts.poppinsTextTheme(ThemeData.dark().textTheme)
        .copyWith(
          bodyLarge: const TextStyle(color: Colors.white),
          bodyMedium: const TextStyle(color: Colors.white),
          titleLarge: const TextStyle(color: Colors.white),
        ),
    appBarTheme: const AppBarTheme(
      backgroundColor: darkBackground,
      foregroundColor: Colors.white,
      elevation: 0,
    ),
  );
}
