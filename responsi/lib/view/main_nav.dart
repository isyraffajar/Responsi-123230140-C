import 'package:flutter/material.dart';
import 'dart:io';
import 'profile_screen.dart';
import 'home_screen.dart';

class MainNav extends StatefulWidget {
  const MainNav({super.key});

  @override
  State<MainNav> createState() => _MainNavState();
}

class _MainNavState extends State<MainNav> {
  int _selectedIndex = 0;

  Future<bool> _showExitDialog() async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: const Text('Keluar dari aplikasi?'),
            content: const Text(
              'Aplikasi akan ditutup, tetapi akun Anda tetap dalam keadaan masuk.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text(
                  'Batal',
                ), // Warna otomatis mengikuti primary color tema global
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text(
                  'Keluar',
                ), // Gaya tombol & warna otomatis mengikuti elevatedButtonTheme
              ),
            ],
          ),
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;

        final shouldExit = await _showExitDialog();

        if (shouldExit) {
          exit(0);
        }
      },
      child: Scaffold(
        body: IndexedStack(
          index: _selectedIndex,
          children: const [
            HomeScreen(), 
            ProfileScreen(), 
          ],
        ),
        // BottomNavigationBar otomatis menggunakan gaya dari bottomNavigationBarTheme di app_theme.dart
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (index) => setState(() => _selectedIndex = index),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: 'Profil',
            ),
          ],
        ),
      ),
    );
  }
}
