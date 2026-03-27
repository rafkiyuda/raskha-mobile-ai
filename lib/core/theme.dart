import 'package:flutter/material.dart';
import 'colors.dart';

class RakshaTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: RakshaColors.primary,
      scaffoldBackgroundColor: RakshaColors.bgSlate,
      colorScheme: ColorScheme.fromSeed(
        seedColor: RakshaColors.primary,
        primary: RakshaColors.primary,
        surface: RakshaColors.cardWhite,
      ),
      useMaterial3: true,
      fontFamily: 'InstrumentSans', // Placeholder for now, can use Google Fonts later
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          color: RakshaColors.textDark,
          fontWeight: FontWeight.bold,
          fontSize: 32,
        ),
        headlineMedium: TextStyle(
          color: RakshaColors.textDark,
          fontWeight: FontWeight.w600,
          fontSize: 24,
        ),
        bodyLarge: TextStyle(
          color: RakshaColors.textDark,
          fontSize: 16,
        ),
        bodyMedium: TextStyle(
          color: RakshaColors.textGray,
          fontSize: 14,
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        selectedItemColor: RakshaColors.primary,
        unselectedItemColor: RakshaColors.textLight,
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        elevation: 10,
      ),
    );
  }
}
