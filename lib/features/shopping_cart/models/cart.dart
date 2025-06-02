import 'package:equatable/equatable.dart';
import 'cart_item.dart';

class Cart extends Equatable {
  final String id;
  final String userId;
  final List<CartItem> items;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Cart({
    required this.id,
    required this.userId,
    required this.items,
    required this.createdAt,
    required this.updatedAt,
  });

  // Calculate total number of items in cart
  int get totalItemCount => items.fold(0, (sum, item) => sum + item.quantity);

  // Calculate subtotal (sum of all item totals)
  double get subtotal => items.fold(0.0, (sum, item) => sum + item.totalPrice);

  // Calculate tax (10% for now - this would come from configuration)
  double get tax => subtotal * 0.1;

  // Calculate total including tax
  double get total => subtotal + tax;

  // Check if cart is empty
  bool get isEmpty => items.isEmpty;

  // Check if cart is not empty
  bool get isNotEmpty => items.isNotEmpty;

  // Get unique product count (different from total item count)
  int get uniqueProductCount => items.length;

  Cart copyWith({
    String? id,
    String? userId,
    List<CartItem>? items,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Cart(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      items: items ?? this.items,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // Add item to cart or update quantity if item already exists
  Cart addItem(CartItem newItem) {
    final existingItemIndex = items.indexWhere(
      (item) =>
          item.product.id == newItem.product.id &&
          item.selectedColor.id == newItem.selectedColor.id,
    );

    List<CartItem> updatedItems;
    if (existingItemIndex != -1) {
      // Update existing item quantity
      final existingItem = items[existingItemIndex];
      final updatedItem = existingItem.copyWith(
        quantity: existingItem.quantity + newItem.quantity,
      );
      updatedItems = List.from(items);
      updatedItems[existingItemIndex] = updatedItem;
    } else {
      // Add new item
      updatedItems = [...items, newItem];
    }

    return copyWith(items: updatedItems, updatedAt: DateTime.now());
  }

  // Update item quantity
  Cart updateItemQuantity(String itemId, int newQuantity) {
    if (newQuantity <= 0) {
      return removeItem(itemId);
    }

    final updatedItems =
        items.map((item) {
          if (item.id == itemId) {
            return item.copyWith(quantity: newQuantity);
          }
          return item;
        }).toList();

    return copyWith(items: updatedItems, updatedAt: DateTime.now());
  }

  // Remove item from cart
  Cart removeItem(String itemId) {
    final updatedItems = items.where((item) => item.id != itemId).toList();
    return copyWith(items: updatedItems, updatedAt: DateTime.now());
  }

  // Clear all items from cart
  Cart clearCart() {
    return copyWith(items: [], updatedAt: DateTime.now());
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'items': items.map((item) => item.toJson()).toList(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory Cart.fromJson(Map<String, dynamic> json) {
    return Cart(
      id: json['id'] as String,
      userId: json['userId'] as String,
      items:
          (json['items'] as List<dynamic>)
              .map((item) => CartItem.fromJson(item as Map<String, dynamic>))
              .toList(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  // Create empty cart
  factory Cart.empty({required String userId}) {
    final now = DateTime.now();
    return Cart(
      id: 'cart_${userId}_${now.millisecondsSinceEpoch}',
      userId: userId,
      items: [],
      createdAt: now,
      updatedAt: now,
    );
  }

  @override
  List<Object?> get props => [id, userId, items, createdAt, updatedAt];
}
