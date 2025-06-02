import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/cart_bloc.dart';
import '../../bloc/cart_state.dart';
import '../../../../core/theme/paint_app_colors.dart';
import '../screens/shopping_cart_screen.dart';

/// A reusable cart badge widget that displays the number of items in the cart
/// and navigates to the shopping cart screen when tapped.
class CartBadgeWidget extends StatelessWidget {
  final bool useInverseColors;

  const CartBadgeWidget({super.key, this.useInverseColors = false});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartBloc, CartState>(
      builder: (context, state) {
        // Get cart item count from the bloc
        final cartItemCount =
            context.read<CartBloc>().getCurrentCartItemCount();

        return GestureDetector(
          onTap: () => _navigateToCart(context),
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color:
                  useInverseColors
                      ? PaintAppColors.surface.withAlpha(51) // ~0.2 opacity
                      : PaintAppColors.backgroundSecondary,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Icon(
                  Icons.shopping_cart_outlined,
                  color:
                      useInverseColors
                          ? PaintAppColors.textInverse
                          : PaintAppColors.textPrimary,
                  size: 20,
                ),
                if (cartItemCount > 0)
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: PaintAppColors.paintRed,
                        shape: BoxShape.circle,
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 14,
                        minHeight: 14,
                      ),
                      child: Center(
                        child: Text(
                          cartItemCount.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 8,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _navigateToCart(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ShoppingCartScreen.withBloc()),
    );
  }
}
