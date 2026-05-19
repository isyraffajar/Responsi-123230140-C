import 'package:flutter/material.dart';
import 'app_theme.dart';
import 'view/login_screen.dart';
import 'view/main_nav.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'models/cart_item.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(CartItemAdapter());
  await Hive.openBox<CartItem>('cartBox');

  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
  runApp(MyApp(isLoggedIn: isLoggedIn));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  const MyApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Game Store',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme, 
      home: isLoggedIn ? const MainNav() : const LoginScreen(),
    );
  }
}