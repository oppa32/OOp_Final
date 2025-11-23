import 'package:hive/hive.dart';
import '../models/transaction_model.dart';

abstract class TransactionLocalDataSource {
  Future<List<TransactionModel>> getTransactions();
  Future<void> addTransaction(TransactionModel transaction);
  Future<void> deleteTransaction(String id);
  Future<void> updateTransaction(TransactionModel transaction);
}

class TransactionLocalDataSourceImpl implements TransactionLocalDataSource {
  final Box<TransactionModel> transactionBox;

  TransactionLocalDataSourceImpl(this.transactionBox);

  @override
  Future<List<TransactionModel>> getTransactions() async {
    return transactionBox.values.toList();
  }

  @override
  Future<void> addTransaction(TransactionModel transaction) async {
    await transactionBox.put(transaction.id, transaction);
  }

  @override
  Future<void> deleteTransaction(String id) async {
    await transactionBox.delete(id);
  }

  @override
  Future<void> updateTransaction(TransactionModel transaction) async {
    await transactionBox.put(transaction.id, transaction);
  }
}
