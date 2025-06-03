import 'package:equatable/equatable.dart';

abstract class OrderEvent extends Equatable {
  const OrderEvent();

  @override
  List<Object?> get props => [];
}

/// Event to fetch user's order history
class FetchOrderHistory extends OrderEvent {
  const FetchOrderHistory();
}

/// Event to fetch a specific order detail
class FetchOrderDetail extends OrderEvent {
  final String orderId;

  const FetchOrderDetail({required this.orderId});

  @override
  List<Object?> get props => [orderId];
}

/// Event to refresh order history (useful for pull-to-refresh)
class RefreshOrderHistory extends OrderEvent {
  const RefreshOrderHistory();
}

/// Event to cancel an order
class CancelOrder extends OrderEvent {
  final String orderId;

  const CancelOrder({required this.orderId});

  @override
  List<Object?> get props => [orderId];
}

/// Event to reorder items from a previous order
class ReorderFromOrder extends OrderEvent {
  final String orderId;

  const ReorderFromOrder({required this.orderId});

  @override
  List<Object?> get props => [orderId];
}

/// Event to track an order (placeholder for future tracking integration)
class TrackOrder extends OrderEvent {
  final String orderId;

  const TrackOrder({required this.orderId});

  @override
  List<Object?> get props => [orderId];
}
