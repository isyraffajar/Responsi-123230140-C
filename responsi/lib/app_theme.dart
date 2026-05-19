import 'package:flutter/material.dart';

class AppTheme {
  // Definisi kode warna dari gambar contoh
  static const Color deepBlue = Color(0xFF0F4C81);
  static const Color mediumBlue = Color(0xFF1E6FB8);
  static const Color lightBlue = Color(0xFF4FB3F6);
  static const Color extraLightBlue = Color(0xFFE6F4FF);
  static const Color darkNavy = Color(0xFF0C4A6E);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      
      // Mengatur skema warna utama aplikasi
      colorScheme: const ColorScheme.light(
        primary: deepBlue,
        secondary: mediumBlue,
        surface: Colors.white,
        background: extraLightBlue, // Mengubah default background Scaffold
      ),

      // Mengatur tema untuk Scaffold secara global
      scaffoldBackgroundColor: extraLightBlue,

      // Mengatur tema untuk semua ElevatedButton
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: deepBlue,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
        ),
      ),

      // Mengatur tema untuk semua BottomNavigationBar
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: darkNavy,
        selectedItemColor: Colors.white,
        unselectedItemColor: Color(0x994FB3F6), // lightBlue dengan opacity
        type: BottomNavigationBarType.fixed,
      ),

      // Mengatur tema default untuk Input/TextField
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        labelStyle: const TextStyle(color: deepBlue),
        prefixIconColor: deepBlue,
        suffixIconColor: deepBlue,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.transparent),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: mediumBlue, width: 2),
        ),
      ),
    );
  }
}