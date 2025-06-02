import 'package:equatable/equatable.dart';
import '../models/cart.dart';

abstract class CartState extends Equatable {
  const CartState();

  @override
  List<Object?> get props => [];
}

/// Initial state when cart is not loaded yet
class CartInitial extends CartState {
  const CartInitial();
}

/// State when cart is being loaded
class CartLoading extends CartState {
  const CartLoading();
}

/// State when cart is successfully loaded
class CartLoaded extends CartState {
  final Cart cart;
  final String? appliedDiscountCode;
  final double discountAmount;
  final String? message;

  const CartLoaded({
    required this.cart,
    this.appliedDiscountCode,
    this.discountAmount = 0.0,
    this.message,
  });

  /// Calculate final total after discount
  double get finalTotal => cart.total - discountAmount;

  @override
  List<Object?> get props => [
    cart,
    appliedDiscountCode,
    discountAmount,
    message,
  ];

  CartLoaded copyWith({
    Cart? cart,
    String? appliedDiscountCode,
    double? discountAmount,
    String? message,
  }) {
    return CartLoaded(
      cart: cart ?? this.cart,
      appliedDiscountCode: appliedDiscountCode ?? this.appliedDiscountCode,
      discountAmount: discountAmount ?? this.discountAmount,
      message: message,
    );
  }

  /// Create a new state with cleared message
  CartLoaded clearMessage() {
    return copyWith(message: null);
  }
}

/// State when cart operation is in progress (adding, updating, removing items)
class CartOperationInProgress extends CartState {
  final Cart currentCart;
  final String operationMessage;

  const CartOperationInProgress({
    required this.currentCart,
    required this.operationMessage,
  });

  @override
  List<Object?> get props => [currentCart, operationMessage];
}

/// State when cart operation is successful
class CartOperationSuccess extends CartState {
  final Cart updatedCart;
  final String successMessage;

  const CartOperationSuccess({
    required this.updatedCart,
    required this.successMessage,
  });

  @override
  List<Object?> get props => [updatedCart, successMessage];
}

/// State when there's an error with cart operations
class CartError extends CartState {
  final String errorMessage;
  final Cart? currentCart;

  const CartError({required this.errorMessage, this.currentCart});

  @override
  List<Object?> get props => [errorMessage, currentCart];
}

/// State when cart is empty
class CartEmpty extends CartState {
  final String message;

  const CartEmpty({this.message = 'Your cart is empty'});

  @override
  List<Object?> get props => [message];
}

/// State when discount is being applied
class CartDiscountLoading extends CartState {
  final Cart currentCart;
  final String discountCode;

  const CartDiscountLoading({
    required this.currentCart,
    required this.discountCode,
  });

  @override
  List<Object?> get props => [currentCart, discountCode];
}

/// State when discount is successfully applied
class CartDiscountApplied extends CartState {
  final Cart cart;
  final String discountCode;
  final double discountAmount;
  final String successMessage;

  const CartDiscountApplied({
    required this.cart,
    required this.discountCode,
    required this.discountAmount,
    required this.successMessage,
  });

  @override
  List<Object?> get props => [
    cart,
    discountCode,
    discountAmount,
    successMessage,
  ];
}

/// State when discount application fails
class CartDiscountError extends CartState {
  final Cart currentCart;
  final String errorMessage;

  const CartDiscountError({
    required this.currentCart,
    required this.errorMessage,
  });

  @override
  List<Object?> get props => [currentCart, errorMessage];
}
