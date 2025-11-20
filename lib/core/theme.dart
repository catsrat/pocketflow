import 'package:flutter/material.dart';

class AppTheme {
  // Primary gradient (used for hero cards / appbar)
  static const Gradient primaryGradient = LinearGradient(
    colors: [Color(0xFF00BFA6), Color(0xFF3DD5FF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Accent gradient (secondary)
  static const Gradient accentGradient = LinearGradient(
    colors: [Color(0xFF7B61FF), Color(0xFF2DD4BF)],
    begin: Alignment.topRight,
    end: Alignment.bottomLeft,
  );

  // Soft shadow used for cards
  static final BoxShadow softShadow = BoxShadow(
    color: Colors.black.withOpacity(0.08),
    blurRadius: 18,
    offset: const Offset(0, 8),
  );

  // Colors
  static const Color bg = Color(0xFFF7FAFC);
  static const Color surface = Colors.white;
  static const Color muted = Color(0xFF9AA4B2);
  static const Color primary = Color(0xFF00BFA6);

  static final ThemeData lightTheme = ThemeData(
    scaffoldBackgroundColor: bg,
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(seedColor: primary, primary: primary),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Colors.black87),
      iconTheme: IconThemeData(color: Colors.black87),
    ),
    textTheme: const TextTheme(
      titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Colors.black87),
      titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black87),
      bodyLarge: TextStyle(fontSize: 16, color: Colors.black87),
      bodyMedium: TextStyle(fontSize: 14, color: Colors.black87),
      labelLarge: TextStyle(fontSize: 13, color: Colors.black54),
    ),
    cardTheme: CardTheme(
      color: surface,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: EdgeInsets.zero,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      elevation: 8,
      extendedTextStyle: TextStyle(fontWeight: FontWeight.w700),
    ),
  );
}
