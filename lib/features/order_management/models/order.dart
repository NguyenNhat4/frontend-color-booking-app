import 'package:equatable/equatable.dart';
import 'order_item.dart';
import 'order_status.dart';

class Order extends Equatable {
  final String id;
  final String userId;
  final List<OrderItem> items;
  final OrderStatus status;
  final double subtotal;
  final double tax;
  final double total;
  final String? shippingAddress;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Order({
    required this.id,
    required this.userId,
    required this.items,
    required this.status,
    required this.subtotal,
    required this.tax,
    required this.total,
    this.shippingAddress,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Get total number of items in order
  int get totalItemCount => items.fold(0, (sum, item) => sum + item.quantity);

  /// Get unique product count
  int get uniqueProductCount => items.length;

  /// Check if order can be cancelled
  bool get canBeCancelled => status.canBeCancelled;

  /// Check if order is in final state
  bool get isFinalState => status.isFinalState;

  Order copyWith({
    String? id,
    String? userId,
    List<OrderItem>? items,
    OrderStatus? status,
    double? subtotal,
    double? tax,
    double? total,
    String? shippingAddress,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Order(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      items: items ?? this.items,
      status: status ?? this.status,
      subtotal: subtotal ?? this.subtotal,
      tax: tax ?? this.tax,
      total: total ?? this.total,
      shippingAddress: shippingAddress ?? this.shippingAddress,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'items': items.map((item) => item.toJson()).toList(),
      'status': status.toJson(),
      'subtotal': subtotal,
      'tax': tax,
      'total': total,
      'shippingAddress': shippingAddress,
      'notes': notes,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'] as String,
      userId: json['userId'] as String,
      items:
          (json['items'] as List<dynamic>)
              .map((item) => OrderItem.fromJson(item as Map<String, dynamic>))
              .toList(),
      status: OrderStatusExtension.fromJson(json['status'] as String),
      subtotal: (json['subtotal'] as num).toDouble(),
      tax: (json['tax'] as num).toDouble(),
      total: (json['total'] as num).toDouble(),
      shippingAddress: json['shippingAddress'] as String?,
      notes: json['notes'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  @override
  List<Object?> get props => [
    id,
    userId,
    items,
    status,
    subtotal,
    tax,
    total,
    shippingAddress,
    notes,
    createdAt,
    updatedAt,
  ];
}
