import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'main_nav.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  bool _obscurePassword = true;

  final String nim = '140';

  void _handleLogin() async {
    final String username = _usernameCtrl.text.trim();
    final String password = _passwordCtrl.text.trim();

    if (username.isEmpty || password.isEmpty) {
      _showError('Username dan password tidak boleh kosong');
      return;
    }

    if(username.length < 5) {
      _showError('Username minimal harus 5 karakter');
      return;
    }

    if (password == nim) {
      
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);
      await prefs.setString('currentUser', username);

      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MainNav()),
      );
    } else {
      _showError('Password salah! Password wajib menggunakan 3 digit NIM Anda.');
    }

  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: const Color(
          0xFF0C4A6E,
        ), 
        content: Text(message, style: const TextStyle(color: Colors.white)),
      ),
    );
  }

  @override
  void dispose() {
    _usernameCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final teks = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Container(
                    width: 80,
                    height: 80,
                    // decoration: BoxDecoration(
                    //   color: Theme.of(context).colorScheme.primary,
                    //   borderRadius: BorderRadius.circular(20),
                    // ),
                    child: const Icon(
                      Icons.gamepad,
                      color: Color.fromARGB(255, 28, 79, 123),
                      size: 100,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'My Game Store',
                  style: teks.headlineMedium?.copyWith(
                    color: const Color(
                      0xFF0C4A6E,
                    ), 
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
                Text('Pusat game terlengkap!', textAlign: TextAlign.center),
                const SizedBox(height: 40),

                TextField(
                  controller: _usernameCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Username',
                    prefixIcon: Icon(Icons.person_outline),
                  ),
                ),
                const SizedBox(height: 16),

                TextField(
                  controller: _passwordCtrl,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    labelText: 'Password (NIM)',
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                      ),
                      onPressed: () =>
                          setState(() => _obscurePassword = !_obscurePassword),
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                ElevatedButton(
                  onPressed: _handleLogin,
                  child: const Text('Masuk'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
