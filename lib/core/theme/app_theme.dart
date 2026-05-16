import 'package:flutter/material.dart';

class AppTheme {
  static const Color f1Red = Color(0xFFE10600);
  static const Color f1Dark = Color(0xFF0F0F0F);
  static const Color f1DarkCard = Color(0xFF1A1A1A);
  static const Color f1Grey = Color(0xFF2C2C2C);
  static const Color f1White = Color(0xFFF5F5F5);
  static const Color f1Gold = Color(0xFFFFD700);

  static ThemeData get darkTheme => ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: const ColorScheme.dark(
          primary: f1Red,
          secondary: f1Gold,
          surface: f1DarkCard,
          onPrimary: Colors.white,
          onSurface: f1White,
        ),
        scaffoldBackgroundColor: f1Dark,
        appBarTheme: const AppBarTheme(
          backgroundColor: f1Dark,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            color: f1White,
            fontSize: 20,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
          iconTheme: IconThemeData(color: f1White),
        ),
        cardTheme: CardThemeData(
          color: f1DarkCard,
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: f1DarkCard,
          selectedItemColor: f1Red,
          unselectedItemColor: Colors.grey,
          type: BottomNavigationBarType.fixed,
        ),
        textTheme: const TextTheme(
          headlineLarge: TextStyle(color: f1White, fontWeight: FontWeight.bold),
          headlineMedium: TextStyle(color: f1White, fontWeight: FontWeight.bold),
          bodyLarge: TextStyle(color: f1White),
          bodyMedium: TextStyle(color: Colors.grey),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: f1Grey,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: f1Red, width: 2),
          ),
          labelStyle: const TextStyle(color: Colors.grey),
          hintStyle: const TextStyle(color: Colors.grey),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: f1Red,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
        ),
        dividerColor: f1Grey,
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: f1Red,
          foregroundColor: Colors.white,
        ),
      );
}