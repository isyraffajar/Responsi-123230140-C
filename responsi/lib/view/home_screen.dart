import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _username = '';
  List<dynamic> _products = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUsername();
    _fetchProducts();
  }

  void _loadUsername() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _username = prefs.getString('currentUser') ?? 'User';
    });
  }

  Future<void> _fetchProducts() async {
    try {
      final response = await http.get(
        Uri.parse('https://jsonfakery.com/games/paginated'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        setState(() {
          _products = data['data'] ?? [];
          _isLoading = false;
        });
      } else {
        throw Exception(
          'Gagal memuat data produk (Status: ${response.statusCode})',
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      // Menggunakan mounted check untuk menghindari error konteks jika widget sudah tidak aktif
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Selamat Pagi,',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              '$_username 👋',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Color(0xFF0C4A6E),
              ),
            ),
          ],
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: IconButton(
              icon: const Icon(
                Icons.shopping_cart,
                color: Color(0xFF0F4C81),
                size: 26,
              ),
              onPressed: () {
                // Berpindah ke Halaman CartScreen
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (context) => const CartScreen()),
                // );
              },
            ),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFF1D9E75)),
            )
          : _products.isEmpty
          ? const Center(child: Text('Tidak ada produk yang tersedia'))
          : GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1,
                childAspectRatio: 0.7,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: _products.length,
              itemBuilder: (context, index) {
                final product = _products[index];

                final String name = product['name'] ?? 'No Title';
                final String id = product['id'] ?? 'No ID';
                final String released = product['released'] ?? 'N/A';
                final String rating = product['rating'] != null
                    ? product['rating'].toString()
                    : 'N/A';
                final String imageUrl =
                    product['background_image'] ?? product['thumbnail'] ?? '';

                return GestureDetector(
                  onTap: () {
                    // 2. AKTIFKAN NAVIGASI KE DETAIL SCREEN SAMBIL MEMBAWA DATA ARTIKEL
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            DetailScreen(product: product),
                      ),
                    );
                  },
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(12),
                            ),
                            child: imageUrl.isNotEmpty
                                ? Image.network(
                                    imageUrl,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return const Center(
                                        child: Icon(
                                          Icons.broken_image,
                                          color: Colors.grey,
                                        ),
                                      );
                                    },
                                  )
                                : const Center(
                                    child: Icon(
                                      Icons.image_not_supported,
                                      color: Colors.grey,
                                    ),
                                  ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                name,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'ID: $id',
                                style: const TextStyle(
                                  color: Color(0xFF1D9E75),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Released: $released',
                                style: const TextStyle(
                                  color: Color(0xFF1D9E75),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Rating: $rating',
                                style: const TextStyle(
                                  color: Color(0xFF1D9E75),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
