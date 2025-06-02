import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/cart_bloc.dart';
import '../../bloc/cart_event.dart';
import '../../bloc/cart_state.dart';
import '../widgets/cart_item_widget.dart';
import '../widgets/cart_summary_widget.dart';
import '../../../../core/theme/paint_app_colors.dart';

class ShoppingCartScreen extends StatefulWidget {
  const ShoppingCartScreen({super.key});

  @override
  State<ShoppingCartScreen> createState() => _ShoppingCartScreenState();

  // Static method to create screen with Bloc provider
  static Widget withBloc() {
    return BlocProvider(
      create: (context) => CartBloc()..add(const LoadCart()),
      child: const ShoppingCartScreen(),
    );
  }
}

class _ShoppingCartScreenState extends State<ShoppingCartScreen> {
  final TextEditingController _discountController = TextEditingController();

  @override
  void dispose() {
    _discountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PaintAppColors.backgroundPrimary,
      appBar: _buildAppBar(context),
      body: BlocConsumer<CartBloc, CartState>(
        listener: (context, state) {
          if (state is CartLoaded && state.message != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message!),
                backgroundColor: PaintAppColors.success,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            );
          } else if (state is CartError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage),
                backgroundColor: PaintAppColors.error,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is CartLoading) {
            return _buildLoadingState();
          }

          if (state is CartEmpty) {
            return _buildEmptyState(context, state.message);
          }

          if (state is CartError && state.currentCart == null) {
            return _buildErrorState(context, state.errorMessage);
          }

          if (state is CartLoaded ||
              (state is CartError && state.currentCart != null) ||
              state is CartOperationInProgress) {
            final cart =
                state is CartLoaded
                    ? state.cart
                    : state is CartError
                    ? state.currentCart!
                    : (state as CartOperationInProgress).currentCart;

            final appliedDiscountCode =
                state is CartLoaded ? state.appliedDiscountCode : null;
            final discountAmount =
                state is CartLoaded ? state.discountAmount : 0.0;
            final isLoading = state is CartOperationInProgress;

            return _buildCartContent(
              context,
              cart,
              appliedDiscountCode: appliedDiscountCode,
              discountAmount: discountAmount,
              isLoading: isLoading,
            );
          }

          return _buildErrorState(context, 'Unknown cart state');
        },
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      title: Text(
        'Shopping Cart',
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.bold,
          color: PaintAppColors.textPrimary,
        ),
      ),
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: Icon(Icons.arrow_back_ios, color: PaintAppColors.textPrimary),
      ),
      actions: [
        BlocBuilder<CartBloc, CartState>(
          builder: (context, state) {
            final hasItems = state is CartLoaded && state.cart.isNotEmpty;
            return PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'clear') {
                  _showClearCartDialog(context);
                } else if (value == 'save') {
                  context.read<CartBloc>().add(const SaveCartForLater());
                }
              },
              itemBuilder:
                  (context) => [
                    if (hasItems) ...[
                      const PopupMenuItem(
                        value: 'clear',
                        child: Row(
                          children: [
                            Icon(Icons.clear_all, size: 20),
                            SizedBox(width: 8),
                            Text('Clear Cart'),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'save',
                        child: Row(
                          children: [
                            Icon(Icons.bookmark_border, size: 20),
                            SizedBox(width: 8),
                            Text('Save for Later'),
                          ],
                        ),
                      ),
                    ],
                  ],
              child: Icon(Icons.more_vert, color: PaintAppColors.textPrimary),
            );
          },
        ),
      ],
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text('Loading your cart...'),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: PaintAppColors.backgroundSecondary,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.shopping_cart_outlined,
                size: 60,
                color: Colors.grey[400],
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Your cart is empty',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: PaintAppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Add some paint products to get started',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: PaintAppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: PaintAppColors.primaryBlue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              icon: const Icon(Icons.palette),
              label: const Text('Browse Products'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String errorMessage) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: PaintAppColors.error),
            const SizedBox(height: 16),
            Text(
              'Something went wrong',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: PaintAppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              errorMessage,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: PaintAppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                context.read<CartBloc>().add(const RefreshCart());
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: PaintAppColors.primaryBlue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              icon: const Icon(Icons.refresh),
              label: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCartContent(
    BuildContext context,
    cart, {
    String? appliedDiscountCode,
    double discountAmount = 0.0,
    bool isLoading = false,
  }) {
    return Column(
      children: [
        // Cart items list
        Expanded(
          child: RefreshIndicator(
            onRefresh: () async {
              context.read<CartBloc>().add(const RefreshCart());
            },
            child: ListView.builder(
              padding: const EdgeInsets.only(top: 8),
              itemCount: cart.items.length,
              itemBuilder: (context, index) {
                final cartItem = cart.items[index];
                return CartItemWidget(
                  cartItem: cartItem,
                  isLoading: isLoading,
                  onQuantityChanged: (newQuantity) {
                    context.read<CartBloc>().add(
                      UpdateCartItemQuantity(
                        cartItemId: cartItem.id,
                        newQuantity: newQuantity,
                      ),
                    );
                  },
                  onRemove: () {
                    _showRemoveItemDialog(
                      context,
                      cartItem.id,
                      cartItem.product.name,
                    );
                  },
                );
              },
            ),
          ),
        ),

        // Cart summary
        CartSummaryWidget(
          cart: cart,
          appliedDiscountCode: appliedDiscountCode,
          discountAmount: discountAmount,
          isLoading: isLoading,
          onCheckout: () => _handleCheckout(context),
          onApplyDiscount: () => _handleApplyDiscount(context),
          onRemoveDiscount: () {
            context.read<CartBloc>().add(const RemoveDiscount());
          },
        ),
      ],
    );
  }

  void _showClearCartDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (dialogContext) => AlertDialog(
            title: const Text('Clear Cart'),
            content: const Text(
              'Are you sure you want to remove all items from your cart?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(dialogContext);
                  context.read<CartBloc>().add(const ClearCart());
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: PaintAppColors.error,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Clear'),
              ),
            ],
          ),
    );
  }

  void _showRemoveItemDialog(
    BuildContext context,
    String itemId,
    String productName,
  ) {
    showDialog(
      context: context,
      builder:
          (dialogContext) => AlertDialog(
            title: const Text('Remove Item'),
            content: Text('Remove "$productName" from your cart?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(dialogContext);
                  context.read<CartBloc>().add(
                    RemoveFromCart(cartItemId: itemId),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: PaintAppColors.error,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Remove'),
              ),
            ],
          ),
    );
  }

  void _handleApplyDiscount(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (dialogContext) => AlertDialog(
            title: const Text('Apply Discount Code'),
            content: TextField(
              controller: _discountController,
              decoration: const InputDecoration(
                hintText: 'Enter discount code',
                border: OutlineInputBorder(),
              ),
              textCapitalization: TextCapitalization.characters,
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  final code = _discountController.text.trim();
                  if (code.isNotEmpty) {
                    Navigator.pop(dialogContext);
                    context.read<CartBloc>().add(
                      ApplyDiscountCode(discountCode: code),
                    );
                    _discountController.clear();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: PaintAppColors.primaryBlue,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Apply'),
              ),
            ],
          ),
    );
  }

  void _handleCheckout(BuildContext context) {
    // TODO: Navigate to checkout screen
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Checkout functionality will be implemented next'),
        backgroundColor: PaintAppColors.info,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}
