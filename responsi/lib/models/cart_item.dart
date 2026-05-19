import 'package:hive/hive.dart';
part 'cart_item.g.dart';

@HiveType(typeId: 0)
class CartItem extends HiveObject {
  @HiveField(0)
  final String username;

  @HiveField(1)
  final String id;

  @HiveField(2)
  final String name;

  @HiveField(3)
  final String released;

  @HiveField(4)
  final String imageUrl;

  @HiveField(5)
  final double rating;

  @HiveField(6)
  int quantity;

  CartItem({
    required this.username,
    required this.id,
    required this.name,
    required this.released,
    required this.imageUrl,
    required this.rating,
    required this.quantity,
  });
}