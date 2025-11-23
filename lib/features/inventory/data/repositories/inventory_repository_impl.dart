import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../datasources/inventory_local_datasource.dart';
import '../models/product_model.dart';

class InventoryRepositoryImpl {
  final InventoryLocalDataSource localDataSource;

  InventoryRepositoryImpl(this.localDataSource);

  Future<Either<Failure, List<ProductModel>>> getProducts() async {
    try {
      final result = await localDataSource.getProducts();
      return Right(result);
    } catch (e) {
      return Left(DatabaseFailure("Failed to load inventory"));
    }
  }

  Future<Either<Failure, void>> addProduct(ProductModel product) async {
    try {
      await localDataSource.addProduct(product);
      return Right(null);
    } catch (e) {
      return Left(DatabaseFailure("Failed to add product"));
    }
  }

  Future<Either<Failure, void>> deleteProduct(String id) async {
    try {
      await localDataSource.deleteProduct(id);
      return Right(null);
    } catch (e) {
      return Left(DatabaseFailure("Failed to delete product"));
    }
  }

  Future<Either<Failure, void>> updateProduct(ProductModel product) async {
    try {
      await localDataSource.updateProduct(product);
      return Right(null);
    } catch (e) {
      return Left(DatabaseFailure("Failed to update product"));
    }
  }
}
