import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color background = Color(0xFF0F0C29);
  static const Color surface = Color(0xFF24243E);
  static const Color accent = Color(0xFF9127FF);
  static const Color accentSecondary = Color(0xFF00D2FF);
  static const Color textBody = Colors.white70;
  static const Color textHeader = Colors.white;

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: background,
    colorScheme: const ColorScheme.dark(
      primary: accent,
      secondary: accentSecondary,
      surface: surface,
      background: background,
    ),
    textTheme: TextTheme(
      displayLarge: GoogleFonts.cinzel(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: textHeader,
      ),
      displayMedium: GoogleFonts.cinzel(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: textHeader,
      ),
      bodyLarge: GoogleFonts.inter(fontSize: 18, color: textBody),
      bodyMedium: GoogleFonts.inter(fontSize: 16, color: textBody),
    ),
  );
}
