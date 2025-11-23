import 'package:hive/hive.dart';

part 'transaction_model.g.dart';

@HiveType(typeId: 0)
class TransactionModel extends HiveObject {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String title;
  @HiveField(2)
  final double amount;
  @HiveField(3)
  final DateTime date;
  @HiveField(4)
  final String type; // 'income' or 'expense'

  // NEW FIELDS for Inventory Link
  @HiveField(5)
  final String? productId; // ID of the linked product
  @HiveField(6)
  final int? quantity; // Quantity sold or purchased

  TransactionModel({
    required this.id,
    required this.title,
    required this.amount,
    required this.date,
    required this.type,
    this.productId,
    this.quantity,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TransactionModel &&
        other.id == id &&
        other.title == title &&
        other.amount == amount &&
        other.date == date &&
        other.type == type &&
        other.productId == productId &&
        other.quantity == quantity;
  }

  @override
  int get hashCode =>
      id.hashCode ^
      title.hashCode ^
      amount.hashCode ^
      date.hashCode ^
      type.hashCode ^
      productId.hashCode ^
      quantity.hashCode;
}
