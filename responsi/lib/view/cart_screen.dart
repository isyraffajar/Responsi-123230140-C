import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/cart_item.dart';
import 'detail_screen.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  String _currentUsername = '';
  bool _isUserLoading = true;
  late Box<CartItem> _cartBox;

  @override
  void initState() {
    super.initState();
    _cartBox = Hive.box<CartItem>('cartBox');
    _loadActiveUser();
  }

  void _loadActiveUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _currentUsername = prefs.getString('currentUser') ?? 'User';
      _isUserLoading = false;
    });
  }

  void _removeItem(CartItem item) {
    setState(() {
      item.delete();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (_isUserLoading) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(color: theme.colorScheme.secondary),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Keranjang Belanja',
          style: TextStyle(
            color: theme.colorScheme.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: theme.colorScheme.primary),
      ),
      body: ValueListenableBuilder<Box<CartItem>>(
        valueListenable: _cartBox.listenable(),
        builder: (context, box, _) {
          final allItems = box.values.toList();
          final userCartItems = allItems
              .where((item) => item.username == _currentUsername)
              .toList();

          // 1. Tampilan ketika keranjang kosong (Dengan Ikon Transparan)
          if (userCartItems.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.shopping_cart_outlined,
                    size: 100,
                    color: theme.colorScheme.primary.withOpacity(0.2),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Keranjang Anda kosong',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            );
          }

          int totalQuantity = userCartItems.fold(
            0,
            (sum, item) => sum + item.quantity,
          );

          void updateItemQuantity(CartItem item, int newQuantity) {
            setState(() {
              item.quantity = newQuantity;
              item.save(); // Menyimpan perubahan kuantitas ke database Hive
            });
          }

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: userCartItems.length,
                  itemBuilder: (context, index) {
                    final item = userCartItems[index];

                    return GestureDetector(
                      onTap: () {
                        final Map<String, dynamic> productMap = {
                          'id': item.id,
                          'name': item.name,
                          'released': item.released,
                          'rating': item.rating,
                          'background_image': item.imageUrl,
                          'thumbnail': item.imageUrl,
                          'updated_at': 'N/A',
                          'ratings_count': 0,
                          'reviews_count': 0,
                        };

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                DetailScreen(product: productMap),
                          ),
                        );
                      },
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 2,
                        margin: const EdgeInsets.only(bottom: 12),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            children: [
                              // Gambar Produk
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: item.imageUrl.isNotEmpty
                                    ? Image.network(
                                        item.imageUrl,
                                        width: 70,
                                        height: 70,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) =>
                                                Container(
                                                  width: 70,
                                                  height: 70,
                                                  color: Colors.grey[200],
                                                  child: const Icon(
                                                    Icons.broken_image,
                                                  ),
                                                ),
                                      )
                                    : Container(
                                        width: 70,
                                        height: 70,
                                        color: Colors.grey[200],
                                        child: const Icon(Icons.image),
                                      ),
                              ),
                              const SizedBox(width: 12),

                              // Informasi Produk (Nama, ID, Rating)
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.name,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      'ID: ${item.id}',
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 11,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.star_rounded,
                                          color: Colors.amber,
                                          size: 14,
                                        ),
                                        const SizedBox(width: 2),
                                        Text(
                                          item.rating.toStringAsFixed(1),
                                          style: const TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 4),
                              Container(
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey[300]!),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.remove, size: 14),
                                      constraints: const BoxConstraints(),
                                      padding: const EdgeInsets.all(4),
                                      onPressed: () {
                                        if (item.quantity > 1) {
                                          updateItemQuantity(
                                            item,
                                            item.quantity - 1,
                                          );
                                        } else {
                                          _removeItem(item);
                                        }
                                      },
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 6,
                                      ),
                                      child: Text(
                                        '${item.quantity}',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.add, size: 14),
                                      constraints: const BoxConstraints(),
                                      padding: const EdgeInsets.all(4),
                                      onPressed: () => updateItemQuantity(
                                        item,
                                        item.quantity + 1,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 4),
                              IconButton(
                                icon: const Icon(
                                  Icons.delete_outline_rounded,
                                  color: Colors.redAccent,
                                  size: 20,
                                ),
                                onPressed: () => _removeItem(item),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      offset: const Offset(0, -4),
                      blurRadius: 8,
                    ),
                  ],
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(20),
                  ),
                ),
                child: SafeArea(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total Quantity:',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '$totalQuantity Item',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
