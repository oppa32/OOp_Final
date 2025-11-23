import 'package:hive/hive.dart';

part 'product_model.g.dart';

@HiveType(typeId: 1)
class ProductModel extends HiveObject {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final double price;
  @HiveField(3)
  final int stockQuantity;

  ProductModel({
    required this.id,
    required this.name,
    required this.price,
    required this.stockQuantity,
  });

  ProductModel copyWith({
    String? id,
    String? name,
    double? price,
    int? stockQuantity,
  }) {
    return ProductModel(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      stockQuantity: stockQuantity ?? this.stockQuantity,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ProductModel &&
        other.id == id &&
        other.name == name &&
        other.price == price &&
        other.stockQuantity == stockQuantity;
  }

  @override
  int get hashCode =>
      id.hashCode ^ name.hashCode ^ price.hashCode ^ stockQuantity.hashCode;
}
