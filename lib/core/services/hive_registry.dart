import 'package:hive_flutter/hive_flutter.dart';
import '../../features/transactions/data/models/transaction_model.dart';
// Add this import
import '../../features/inventory/data/models/product_model.dart';

class HiveRegistry {
  static Future<void> init() async {
    await Hive.initFlutter();

    // Register Adapters
    Hive.registerAdapter(TransactionModelAdapter());
    Hive.registerAdapter(ProductModelAdapter()); // Add this line

    // Open Boxes
    await Hive.openBox<TransactionModel>('transactionsBox');
    await Hive.openBox<ProductModel>('inventoryBox'); // Add this line
  }
}
