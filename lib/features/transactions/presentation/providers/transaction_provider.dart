import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:state_notifier/state_notifier.dart';
import 'package:hive/hive.dart';
import '../../data/models/transaction_model.dart';
import '../../data/datasources/transaction_local_datasource.dart';
import '../../data/repositories/transaction_repository_impl.dart';
// ADDED: Import Inventory Provider for cross-feature communication
import '../../../inventory/presentation/providers/inventory_provider.dart';

// 1. Dependency Injection: Data Source (Remains the same)
final transactionLocalDataSourceProvider = Provider<TransactionLocalDataSource>(
  (ref) {
    final box = Hive.box<TransactionModel>('transactionsBox');
    return TransactionLocalDataSourceImpl(box);
  },
);

// 2. Dependency Injection: Repository (Remains the same)
final transactionRepositoryProvider = Provider<TransactionRepositoryImpl>((
  ref,
) {
  final localDataSource = ref.watch(transactionLocalDataSourceProvider);
  return TransactionRepositoryImpl(localDataSource);
});

// 3. StateNotifier: Manages the List of Transactions (UPDATED)
class TransactionNotifier extends StateNotifier<List<TransactionModel>> {
  final TransactionRepositoryImpl repository;
  // NEW: Reference to the Inventory Notifier
  final InventoryNotifier inventoryNotifier;

  TransactionNotifier(this.repository, this.inventoryNotifier) : super([]) {
    loadTransactions();
  }

  Future<void> loadTransactions() async {
    final result = await repository.getTransactions();
    result.fold(
      (failure) => state = [],
      (transactions) => state = transactions,
    );
  }

  Future<void> addTransaction(TransactionModel transaction) async {
    final result = await repository.addTransaction(transaction);

    result.fold(
      (failure) => null, // Handle error
      (_) async {
        // === NEW INVENTORY LOGIC ===
        final pId = transaction.productId;
        final qty = transaction.quantity;

        if (pId != null && qty != null) {
          await _updateInventory(pId, qty, transaction.type);
        }
        // ===========================

        loadTransactions();
      },
    );
  }

  // NEW METHOD: Handles the stock calculation
  Future<void> _updateInventory(
    String productId,
    int quantity,
    String type,
  ) async {
    // 1. Find the current product in the Inventory Notifier's state
    final currentProduct = inventoryNotifier.state.firstWhere(
      (p) => p.id == productId,
      orElse: () => throw Exception('Product not found'),
    );

    // 2. Calculate new stock based on transaction type
    int newStock = currentProduct.stockQuantity;

    if (type == 'expense') {
      // Expense (Purchase) -> stock INCREASES
      newStock = currentProduct.stockQuantity + quantity;
    } else if (type == 'income') {
      // Income (Sale) -> stock DECREASES
      newStock = currentProduct.stockQuantity - quantity;
    }

    // 3. Create the updated Product Model
    final updatedProduct = currentProduct.copyWith(stockQuantity: newStock);

    // 4. Call the Inventory Notifier's update method
    await inventoryNotifier.updateProduct(updatedProduct);
  }

  Future<void> deleteTransaction(String id) async {
    final result = await repository.deleteTransaction(id);
    result.fold((failure) => null, (_) => loadTransactions());
  }
}

// 4. The Provider consumed by the UI (UPDATED to pass inventoryNotifier)
final transactionProvider =
    StateNotifierProvider<TransactionNotifier, List<TransactionModel>>((ref) {
      final repository = ref.watch(transactionRepositoryProvider);
      // NEW: Read the inventoryNotifier here
      final inventoryNotifier = ref.watch(inventoryProvider.notifier);
      return TransactionNotifier(repository, inventoryNotifier);
    });
