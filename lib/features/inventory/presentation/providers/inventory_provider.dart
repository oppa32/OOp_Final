import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:state_notifier/state_notifier.dart';
import 'package:hive/hive.dart';
import '../../data/models/product_model.dart';
import '../../data/datasources/inventory_local_datasource.dart';
import '../../data/repositories/inventory_repository_impl.dart';

// 1. Dependency Injection (Remains the same)
final inventoryLocalDataSourceProvider = Provider<InventoryLocalDataSource>((
  ref,
) {
  final box = Hive.box<ProductModel>('inventoryBox');
  return InventoryLocalDataSourceImpl(box);
});

final inventoryRepositoryProvider = Provider<InventoryRepositoryImpl>((ref) {
  final dataSource = ref.watch(inventoryLocalDataSourceProvider);
  return InventoryRepositoryImpl(dataSource);
});

// 2. StateNotifier (Remains the same, but now called by TransactionNotifier)
class InventoryNotifier extends StateNotifier<List<ProductModel>> {
  final InventoryRepositoryImpl repository;

  InventoryNotifier(this.repository) : super([]) {
    loadProducts();
  }

  Future<void> loadProducts() async {
    final result = await repository.getProducts();
    result.fold((failure) => state = [], (products) => state = products);
  }

  Future<void> addProduct(ProductModel product) async {
    final result = await repository.addProduct(product);
    result.fold((failure) => null, (_) => loadProducts());
  }

  Future<void> deleteProduct(String id) async {
    final result = await repository.deleteProduct(id);
    result.fold((failure) => null, (_) => loadProducts());
  }

  Future<void> updateProduct(ProductModel product) async {
    final result = await repository.updateProduct(product);
    result.fold((failure) => null, (_) => loadProducts());
  }
}

// 3. Provider (Remains the same)
final inventoryProvider =
    StateNotifierProvider<InventoryNotifier, List<ProductModel>>((ref) {
      final repository = ref.watch(inventoryRepositoryProvider);
      return InventoryNotifier(repository);
    });
