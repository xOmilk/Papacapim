import 'package:flutter/material.dart';

class AppTheme {
  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.dark(
      primary: Color(0xFF22C55E),
      onPrimary: Color(0xFF111111),
      primaryContainer: Color(0xFF1A5C2A),
      onPrimaryContainer: Color(0xFF4BE277),
      secondary: Color(0xFF1A5C2A),
      onSecondary: Color(0xFF4BE277),
      tertiary: Color(0xFFFF8B7C),
      onTertiary: Color(0xFF111111),
      error: Color(0xFFEF4444),
      onError: Color(0xFF111111),
      surface: Color(0xFF131313),
      onSurface: Color(0xFFF0F0F0),
      surfaceContainerHighest: Color(0xFF201F1F),
      outline: Color(0xFF6B6B69),
      outlineVariant: Color(0xFF6B6B69),
    ),
    scaffoldBackgroundColor: Color(0xFF111111),
    fontFamily: "Roboto",
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        padding: EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        padding: EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
      ),
    ),
  );
}
