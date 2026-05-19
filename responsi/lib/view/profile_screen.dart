import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _namaUser = 'Pengguna';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  // Mengambil nama user yang aktif dari SharedPreferences
  Future<void> _loadUserData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? savedUser = prefs.getString('currentUser');
    if (savedUser != null && savedUser.isNotEmpty) {
      setState(() {
        _namaUser = savedUser;
      });
    }
  }

  // Fungsi untuk memproses Logout
  Future<void> _handleLogout() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('isLoggedIn');
    await prefs.remove('currentUser');

    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (route) => false,
    );
  }

  // Dialog konfirmasi
  void _showLogoutConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Logout Akun'),
        content: const Text('Apakah Anda yakin ingin keluar dari akun ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red[700],
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
              _handleLogout();
            },
            child: const Text('Keluar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final teks = Theme.of(context).textTheme;
    final skemaWarna = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Profil',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        backgroundColor: skemaWarna.primary,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 32),

            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.grey[200],
                    child: Icon(
                      Icons.person,
                      size: 60,
                      color: Colors.grey[400],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _namaUser,
                    style: teks.titleLarge?.copyWith(
                      color: const Color(0xFF0C4A6E),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '@${_namaUser.toLowerCase().replaceAll(' ', '')}',
                    style: teks.bodyMedium?.copyWith(color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle('Tentang Praktikum TPM'),
                  const SizedBox(height: 8),
                  _buildMenuCard(
                    children: [
                      _buildMenuItem(
                        icon: Icons.face_outlined,
                        iconBgColor: const Color(0xFFE6F4FF),
                        iconColor: const Color(0xFF1E6FB8),
                        title: 'Kesan dan Pesan',
                        subtitle: 'Matkul susah dan menantang, bisa dikerjakan tapi butuh waktu. Untung aslab nya baik-baik',
                        onTap: () {},
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  
                  _buildMenuCard(
                    children: [
                      _buildMenuItem(
                        icon: Icons.feedback_outlined,
                        iconBgColor: const Color(0xFFE6F4FF),
                        iconColor: const Color(0xFF1E6FB8),
                        title: 'Kritik dan Saran',
                        subtitle: 'Sudah bagus, hanya perlu ditingkatkan kualitas modul nya karena kadang saya masih agak bingung',
                        onTap: () {},
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  _buildSectionTitle('LAINNYA'),
                  const SizedBox(height: 8),
                  _buildMenuCard(
                    children: [
                      _buildMenuItem(
                        icon: Icons.logout_outlined,
                        iconBgColor: const Color(0xFFFFEBEB),
                        iconColor: Colors.red[700]!,
                        title: 'Logout',
                        subtitle: 'Logout Akun',
                        titleColor: Colors.red[700],
                        showTrailing: false,
                        onTap: _showLogoutConfirmation,
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.bold,
        color: Colors.grey,
        letterSpacing: 1.2,
      ),
    );
  }

  Widget _buildMenuCard({required List<Widget> children}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required Color iconBgColor,
    required Color iconColor,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    Color? titleColor,
    bool showTrailing = false,
  }) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: iconBgColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: iconColor, size: 22),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 15,
          color: titleColor ?? const Color(0xFF0C4A6E),
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(fontSize: 12, color: Colors.grey[500]),
      ),
      trailing: showTrailing
          ? const Icon(Icons.chevron_right, color: Colors.grey, size: 20)
          : null,
    );
  }
}
