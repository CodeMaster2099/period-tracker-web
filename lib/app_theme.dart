import 'package:flutter/material.dart';

ThemeData buildTheme() {
  const baseColor = Color(0xFF6A4C93); // deep purple
  const accent = Color(0xFFFFA8D6);    // soft pink
  const bg = Color(0xFFF8F5FA);

  final textTheme = const TextTheme(
    headlineMedium: TextStyle(fontWeight: FontWeight.w700, color: Colors.black87),
    titleMedium: TextStyle(fontWeight: FontWeight.w600, color: Colors.black87),
    bodyMedium: TextStyle(color: Colors.black87),
    labelLarge: TextStyle(fontWeight: FontWeight.w600),
  );

  return ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(seedColor: baseColor, background: bg, primary: baseColor, secondary: accent),
    scaffoldBackgroundColor: bg,
    textTheme: textTheme,
    appBarTheme: const AppBarTheme(
      backgroundColor: bg,
      foregroundColor: Colors.black87,
      elevation: 0,
      centerTitle: true,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
    ),
    cardTheme: CardThemeData(
      color: Colors.white,
      elevation: 0.5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
    snackBarTheme: const SnackBarThemeData(behavior: SnackBarBehavior.floating),
  );
}
