import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../providers/inventory_provider.dart';
import '../../data/models/product_model.dart';

class InventoryScreen extends ConsumerWidget {
  const InventoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final products = ref.watch(inventoryProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Inventory')),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Quick add dialog for simplicity in this demo
          _showAddProductDialog(context, ref);
        },
        child: const Icon(Icons.add),
      ),
      body: products.isEmpty
          ? const Center(child: Text("No inventory items."))
          : ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return ListTile(
                  title: Text(product.name),
                  subtitle: Text('Stock: ${product.stockQuantity}'),
                  trailing: Text('₱${product.price.toStringAsFixed(2)}'),
                  onLongPress: () {
                    ref
                        .read(inventoryProvider.notifier)
                        .deleteProduct(product.id);
                  },
                );
              },
            ),
    );
  }

  void _showAddProductDialog(BuildContext context, WidgetRef ref) {
    // A simple dialog to speed up Member 2's task,
    // but you can replace this with a full FormBuilder screen later.
    final nameController = TextEditingController();
    final priceController = TextEditingController();
    final stockController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Add Product"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: "Name"),
            ),
            TextField(
              controller: priceController,
              decoration: const InputDecoration(labelText: "Price"),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: stockController,
              decoration: const InputDecoration(labelText: "Stock"),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              final product = ProductModel(
                id: const Uuid().v4(),
                name: nameController.text,
                price: double.tryParse(priceController.text) ?? 0,
                stockQuantity: int.tryParse(stockController.text) ?? 0,
              );
              ref.read(inventoryProvider.notifier).addProduct(product);
              Navigator.pop(ctx);
            },
            child: const Text("Add"),
          ),
        ],
      ),
    );
  }
}
