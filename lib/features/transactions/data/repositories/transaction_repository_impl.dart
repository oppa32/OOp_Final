import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../datasources/transaction_local_datasource.dart';
import '../models/transaction_model.dart';

// Note: Usually we define an abstract Repository interface in the domain layer,
// but for Vibe Coding/Simplicity, we often define the interface implicitly or
// keep the implementation self-contained if sticking to strict folder limits.
// Below is the implementation.

class TransactionRepositoryImpl {
  final TransactionLocalDataSource localDataSource;

  TransactionRepositoryImpl(this.localDataSource);

  Future<Either<Failure, List<TransactionModel>>> getTransactions() async {
    try {
      final result = await localDataSource.getTransactions();
      return Right(result);
    } catch (e) {
      return Left(DatabaseFailure("Failed to load transactions"));
    }
  }

  Future<Either<Failure, void>> addTransaction(
    TransactionModel transaction,
  ) async {
    try {
      await localDataSource.addTransaction(transaction);
      return Right(null);
    } catch (e) {
      return Left(DatabaseFailure("Failed to add transaction"));
    }
  }

  Future<Either<Failure, void>> deleteTransaction(String id) async {
    try {
      await localDataSource.deleteTransaction(id);
      return Right(null);
    } catch (e) {
      return Left(DatabaseFailure("Failed to delete transaction"));
    }
  }

  Future<Either<Failure, void>> updateTransaction(
    TransactionModel transaction,
  ) async {
    try {
      await localDataSource.updateTransaction(transaction);
      return Right(null);
    } catch (e) {
      return Left(DatabaseFailure("Failed to update transaction"));
    }
  }
}
