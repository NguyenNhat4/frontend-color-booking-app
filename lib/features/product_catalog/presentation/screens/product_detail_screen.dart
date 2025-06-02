import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/product_bloc.dart';
import '../../bloc/product_event.dart';
import '../../bloc/product_state.dart';
import '../../models/product.dart';
import '../../models/color.dart';
import '../widgets/color_palette_widget.dart';
import '../widgets/product_image_carousel.dart';
import '../../../../core/theme/paint_app_colors.dart';
import '../../../../features/shopping_cart/bloc/cart_bloc.dart';
import '../../../../features/shopping_cart/bloc/cart_event.dart';
import '../../../../features/shopping_cart/presentation/screens/shopping_cart_screen.dart';

class ProductDetailScreen extends StatefulWidget {
  final int productId;

  const ProductDetailScreen({super.key, required this.productId});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();

  // Static method to create screen with Bloc provider
  static Widget withBloc({required int productId}) {
    return BlocProvider(
      create: (context) => ProductBloc(),
      child: ProductDetailScreen(productId: productId),
    );
  }
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  ProductColor? selectedColor;

  @override
  void initState() {
    super.initState();
    context.read<ProductBloc>().add(LoadProductDetail(widget.productId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<ProductBloc, ProductState>(
        builder: (context, state) {
          if (state is ProductLoading) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          if (state is ProductError) {
            return Scaffold(
              appBar: AppBar(title: const Text('Product Details')),
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Product not found',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back),
                      label: const Text('Go Back'),
                    ),
                  ],
                ),
              ),
            );
          }

          if (state is ProductDetailLoaded) {
            final product = state.product;
            selectedColor ??=
                product.availableColors.isNotEmpty
                    ? product.availableColors.first
                    : null;

            return Scaffold(
              body: CustomScrollView(
                slivers: [
                  // App Bar with Image
                  SliverAppBar(
                    expandedHeight: 300,
                    pinned: true,
                    backgroundColor: Theme.of(context).primaryColor,
                    foregroundColor: Colors.white,
                    flexibleSpace: FlexibleSpaceBar(
                      background: ProductImageCarousel(
                        imageUrls: product.imageUrls,
                      ),
                    ),
                  ),

                  // Product Information
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Brand and Featured Badge
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  product.brand.name,
                                  style: Theme.of(
                                    context,
                                  ).textTheme.titleMedium?.copyWith(
                                    color: Theme.of(context).primaryColor,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              if (product.isFeatured)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.orange,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    'Featured',
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodySmall?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                            ],
                          ),

                          const SizedBox(height: 8),

                          // Product Name
                          Text(
                            product.name,
                            style: Theme.of(context).textTheme.headlineSmall
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),

                          const SizedBox(height: 16),

                          // Price and Rating
                          Row(
                            children: [
                              Text(
                                '\$${product.basePrice.toStringAsFixed(2)}',
                                style: Theme.of(
                                  context,
                                ).textTheme.headlineMedium?.copyWith(
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Spacer(),
                              if (product.rating != null) ...[
                                Icon(Icons.star, color: Colors.amber, size: 20),
                                const SizedBox(width: 4),
                                Text(
                                  '${product.rating!.toStringAsFixed(1)} (${product.reviewCount})',
                                  style: Theme.of(context).textTheme.titleMedium
                                      ?.copyWith(fontWeight: FontWeight.w600),
                                ),
                              ],
                            ],
                          ),

                          const SizedBox(height: 24),

                          // Color Selection
                          if (product.availableColors.isNotEmpty) ...[
                            Text(
                              'Available Colors',
                              style: Theme.of(context).textTheme.titleLarge
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 16),
                            ColorPaletteWidget(
                              colors: product.availableColors,
                              size: 32,
                              spacing: 8,
                              onColorTap: (color) {
                                setState(() {
                                  selectedColor = color;
                                });
                              },
                            ),
                            const SizedBox(height: 24),
                          ],

                          // Description
                          Text(
                            'Description',
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            product.description,
                            style: Theme.of(
                              context,
                            ).textTheme.bodyLarge?.copyWith(height: 1.6),
                          ),

                          const SizedBox(
                            height: 100,
                          ), // Space for floating button
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              // Add to Cart Button
              floatingActionButton: FloatingActionButton.extended(
                onPressed: () {
                  if (selectedColor == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please select a color first'),
                        backgroundColor: Colors.orange,
                      ),
                    );
                    return;
                  }

                  // Show quantity selector dialog
                  _showAddToCartDialog(context, product, selectedColor!);
                },
                icon: const Icon(Icons.shopping_cart),
                label: const Text('Add to Cart'),
                backgroundColor: PaintAppColors.primaryBlue,
                foregroundColor: Colors.white,
              ),
            );
          }

          return const SizedBox();
        },
      ),
    );
  }

  // Show dialog to select quantity and add to cart
  void _showAddToCartDialog(
    BuildContext context,
    Product product,
    ProductColor selectedColor,
  ) {
    int quantity = 1;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Add to Cart'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: _parseHexColor(selectedColor.hexCode),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              selectedColor.name,
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Text('Select Quantity:'),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove),
                        onPressed:
                            quantity > 1
                                ? () {
                                  setState(() {
                                    quantity--;
                                  });
                                }
                                : null,
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey[300]!),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          quantity.toString(),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () {
                          setState(() {
                            quantity++;
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    _addToCart(context, product, selectedColor, quantity);
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: PaintAppColors.primaryBlue,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Add to Cart'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // Add to cart functionality
  void _addToCart(
    BuildContext context,
    Product product,
    ProductColor selectedColor,
    int quantity,
  ) {
    // Check if we have a CartBloc in the widget tree, otherwise create one
    CartBloc? cartBloc;
    try {
      cartBloc = BlocProvider.of<CartBloc>(context);
    } catch (_) {
      // If no CartBloc is found, we create a new one for this operation
      cartBloc = CartBloc();
    }

    // Add the product to cart
    cartBloc.add(
      AddToCart(
        product: product,
        selectedColor: selectedColor,
        quantity: quantity,
      ),
    );

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${product.name} added to cart'),
        backgroundColor: PaintAppColors.success,
        behavior: SnackBarBehavior.floating,
        action: SnackBarAction(
          label: 'VIEW CART',
          textColor: Colors.white,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ShoppingCartScreen.withBloc(),
              ),
            );
          },
        ),
      ),
    );
  }

  // Helper method to parse hex color
  Color _parseHexColor(String hexColor) {
    try {
      final hex = hexColor.replaceAll('#', '');
      return Color(int.parse('FF$hex', radix: 16));
    } catch (e) {
      return Colors.grey;
    }
  }
}
