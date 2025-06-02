import 'package:equatable/equatable.dart';
import '../../product_catalog/models/product.dart';
import '../../product_catalog/models/color.dart';

abstract class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object?> get props => [];
}

/// Event to load the current user's cart
class LoadCart extends CartEvent {
  const LoadCart();
}

/// Event to add a product with selected color to cart
class AddToCart extends CartEvent {
  final Product product;
  final ProductColor selectedColor;
  final int quantity;
  final String? notes;

  const AddToCart({
    required this.product,
    required this.selectedColor,
    this.quantity = 1,
    this.notes,
  });

  @override
  List<Object?> get props => [product, selectedColor, quantity, notes];
}

/// Event to update the quantity of an existing cart item
class UpdateCartItemQuantity extends CartEvent {
  final String cartItemId;
  final int newQuantity;

  const UpdateCartItemQuantity({
    required this.cartItemId,
    required this.newQuantity,
  });

  @override
  List<Object?> get props => [cartItemId, newQuantity];
}

/// Event to remove an item from the cart
class RemoveFromCart extends CartEvent {
  final String cartItemId;

  const RemoveFromCart({required this.cartItemId});

  @override
  List<Object?> get props => [cartItemId];
}

/// Event to clear all items from the cart
class ClearCart extends CartEvent {
  const ClearCart();
}

/// Event to refresh the cart (useful for pull-to-refresh)
class RefreshCart extends CartEvent {
  const RefreshCart();
}

/// Event to apply a discount code to the cart
class ApplyDiscountCode extends CartEvent {
  final String discountCode;

  const ApplyDiscountCode({required this.discountCode});

  @override
  List<Object?> get props => [discountCode];
}

/// Event to remove applied discount
class RemoveDiscount extends CartEvent {
  const RemoveDiscount();
}

/// Event to save cart for later (for guest users)
class SaveCartForLater extends CartEvent {
  const SaveCartForLater();
}

/// Event to restore saved cart
class RestoreSavedCart extends CartEvent {
  const RestoreSavedCart();
}
