import 'package:flutter/material.dart';
import '../../models/cart_item.dart';
import '../../../../core/theme/paint_app_colors.dart';

class CartItemWidget extends StatelessWidget {
  final CartItem cartItem;
  final VoidCallback? onRemove;
  final Function(int)? onQuantityChanged;
  final bool isLoading;

  const CartItemWidget({
    super.key,
    required this.cartItem,
    this.onRemove,
    this.onQuantityChanged,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            // Main content
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product image with color overlay
                  _buildProductImage(),

                  const SizedBox(width: 16),

                  // Product details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildProductHeader(context),
                        const SizedBox(height: 8),
                        _buildProductDetails(context),
                        const SizedBox(height: 12),
                        _buildPriceAndQuantity(context),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Loading overlay
            if (isLoading)
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Center(child: CircularProgressIndicator()),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductImage() {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: LinearGradient(
          colors: [
            _parseHexColor(cartItem.selectedColor.hexCode).withOpacity(0.8),
            _parseHexColor(cartItem.selectedColor.hexCode),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: _parseHexColor(
              cartItem.selectedColor.hexCode,
            ).withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Product image (if available)
          if (cartItem.product.imageUrls.isNotEmpty)
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                cartItem.product.imageUrls.first,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
                errorBuilder:
                    (context, error, stackTrace) => _buildColorSwatch(),
              ),
            )
          else
            _buildColorSwatch(),

          // Color indicator
          Positioned(
            bottom: 4,
            right: 4,
            child: Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: _parseHexColor(cartItem.selectedColor.hexCode),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildColorSwatch() {
    return Container(
      decoration: BoxDecoration(
        color: _parseHexColor(cartItem.selectedColor.hexCode),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Center(
        child: Icon(Icons.palette, color: Colors.white, size: 32),
      ),
    );
  }

  Widget _buildProductHeader(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            cartItem.product.name,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: PaintAppColors.textPrimary,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        if (onRemove != null)
          IconButton(
            onPressed: isLoading ? null : onRemove,
            icon: const Icon(Icons.close),
            iconSize: 20,
            color: Colors.grey[600],
            constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
          ),
      ],
    );
  }

  Widget _buildProductDetails(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Brand
        Text(
          cartItem.product.brand.name,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: PaintAppColors.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),

        const SizedBox(height: 4),

        // Color name
        Row(
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: _parseHexColor(cartItem.selectedColor.hexCode),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.grey[300]!, width: 1),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              cartItem.selectedColor.name,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: PaintAppColors.textSecondary,
              ),
            ),
          ],
        ),

        // Notes (if any)
        if (cartItem.notes != null && cartItem.notes!.isNotEmpty) ...[
          const SizedBox(height: 4),
          Text(
            'Note: ${cartItem.notes}',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.grey[500],
              fontStyle: FontStyle.italic,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ],
    );
  }

  Widget _buildPriceAndQuantity(BuildContext context) {
    return Row(
      children: [
        // Price
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '\$${cartItem.priceAtAddition.toStringAsFixed(2)}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: PaintAppColors.textSecondary,
                  decoration:
                      cartItem.priceAtAddition != cartItem.product.basePrice
                          ? TextDecoration.lineThrough
                          : null,
                ),
              ),
              Text(
                '\$${cartItem.totalPrice.toStringAsFixed(2)}',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: PaintAppColors.primaryBlue,
                ),
              ),
            ],
          ),
        ),

        // Quantity controls
        _buildQuantityControls(context),
      ],
    );
  }

  Widget _buildQuantityControls(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildQuantityButton(
            icon: Icons.remove,
            onPressed:
                cartItem.quantity > 1 && !isLoading
                    ? () => onQuantityChanged?.call(cartItem.quantity - 1)
                    : null,
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              cartItem.quantity.toString(),
              style: Theme.of(
                context,
              ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          _buildQuantityButton(
            icon: Icons.add,
            onPressed:
                !isLoading
                    ? () => onQuantityChanged?.call(cartItem.quantity + 1)
                    : null,
          ),
        ],
      ),
    );
  }

  Widget _buildQuantityButton({
    required IconData icon,
    required VoidCallback? onPressed,
  }) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(6),
      child: Container(
        padding: const EdgeInsets.all(8),
        child: Icon(
          icon,
          size: 16,
          color:
              onPressed != null ? PaintAppColors.primaryBlue : Colors.grey[400],
        ),
      ),
    );
  }

  /// Convert hex color string to Color object
  Color _parseHexColor(String hexColor) {
    try {
      final hex = hexColor.replaceAll('#', '');
      return Color(int.parse('FF$hex', radix: 16));
    } catch (e) {
      return Colors.grey;
    }
  }
}
