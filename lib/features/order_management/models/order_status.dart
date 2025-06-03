/// Represents the different statuses an order can have
enum OrderStatus {
  pending,
  confirmed,
  processing,
  shipped,
  delivered,
  cancelled,
  refunded,
}

extension OrderStatusExtension on OrderStatus {
  /// Get a human-readable string representation
  String get displayName {
    switch (this) {
      case OrderStatus.pending:
        return 'Pending';
      case OrderStatus.confirmed:
        return 'Confirmed';
      case OrderStatus.processing:
        return 'Processing';
      case OrderStatus.shipped:
        return 'Shipped';
      case OrderStatus.delivered:
        return 'Delivered';
      case OrderStatus.cancelled:
        return 'Cancelled';
      case OrderStatus.refunded:
        return 'Refunded';
    }
  }

  /// Get a description for the status
  String get description {
    switch (this) {
      case OrderStatus.pending:
        return 'Order has been received and is awaiting confirmation';
      case OrderStatus.confirmed:
        return 'Order has been confirmed and is being prepared';
      case OrderStatus.processing:
        return 'Order is being processed and packaged';
      case OrderStatus.shipped:
        return 'Order has been shipped and is on its way';
      case OrderStatus.delivered:
        return 'Order has been successfully delivered';
      case OrderStatus.cancelled:
        return 'Order has been cancelled';
      case OrderStatus.refunded:
        return 'Order has been refunded';
    }
  }

  /// Check if the order can be cancelled
  bool get canBeCancelled {
    return this == OrderStatus.pending || this == OrderStatus.confirmed;
  }

  /// Check if the order is in a final state
  bool get isFinalState {
    return this == OrderStatus.delivered ||
        this == OrderStatus.cancelled ||
        this == OrderStatus.refunded;
  }

  /// Convert to string for JSON serialization
  String toJson() => name;

  /// Create from string for JSON deserialization
  static OrderStatus fromJson(String value) {
    return OrderStatus.values.firstWhere(
      (status) => status.name == value,
      orElse: () => OrderStatus.pending,
    );
  }
}
