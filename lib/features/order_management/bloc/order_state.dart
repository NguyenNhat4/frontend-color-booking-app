import 'package:equatable/equatable.dart';
import '../models/order.dart';

abstract class OrderState extends Equatable {
  const OrderState();

  @override
  List<Object?> get props => [];
}

/// Initial state when orders are not loaded yet
class OrderInitial extends OrderState {
  const OrderInitial();
}

/// State when order history is being loaded
class OrderHistoryLoading extends OrderState {
  const OrderHistoryLoading();
}

/// State when order history is successfully loaded
class OrderHistoryLoaded extends OrderState {
  final List<Order> orders;
  final String? message;

  const OrderHistoryLoaded({required this.orders, this.message});

  @override
  List<Object?> get props => [orders, message];

  OrderHistoryLoaded copyWith({List<Order>? orders, String? message}) {
    return OrderHistoryLoaded(orders: orders ?? this.orders, message: message);
  }

  /// Create a new state with cleared message
  OrderHistoryLoaded clearMessage() {
    return copyWith(message: null);
  }
}

/// State when order detail is being loaded
class OrderDetailLoading extends OrderState {
  final String orderId;

  const OrderDetailLoading({required this.orderId});

  @override
  List<Object?> get props => [orderId];
}

/// State when order detail is successfully loaded
class OrderDetailLoaded extends OrderState {
  final Order order;
  final String? message;

  const OrderDetailLoaded({required this.order, this.message});

  @override
  List<Object?> get props => [order, message];

  OrderDetailLoaded copyWith({Order? order, String? message}) {
    return OrderDetailLoaded(order: order ?? this.order, message: message);
  }

  /// Create a new state with cleared message
  OrderDetailLoaded clearMessage() {
    return copyWith(message: null);
  }
}

/// State when order operation is in progress (cancelling, reordering)
class OrderOperationInProgress extends OrderState {
  final String operationMessage;
  final String? orderId;

  const OrderOperationInProgress({
    required this.operationMessage,
    this.orderId,
  });

  @override
  List<Object?> get props => [operationMessage, orderId];
}

/// State when order operation is successful
class OrderOperationSuccess extends OrderState {
  final String successMessage;
  final List<Order>? updatedOrders;

  const OrderOperationSuccess({
    required this.successMessage,
    this.updatedOrders,
  });

  @override
  List<Object?> get props => [successMessage, updatedOrders];
}

/// State when there's an error with order operations
class OrderError extends OrderState {
  final String errorMessage;
  final List<Order>? currentOrders;

  const OrderError({required this.errorMessage, this.currentOrders});

  @override
  List<Object?> get props => [errorMessage, currentOrders];
}

/// State when user has no orders
class OrderHistoryEmpty extends OrderState {
  final String message;

  const OrderHistoryEmpty({this.message = 'You have no orders yet'});

  @override
  List<Object?> get props => [message];
}
