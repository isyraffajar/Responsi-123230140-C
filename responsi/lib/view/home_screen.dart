import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'detail_screen.dart';
import 'cart_screen.dart';

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
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Selamat Pagi,',
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              '$_username 👋',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.lightBlueAccent,
              ),
            ),
          ],
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: IconButton(
              icon: const Icon(
                Icons.shopping_cart_outlined,
                color: Colors.white,
                size: 26,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CartScreen()),
                );
              },
            ),
          ),
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: theme.colorScheme.secondary,
              ),
            )
          : _products.isEmpty
          ? const Center(child: Text('Tidak ada produk yang tersedia'))
          : GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1,
                childAspectRatio: 1.15,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: _products.length,
              itemBuilder: (context, index) {
                final product = _products[index];

                final String name = product['name'] ?? 'No Title';
                final String id = product['id']?.toString() ?? 'N/A';
                final String released = product['released'] ?? 'N/A';
                final double? ratingRaw = product['rating']?.toDouble();
                final String rating = ratingRaw != null
                    ? ratingRaw.toStringAsFixed(1)
                    : 'N/A';

                final String imageUrl =
                    product['background_image'] ?? product['thumbnail'] ?? '';

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailScreen(product: product),
                      ),
                    );
                  },
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 4,
                    shadowColor: Colors.black12,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Gambar
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(16),
                          ),
                          child: imageUrl.isNotEmpty
                              ? SizedBox(
                                  height: 140,
                                  width: double.infinity,
                                  child: Image.network(
                                    imageUrl,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        height: 140,
                                        color: Colors.grey[200],
                                        child: const Icon(
                                          Icons.broken_image_outlined,
                                          color: Colors.grey,
                                          size: 40,
                                        ),
                                      );
                                    },
                                  ),
                                )
                              : Container(
                                  height: 140,
                                  color: Colors.grey[200],
                                  width: double.infinity,
                                  child: const Icon(
                                    Icons.image_not_supported_outlined,
                                    color: Colors.grey,
                                    size: 40,
                                  ),
                                ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // Nama Game
                                Text(
                                  name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: theme.colorScheme.primary,
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 2,
                                      ),
                                      decoration: BoxDecoration(
                                        color: theme.colorScheme.secondary
                                            .withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(4),
                                      ),

                                      // ID
                                      child: Text(
                                        'ID: $id',
                                        style: TextStyle(
                                          color: theme.colorScheme.secondary,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 11,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                // Released Date
                                Row(
                                  children: [
                                    Icon(
                                      Icons.calendar_month_outlined,
                                      size: 14,
                                      color: Colors.grey[600],
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      released,
                                      style: TextStyle(
                                        color: Colors.grey[700],
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                                const Divider(height: 8),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.star_rounded,
                                      color: Colors.amber,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      rating,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                    Text(
                                      ' / 5.0',
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
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
