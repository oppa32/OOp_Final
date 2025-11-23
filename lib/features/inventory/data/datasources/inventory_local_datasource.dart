import 'package:hive/hive.dart';
import '../models/product_model.dart';

abstract class InventoryLocalDataSource {
  Future<List<ProductModel>> getProducts();
  Future<void> addProduct(ProductModel product);
  Future<void> deleteProduct(String id);
  Future<void> updateProduct(ProductModel product);
}

class InventoryLocalDataSourceImpl implements InventoryLocalDataSource {
  final Box<ProductModel> productBox;

  InventoryLocalDataSourceImpl(this.productBox);

  @override
  Future<List<ProductModel>> getProducts() async {
    return productBox.values.toList();
  }

  @override
  Future<void> addProduct(ProductModel product) async {
    await productBox.put(product.id, product);
  }

  @override
  Future<void> deleteProduct(String id) async {
    await productBox.delete(id);
  }

  @override
  Future<void> updateProduct(ProductModel product) async {
    await productBox.put(product.id, product);
  }
}
