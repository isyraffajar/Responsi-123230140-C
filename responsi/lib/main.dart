import 'package:flutter/material.dart';
import 'app_theme.dart';
import 'view/login_screen.dart';
import 'view/main_nav.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'helpers/hive_helper.dart'; 

void main() async {
  await HiveHelper.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Game Store',
      debugShowCheckedModeBanner: false,
      
      // PASANG TEMA GLOBAL DI SINI
      theme: AppTheme.lightTheme, 
      
      home: const LoginScreen(),
    );
  }
}