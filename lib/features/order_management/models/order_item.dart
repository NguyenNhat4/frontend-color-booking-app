import 'package:equatable/equatable.dart';
import '../../product_catalog/models/product.dart';
import '../../product_catalog/models/color.dart';

class OrderItem extends Equatable {
  final String id;
  final Product product;
  final ProductColor selectedColor;
  final int quantity;
  final double priceAtPurchase;
  final String? notes;

  const OrderItem({
    required this.id,
    required this.product,
    required this.selectedColor,
    required this.quantity,
    required this.priceAtPurchase,
    this.notes,
  });

  /// Calculate total price for this order item
  double get totalPrice => priceAtPurchase * quantity;

  OrderItem copyWith({
    String? id,
    Product? product,
    ProductColor? selectedColor,
    int? quantity,
    double? priceAtPurchase,
    String? notes,
  }) {
    return OrderItem(
      id: id ?? this.id,
      product: product ?? this.product,
      selectedColor: selectedColor ?? this.selectedColor,
      quantity: quantity ?? this.quantity,
      priceAtPurchase: priceAtPurchase ?? this.priceAtPurchase,
      notes: notes ?? this.notes,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product': product.toJson(),
      'selectedColor': selectedColor.toJson(),
      'quantity': quantity,
      'priceAtPurchase': priceAtPurchase,
      'notes': notes,
    };
  }

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      id: json['id'] as String,
      product: Product.fromJson(json['product'] as Map<String, dynamic>),
      selectedColor: ProductColor.fromJson(
        json['selectedColor'] as Map<String, dynamic>,
      ),
      quantity: json['quantity'] as int,
      priceAtPurchase: (json['priceAtPurchase'] as num).toDouble(),
      notes: json['notes'] as String?,
    );
  }

  @override
  List<Object?> get props => [
    id,
    product,
    selectedColor,
    quantity,
    priceAtPurchase,
    notes,
  ];
}
