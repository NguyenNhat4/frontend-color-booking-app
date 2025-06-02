import 'dart:async';
import 'dart:math';
import '../models/cart.dart';
import '../models/cart_item.dart';
import '../../product_catalog/models/product.dart';
import '../../product_catalog/models/color.dart';

class CartRepository {
  // Simulate network delay
  static const Duration _networkDelay = Duration(milliseconds: 800);

  // In-memory cart storage (simulates local storage or API)
  Cart? _currentCart;

  // Simulate user ID (in real app this would come from auth)
  final String _userId = 'user_123';

  /// Load the current user's cart
  Future<Cart> loadCart() async {
    await Future.delayed(_networkDelay);

    // If no cart exists, create an empty one
    _currentCart ??= Cart.empty(userId: _userId);

    return _currentCart!;
  }

  /// Add item to cart
  Future<Cart> addToCart({
    required Product product,
    required ProductColor selectedColor,
    int quantity = 1,
    String? notes,
  }) async {
    await Future.delayed(_networkDelay);

    // Load current cart if not loaded
    _currentCart ??= Cart.empty(userId: _userId);

    // Create new cart item
    final cartItem = CartItem(
      id:
          'item_${DateTime.now().millisecondsSinceEpoch}_${Random().nextInt(1000)}',
      product: product,
      selectedColor: selectedColor,
      quantity: quantity,
      priceAtAddition: product.basePrice,
      addedAt: DateTime.now(),
      notes: notes,
    );

    // Add item to cart
    _currentCart = _currentCart!.addItem(cartItem);

    return _currentCart!;
  }

  /// Update cart item quantity
  Future<Cart> updateCartItemQuantity({
    required String cartItemId,
    required int newQuantity,
  }) async {
    await Future.delayed(_networkDelay);

    if (_currentCart == null) {
      throw Exception('Cart not found');
    }

    _currentCart = _currentCart!.updateItemQuantity(cartItemId, newQuantity);

    return _currentCart!;
  }

  /// Remove item from cart
  Future<Cart> removeFromCart({required String cartItemId}) async {
    await Future.delayed(_networkDelay);

    if (_currentCart == null) {
      throw Exception('Cart not found');
    }

    _currentCart = _currentCart!.removeItem(cartItemId);

    return _currentCart!;
  }

  /// Clear all items from cart
  Future<Cart> clearCart() async {
    await Future.delayed(_networkDelay);

    if (_currentCart == null) {
      throw Exception('Cart not found');
    }

    _currentCart = _currentCart!.clearCart();

    return _currentCart!;
  }

  /// Apply discount code
  Future<Map<String, dynamic>> applyDiscountCode({
    required String discountCode,
  }) async {
    await Future.delayed(_networkDelay);

    if (_currentCart == null) {
      throw Exception('Cart not found');
    }

    // Simulate discount validation
    final validDiscountCodes = {
      'SAVE10': 0.10, // 10% discount
      'SAVE20': 0.20, // 20% discount
      'WELCOME': 0.15, // 15% discount for new users
      'CONTRACTOR': 0.25, // 25% discount for contractors
    };

    if (!validDiscountCodes.containsKey(discountCode.toUpperCase())) {
      throw Exception('Invalid discount code');
    }

    final discountPercentage = validDiscountCodes[discountCode.toUpperCase()]!;
    final discountAmount = _currentCart!.subtotal * discountPercentage;

    return {
      'discountCode': discountCode.toUpperCase(),
      'discountAmount': discountAmount,
      'discountPercentage': discountPercentage,
      'message': 'Discount applied successfully!',
    };
  }

  /// Get cart item count (for badge display)
  Future<int> getCartItemCount() async {
    if (_currentCart == null) {
      return 0;
    }
    return _currentCart!.totalItemCount;
  }

  /// Save cart for later (for guest users)
  Future<void> saveCartForLater() async {
    await Future.delayed(_networkDelay);
    // In real implementation, this would save to local storage
    // For now, we'll just simulate the operation
  }

  /// Restore saved cart
  Future<Cart?> restoreSavedCart() async {
    await Future.delayed(_networkDelay);
    // In real implementation, this would load from local storage
    // For now, we'll return null (no saved cart)
    return null;
  }

  /// Simulate network error for testing
  Future<void> simulateNetworkError() async {
    await Future.delayed(_networkDelay);
    throw Exception('Network error: Unable to connect to server');
  }

  /// Get current cart without network call (for immediate access)
  Cart? getCurrentCart() {
    return _currentCart;
  }

  /// Check if cart has items
  bool hasItems() {
    return _currentCart?.isNotEmpty ?? false;
  }

  /// Get cart total for quick access
  double getCartTotal() {
    return _currentCart?.total ?? 0.0;
  }

  /// Clear repository (for testing)
  void clearRepository() {
    _currentCart = null;
  }
}
