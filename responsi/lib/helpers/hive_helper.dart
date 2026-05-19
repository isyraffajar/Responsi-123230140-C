import 'package:hive_flutter/hive_flutter.dart';
import '../models/data_model.dart'; // Import model generik baru

class HiveHelper {
  static const String boxName = 'app_local_box'; // Nama box dibuat umum

  static Future<void> init() async {
    await Hive.initFlutter();
    
    // Mendaftarkan DataModelAdapter hasil generator build_runner
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(DataModelAdapter());
    }
    
    await Hive.openBox<DataModel>(boxName);
  }

  // Fungsi menyimpan item (Bisa produk atau artikel)
  static Future<void> saveItem(DataModel item) async {
    var box = Hive.box<DataModel>(boxName);
    await box.put(item.id, item);
  }

  // Fungsi mengambil semua data untuk halaman Bookmark / Keranjang / History
  static List<DataModel> getAllItems() {
    var box = Hive.box<DataModel>(boxName);
    return box.values.toList();
  }

  // Fungsi menghapus satu item berdasarkan ID uniknya
  static Future<void> deleteItem(String id) async {
    var box = Hive.box<DataModel>(boxName);
    await box.delete(id);
  }

  // Fungsi mengecek apakah item sudah tersimpan (Sangat berguna untuk toggle ikon bookmark)
  static bool isItemSaved(String id) {
    var box = Hive.box<DataModel>(boxName);
    return box.containsKey(id);
  }
}