import 'package:flutter_bloc/flutter_bloc.dart';
import 'cart_event.dart';
import 'cart_state.dart';
import '../data/cart_repository.dart';
import '../models/cart.dart';
import '../models/cart_item.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final CartRepository _cartRepository;

  CartBloc({CartRepository? cartRepository})
    : _cartRepository = cartRepository ?? CartRepository(),
      super(const CartInitial()) {
    on<LoadCart>(_onLoadCart);
    on<AddToCart>(_onAddToCart);
    on<UpdateCartItemQuantity>(_onUpdateCartItemQuantity);
    on<RemoveFromCart>(_onRemoveFromCart);
    on<ClearCart>(_onClearCart);
    on<RefreshCart>(_onRefreshCart);
    on<ApplyDiscountCode>(_onApplyDiscountCode);
    on<RemoveDiscount>(_onRemoveDiscount);
    on<SaveCartForLater>(_onSaveCartForLater);
    on<RestoreSavedCart>(_onRestoreSavedCart);
  }

  Future<void> _onLoadCart(LoadCart event, Emitter<CartState> emit) async {
    try {
      emit(const CartLoading());

      final cart = await _cartRepository.loadCart();

      if (cart.isEmpty) {
        emit(const CartEmpty());
      } else {
        emit(CartLoaded(cart: cart));
      }
    } catch (error) {
      emit(CartError(errorMessage: 'Failed to load cart: ${error.toString()}'));
    }
  }

  Future<void> _onAddToCart(AddToCart event, Emitter<CartState> emit) async {
    try {
      // Show operation in progress if we have a current cart
      final currentCart = _cartRepository.getCurrentCart();
      if (currentCart != null) {
        emit(
          CartOperationInProgress(
            currentCart: currentCart,
            operationMessage: 'Adding ${event.product.name} to cart...',
          ),
        );
      } else {
        emit(const CartLoading());
      }

      final updatedCart = await _cartRepository.addToCart(
        product: event.product,
        selectedColor: event.selectedColor,
        quantity: event.quantity,
        notes: event.notes,
      );

      emit(
        CartLoaded(
          cart: updatedCart,
          message:
              '${event.product.name} (${event.selectedColor.name}) added to cart',
        ),
      );
    } catch (error) {
      final currentCart = _cartRepository.getCurrentCart();
      emit(
        CartError(
          errorMessage: 'Failed to add item to cart: ${error.toString()}',
          currentCart: currentCart,
        ),
      );
    }
  }

  Future<void> _onUpdateCartItemQuantity(
    UpdateCartItemQuantity event,
    Emitter<CartState> emit,
  ) async {
    try {
      final currentCart = _cartRepository.getCurrentCart();
      if (currentCart == null) {
        emit(const CartError(errorMessage: 'Cart not found'));
        return;
      }

      emit(
        CartOperationInProgress(
          currentCart: currentCart,
          operationMessage: 'Updating quantity...',
        ),
      );

      final updatedCart = await _cartRepository.updateCartItemQuantity(
        cartItemId: event.cartItemId,
        newQuantity: event.newQuantity,
      );

      if (updatedCart.isEmpty) {
        emit(const CartEmpty(message: 'Your cart is now empty'));
      } else {
        emit(CartLoaded(cart: updatedCart, message: 'Quantity updated'));
      }
    } catch (error) {
      final currentCart = _cartRepository.getCurrentCart();
      emit(
        CartError(
          errorMessage: 'Failed to update quantity: ${error.toString()}',
          currentCart: currentCart,
        ),
      );
    }
  }

  Future<void> _onRemoveFromCart(
    RemoveFromCart event,
    Emitter<CartState> emit,
  ) async {
    try {
      final currentCart = _cartRepository.getCurrentCart();
      if (currentCart == null) {
        emit(const CartError(errorMessage: 'Cart not found'));
        return;
      }

      emit(
        CartOperationInProgress(
          currentCart: currentCart,
          operationMessage: 'Removing item...',
        ),
      );

      final updatedCart = await _cartRepository.removeFromCart(
        cartItemId: event.cartItemId,
      );

      if (updatedCart.isEmpty) {
        emit(const CartEmpty(message: 'Item removed. Your cart is now empty'));
      } else {
        emit(CartLoaded(cart: updatedCart, message: 'Item removed from cart'));
      }
    } catch (error) {
      final currentCart = _cartRepository.getCurrentCart();
      emit(
        CartError(
          errorMessage: 'Failed to remove item: ${error.toString()}',
          currentCart: currentCart,
        ),
      );
    }
  }

  Future<void> _onClearCart(ClearCart event, Emitter<CartState> emit) async {
    try {
      final currentCart = _cartRepository.getCurrentCart();
      if (currentCart == null) {
        emit(const CartEmpty());
        return;
      }

      emit(
        CartOperationInProgress(
          currentCart: currentCart,
          operationMessage: 'Clearing cart...',
        ),
      );

      await _cartRepository.clearCart();
      emit(const CartEmpty(message: 'Cart cleared successfully'));
    } catch (error) {
      final currentCart = _cartRepository.getCurrentCart();
      emit(
        CartError(
          errorMessage: 'Failed to clear cart: ${error.toString()}',
          currentCart: currentCart,
        ),
      );
    }
  }

  Future<void> _onRefreshCart(
    RefreshCart event,
    Emitter<CartState> emit,
  ) async {
    // Refresh is essentially the same as loading
    add(const LoadCart());
  }

  Future<void> _onApplyDiscountCode(
    ApplyDiscountCode event,
    Emitter<CartState> emit,
  ) async {
    try {
      final currentCart = _cartRepository.getCurrentCart();
      if (currentCart == null || currentCart.isEmpty) {
        emit(
          const CartError(errorMessage: 'Cannot apply discount to empty cart'),
        );
        return;
      }

      emit(
        CartDiscountLoading(
          currentCart: currentCart,
          discountCode: event.discountCode,
        ),
      );

      final discountResult = await _cartRepository.applyDiscountCode(
        discountCode: event.discountCode,
      );

      emit(
        CartLoaded(
          cart: currentCart,
          appliedDiscountCode: discountResult['discountCode'] as String,
          discountAmount: discountResult['discountAmount'] as double,
          message: discountResult['message'] as String,
        ),
      );
    } catch (error) {
      final currentCart = _cartRepository.getCurrentCart();
      emit(CartError(errorMessage: error.toString(), currentCart: currentCart));
    }
  }

  Future<void> _onRemoveDiscount(
    RemoveDiscount event,
    Emitter<CartState> emit,
  ) async {
    final currentCart = _cartRepository.getCurrentCart();
    if (currentCart == null) {
      emit(const CartError(errorMessage: 'Cart not found'));
      return;
    }

    emit(CartLoaded(cart: currentCart, message: 'Discount removed'));
  }

  Future<void> _onSaveCartForLater(
    SaveCartForLater event,
    Emitter<CartState> emit,
  ) async {
    try {
      await _cartRepository.saveCartForLater();
      final currentCart = _cartRepository.getCurrentCart();

      if (currentCart != null) {
        emit(CartLoaded(cart: currentCart, message: 'Cart saved for later'));
      }
    } catch (error) {
      final currentCart = _cartRepository.getCurrentCart();
      emit(
        CartError(
          errorMessage: 'Failed to save cart: ${error.toString()}',
          currentCart: currentCart,
        ),
      );
    }
  }

  Future<void> _onRestoreSavedCart(
    RestoreSavedCart event,
    Emitter<CartState> emit,
  ) async {
    try {
      emit(const CartLoading());

      final savedCart = await _cartRepository.restoreSavedCart();

      if (savedCart == null || savedCart.isEmpty) {
        emit(const CartEmpty(message: 'No saved cart found'));
      } else {
        emit(
          CartLoaded(cart: savedCart, message: 'Cart restored successfully'),
        );
      }
    } catch (error) {
      emit(
        CartError(errorMessage: 'Failed to restore cart: ${error.toString()}'),
      );
    }
  }

  /// Get current cart item count for badge display
  int getCurrentCartItemCount() {
    final cart = _cartRepository.getCurrentCart();
    return cart?.totalItemCount ?? 0;
  }

  /// Check if cart has items
  bool hasItems() {
    return _cartRepository.hasItems();
  }

  /// Get cart total for quick access
  double getCartTotal() {
    return _cartRepository.getCartTotal();
  }
}
