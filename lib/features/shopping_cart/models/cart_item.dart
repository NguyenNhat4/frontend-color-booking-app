import 'package:equatable/equatable.dart';
import '../../product_catalog/models/product.dart';
import '../../product_catalog/models/color.dart';

class CartItem extends Equatable {
  final String id;
  final Product product;
  final ProductColor selectedColor;
  final int quantity;
  final double priceAtAddition;
  final DateTime addedAt;
  final String? notes;

  const CartItem({
    required this.id,
    required this.product,
    required this.selectedColor,
    required this.quantity,
    required this.priceAtAddition,
    required this.addedAt,
    this.notes,
  });

  double get totalPrice => priceAtAddition * quantity;

  CartItem copyWith({
    String? id,
    Product? product,
    ProductColor? selectedColor,
    int? quantity,
    double? priceAtAddition,
    DateTime? addedAt,
    String? notes,
  }) {
    return CartItem(
      id: id ?? this.id,
      product: product ?? this.product,
      selectedColor: selectedColor ?? this.selectedColor,
      quantity: quantity ?? this.quantity,
      priceAtAddition: priceAtAddition ?? this.priceAtAddition,
      addedAt: addedAt ?? this.addedAt,
      notes: notes ?? this.notes,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product': product.toJson(),
      'selectedColor': selectedColor.toJson(),
      'quantity': quantity,
      'priceAtAddition': priceAtAddition,
      'addedAt': addedAt.toIso8601String(),
      'notes': notes,
    };
  }

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['id'] as String,
      product: Product.fromJson(json['product'] as Map<String, dynamic>),
      selectedColor: ProductColor.fromJson(
        json['selectedColor'] as Map<String, dynamic>,
      ),
      quantity: json['quantity'] as int,
      priceAtAddition: (json['priceAtAddition'] as num).toDouble(),
      addedAt: DateTime.parse(json['addedAt'] as String),
      notes: json['notes'] as String?,
    );
  }

  @override
  List<Object?> get props => [
    id,
    product,
    selectedColor,
    quantity,
    priceAtAddition,
    addedAt,
    notes,
  ];
}
