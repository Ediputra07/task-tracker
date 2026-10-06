import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color primaryColor = Color(0xFF6366F1); // Indigo
  static const Color accentColor = Color(0xFF3B82F6);  // Blue

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorSchemeSeed: primaryColor,
    textTheme: GoogleFonts.interTextTheme(ThemeData.light().textTheme),
    scaffoldBackgroundColor: const Color(0xFFF9FAFB),
    cardTheme: CardTheme(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Color(0xFFE5E7EB)),
      ),
      color: Colors.white,
    ),
    appBarTheme: const AppBarTheme(
      centerTitle: false,
      backgroundColor: Color(0xFFF9FAFB),
      elevation: 0,
      surfaceTintColor: Colors.transparent,
    ),
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorSchemeSeed: primaryColor,
    textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme),
    scaffoldBackgroundColor: const Color(0xFF0F172A),
    cardTheme: CardTheme(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Color(0xFF1E293B)),
      ),
      color: const Color(0xFF1E293B),
    ),
    appBarTheme: const AppBarTheme(
      centerTitle: false,
      backgroundColor: Color(0xFF0F172A),
      elevation: 0,
      surfaceTintColor: Colors.transparent,
    ),
  );
}
