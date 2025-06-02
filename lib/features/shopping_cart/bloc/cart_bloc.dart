import 'package:flutter_bloc/flutter_bloc.dart';
import 'cart_event.dart';
import 'cart_state.dart';
import '../data/cart_repository.dart';

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
      if (cart.items.isEmpty) {
        emit(const CartEmpty());
      } else {
        emit(CartLoaded(cart: cart));
      }
    } catch (e) {
      emit(CartError(errorMessage: e.toString()));
    }
  }

  Future<void> _onAddToCart(AddToCart event, Emitter<CartState> emit) async {
    try {
      // Save current state to restore if there's an error
      emit(const CartLoading());

      final updatedCart = await _cartRepository.addToCart(
        product: event.product,
        selectedColor: event.selectedColor,
        quantity: event.quantity,
        notes: event.notes,
      );

      if (updatedCart.items.isEmpty) {
        emit(const CartEmpty());
      } else {
        emit(CartLoaded(cart: updatedCart));
      }
    } catch (e) {
      emit(CartError(errorMessage: e.toString()));
    }
  }

  Future<void> _onUpdateCartItemQuantity(
    UpdateCartItemQuantity event,
    Emitter<CartState> emit,
  ) async {
    try {
      emit(const CartLoading());

      final updatedCart = await _cartRepository.updateCartItemQuantity(
        cartItemId: event.cartItemId,
        newQuantity: event.newQuantity,
      );

      if (updatedCart.items.isEmpty) {
        emit(const CartEmpty());
      } else {
        emit(CartLoaded(cart: updatedCart));
      }
    } catch (e) {
      emit(CartError(errorMessage: e.toString()));
    }
  }

  Future<void> _onRemoveFromCart(
    RemoveFromCart event,
    Emitter<CartState> emit,
  ) async {
    try {
      emit(const CartLoading());

      final updatedCart = await _cartRepository.removeFromCart(
        cartItemId: event.cartItemId,
      );

      if (updatedCart.items.isEmpty) {
        emit(const CartEmpty());
      } else {
        emit(CartLoaded(cart: updatedCart));
      }
    } catch (e) {
      emit(CartError(errorMessage: e.toString()));
    }
  }

  Future<void> _onClearCart(ClearCart event, Emitter<CartState> emit) async {
    try {
      emit(const CartLoading());

      final updatedCart = await _cartRepository.clearCart();

      emit(const CartEmpty());
    } catch (e) {
      emit(CartError(errorMessage: e.toString()));
    }
  }

  Future<void> _onRefreshCart(
    RefreshCart event,
    Emitter<CartState> emit,
  ) async {
    try {
      emit(const CartLoading());

      final cart = await _cartRepository.loadCart();

      if (cart.items.isEmpty) {
        emit(const CartEmpty());
      } else {
        emit(CartLoaded(cart: cart));
      }
    } catch (e) {
      emit(CartError(errorMessage: e.toString()));
    }
  }

  Future<void> _onApplyDiscountCode(
    ApplyDiscountCode event,
    Emitter<CartState> emit,
  ) async {
    try {
      if (state is! CartLoaded) {
        return;
      }

      final currentState = state as CartLoaded;

      emit(const CartLoading());

      final result = await _cartRepository.applyDiscountCode(
        discountCode: event.discountCode,
      );

      final updatedCart = await _cartRepository.loadCart();

      emit(
        CartLoaded(
          cart: updatedCart,
          appliedDiscountCode: result['discountCode'] as String,
          discountAmount: result['discountAmount'] as double,
        ),
      );
    } catch (e) {
      if (state is CartLoaded) {
        final currentState = state as CartLoaded;
        emit(CartLoaded(cart: currentState.cart));
      } else {
        emit(CartError(errorMessage: e.toString()));
      }
    }
  }

  Future<void> _onRemoveDiscount(
    RemoveDiscount event,
    Emitter<CartState> emit,
  ) async {
    try {
      if (state is! CartLoaded) {
        return;
      }

      emit(const CartLoading());

      // In real implementation, we would call a method to remove the discount
      final updatedCart = await _cartRepository.loadCart();

      emit(CartLoaded(cart: updatedCart));
    } catch (e) {
      emit(CartError(errorMessage: e.toString()));
    }
  }

  Future<void> _onSaveCartForLater(
    SaveCartForLater event,
    Emitter<CartState> emit,
  ) async {
    try {
      emit(const CartLoading());

      await _cartRepository.saveCartForLater();

      emit(const CartEmpty());
    } catch (e) {
      emit(CartError(errorMessage: e.toString()));
    }
  }

  Future<void> _onRestoreSavedCart(
    RestoreSavedCart event,
    Emitter<CartState> emit,
  ) async {
    try {
      emit(const CartLoading());

      final cart = await _cartRepository.restoreSavedCart();

      if (cart == null || cart.items.isEmpty) {
        emit(const CartEmpty());
      } else {
        emit(CartLoaded(cart: cart));
      }
    } catch (e) {
      emit(CartError(errorMessage: e.toString()));
    }
  }

  /// Get the current number of items in the cart
  int getCurrentCartItemCount() {
    // Return the total number of items in the cart (sum of quantities)
    if (state is CartLoaded) {
      return (state as CartLoaded).cart.totalItemCount;
    }

    // Try getting from repository directly for immediate access
    final currentCart = _cartRepository.getCurrentCart();
    return currentCart?.totalItemCount ?? 0;
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
