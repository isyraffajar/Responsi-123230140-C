// import 'package:flutter/material.dart';
// import 'package:responsi/models/data_model.dart';
// import 'package:responsi/helpers/hive_helper.dart';
// import 'detail_screen.dart';

// class CartScreen extends StatefulWidget {
//   const CartScreen({super.key});

//   @override
//   State<CartScreen> createState() => _CartScreenState();
// }

// class _CartScreenState extends State<CartScreen> {
//   List<DataModel> _savedItems = [];

//   @override
//   void initState() {
//     super.initState();
//     _loadBookmarkData();
//   }

//   // Mengambil data terbaru dari Hive
//   void _loadBookmarkData() {
//     setState(() {
//       _savedItems = HiveHelper.getAllItems();
//     });
//   }

//   // Fungsi menghapus item langsung dari daftar bookmark (Swipe to Delete / Tombol Trash)
//   void _deleteBookmarkItem(String id) async {
//     await HiveHelper.deleteItem(id);
//     _loadBookmarkData(); // Segarkan isi list setelah dihapus
//     if (!mounted) return;
//     ScaffoldMessenger.of(
//       context,
//     ).showSnackBar(const SnackBar(content: Text('Item berhasil dihapus')));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           'Simpanan Saya',
//           style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
//         ),
//         centerTitle: true,
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         foregroundColor: const Color(0xFF0C4A6E),
//       ),
//       body: _savedItems.isEmpty
//           ? Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Icon(
//                     Icons.bookmark_outline_rounded,
//                     size: 72,
//                     color: Colors.grey[300],
//                   ),
//                   const SizedBox(height: 16),
//                   Text(
//                     'Belum ada item yang disimpan',
//                     style: TextStyle(
//                       color: Colors.grey[500],
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                 ],
//               ),
//             )
//           : ListView.builder(
//               padding: const EdgeInsets.all(16),
//               itemCount: _savedItems.length,
//               itemBuilder: (context, index) {
//                 final item = _savedItems[index];
//                 return Container(
//                   margin: const EdgeInsets.only(bottom: 12),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(12),
//                     boxShadow: [
//                       BoxShadow(
//                         color: const Color(0xFF0F4C81).withOpacity(0.04),
//                         blurRadius: 8,
//                         offset: const Offset(0, 2),
//                       ),
//                     ],
//                   ),
//                   child: ListTile(
//                     contentPadding: const EdgeInsets.all(8),

//                     // --- TAMBAHKAN AKSI KLIK DI SINI ---
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => DetailScreen(
//                             // Membungkus kembali DataModel ke bentuk Map agar kompatibel dengan DetailScreen
//                             products: {
//                               'id': item.id,
//                               'title': item.title,
//                               'description': item.subtitle,
//                               'cover_image': item.imageUrl,
//                             },
//                           ),
//                         ),
//                       );
//                     },

//                     // -----------------------------------
//                     leading: ClipRRect(
//                       borderRadius: BorderRadius.circular(8),
//                       child: Image.network(
//                         item.imageUrl,
//                         width: 70,
//                         height: 70,
//                         fit: BoxFit.cover,
//                         errorBuilder: (context, error, stackTrace) =>
//                             const SizedBox(
//                               width: 70,
//                               height: 70,
//                               child: Icon(Icons.broken_image),
//                             ),
//                       ),
//                     ),
//                     title: Text(
//                       item.title,
//                       maxLines: 1,
//                       overflow: TextOverflow.ellipsis,
//                       style: const TextStyle(
//                         fontWeight: FontWeight.bold,
//                         color: Color(0xFF0C4A6E),
//                       ),
//                     ),
//                     subtitle: Padding(
//                       padding: const EdgeInsets.only(top: 4.0),
//                       child: Text(
//                         item.subtitle,
//                         maxLines: 2,
//                         overflow: TextOverflow.ellipsis,
//                         style: TextStyle(fontSize: 12, color: Colors.grey[600]),
//                       ),
//                     ),
//                     trailing: IconButton(
//                       icon: const Icon(
//                         Icons.delete_outline_rounded,
//                         color: Colors.redAccent,
//                       ),
//                       onPressed: () => _deleteBookmarkItem(item.id),
//                     ),
//                   ),
//                 );
//               },
//             ),
//     );
//   }
// }
