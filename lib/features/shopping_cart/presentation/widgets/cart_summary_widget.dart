import 'package:flutter/material.dart';
import '../../models/cart.dart';
import '../../../../core/theme/paint_app_colors.dart';

class CartSummaryWidget extends StatelessWidget {
  final Cart cart;
  final String? appliedDiscountCode;
  final double discountAmount;
  final VoidCallback? onCheckout;
  final VoidCallback? onApplyDiscount;
  final VoidCallback? onRemoveDiscount;
  final bool isLoading;

  const CartSummaryWidget({
    super.key,
    required this.cart,
    this.appliedDiscountCode,
    this.discountAmount = 0.0,
    this.onCheckout,
    this.onApplyDiscount,
    this.onRemoveDiscount,
    this.isLoading = false,
  });

  double get finalTotal => cart.total - discountAmount;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(20), // ~0.08 opacity
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            _buildHeader(context),

            const SizedBox(height: 16),

            // Order summary
            _buildOrderSummary(context),

            const SizedBox(height: 16),

            // Discount section
            if (appliedDiscountCode != null) ...[
              _buildAppliedDiscount(context),
              const SizedBox(height: 16),
            ] else ...[
              _buildDiscountInput(context),
              const SizedBox(height: 16),
            ],

            // Divider
            Container(height: 1, color: Colors.grey[200]),

            const SizedBox(height: 16),

            // Total
            _buildTotal(context),

            const SizedBox(height: 20),

            // Checkout button
            _buildCheckoutButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        Icon(Icons.receipt_long, color: PaintAppColors.primaryBlue, size: 24),
        const SizedBox(width: 8),
        Text(
          'Order Summary',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: PaintAppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildOrderSummary(BuildContext context) {
    return Column(
      children: [
        _buildSummaryRow(
          context,
          'Subtotal (${cart.totalItemCount} items)',
          '\$${cart.subtotal.toStringAsFixed(2)}',
        ),
        const SizedBox(height: 8),
        _buildSummaryRow(context, 'Tax', '\$${cart.tax.toStringAsFixed(2)}'),
        if (discountAmount > 0) ...[
          const SizedBox(height: 8),
          _buildSummaryRow(
            context,
            'Discount ($appliedDiscountCode)',
            '-\$${discountAmount.toStringAsFixed(2)}',
            isDiscount: true,
          ),
        ],
      ],
    );
  }

  Widget _buildSummaryRow(
    BuildContext context,
    String label,
    String value, {
    bool isDiscount = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: PaintAppColors.textSecondary),
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color:
                isDiscount
                    ? PaintAppColors.success
                    : PaintAppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildAppliedDiscount(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: PaintAppColors.success.withAlpha(25), // ~0.1 opacity
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: PaintAppColors.success.withAlpha(76),
        ), // ~0.3 opacity
      ),
      child: Row(
        children: [
          Icon(Icons.check_circle, color: PaintAppColors.success, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Discount code "$appliedDiscountCode" applied',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: PaintAppColors.success,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          if (onRemoveDiscount != null)
            IconButton(
              onPressed: onRemoveDiscount,
              icon: Icon(Icons.close, color: PaintAppColors.success, size: 16),
              constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
            ),
        ],
      ),
    );
  }

  Widget _buildDiscountInput(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Enter discount code',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: PaintAppColors.primaryBlue),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 12,
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        ElevatedButton(
          onPressed: onApplyDiscount,
          style: ElevatedButton.styleFrom(
            backgroundColor: PaintAppColors.primaryBlue,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Text('Apply'),
        ),
      ],
    );
  }

  Widget _buildTotal(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Total',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: PaintAppColors.textPrimary,
          ),
        ),
        Text(
          '\$${finalTotal.toStringAsFixed(2)}',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: PaintAppColors.primaryBlue,
          ),
        ),
      ],
    );
  }

  Widget _buildCheckoutButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isLoading || cart.isEmpty ? null : onCheckout,
        style: ElevatedButton.styleFrom(
          backgroundColor: PaintAppColors.primaryBlue,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
        ),
        child:
            isLoading
                ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
                : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.shopping_bag, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      'Proceed to Checkout',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
      ),
    );
  }
}
