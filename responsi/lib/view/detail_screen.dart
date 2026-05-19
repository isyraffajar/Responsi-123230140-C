import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/data_model.dart'; 

class DetailScreen extends StatefulWidget {
  final dynamic product;

  const DetailScreen({super.key, required this.product});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  int _quantity = 1;
  int _maxStock = 0;

  @override
  void initState() {
    super.initState();
    _maxStock = widget.product['stock'] ?? 10;
  }

  void _incrementQty() {
    if (_quantity < _maxStock) {
      setState(() {
        _quantity++;
      });
    } else {
      _showSnackBar('Stok produk tidak mencukupi');
    }
  }

  void _decrementQty() {
    if (_quantity > 1) {
      setState(() {
        _quantity--;
      });
    }
  }

  // void _addToCart() async {
  //   try {
  //     final SharedPreferences prefs = await SharedPreferences.getInstance();
  //     final String currentUser = prefs.getString('currentUser') ?? 'Unknown';
  //     var cartBox = Hive.box<CartItem>('cartBox');
  //     final newCartItem = CartItem(
  //       username: currentUser,
  //       productId: widget.product['id'],
  //       title: widget.product['title'],
  //       price: (widget.product['price'] as num).toDouble(),
  //       thumbnail: widget.product['thumbnail'],
  //       quantity: _quantity,
  //     );
  //     String uniqueKey = '${currentUser}_${widget.product['id']}';
  //     await cartBox.put(uniqueKey, newCartItem);

  //     _showSnackBar('Produk berhasil dimasukkan ke keranjang!');
  //     if (!mounted) return;
  //     Navigator.pop(context); 
  //   } catch (e) {
  //     _showSnackBar('Gagal menambahkan ke keranjang: $e');
  //   }
  // }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Produk'),
        backgroundColor: const Color(0xFF1D9E75),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gambar Produk Utama
            Container(
              height: 300,
              width: double.infinity,
              color: Colors.grey[200],
              child: Image.network(
                product[''],
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Nama & Harga Produk
                  Text(
                    product['title'] ?? '',
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '\$${product['price']}',
                    style: const TextStyle(
                      fontSize: 22,
                      color: Color(0xFF1D9E75),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Stok Tersedia: $_maxStock',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  const Divider(height: 32),

                  // Deskripsi Produk
                  const Text(
                    'Deskripsi Produk',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    product['description'] ?? 'Tidak ada deskripsi.',
                    style: const TextStyle(fontSize: 16, color: Colors.black87, height: 1.4),
                  ),
                  const Divider(height: 32),

                  // Fitur Atur Quantity (Poin f: 0 < qty <= totalQty)
                  const Text(
                    'Jumlah Pembelian',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove),
                              onPressed: _decrementQty,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16.0),
                              child: Text(
                                '$_quantity',
                                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.add),
                              onPressed: _incrementQty,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),

                  // Tombol Add To Cart
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1D9E75),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {},
                      icon: const Icon(Icons.add_shopping_cart),
                      label: const Text(
                        'Add to Cart',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}