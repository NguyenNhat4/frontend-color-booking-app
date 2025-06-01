import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/product_bloc.dart';
import '../../bloc/product_event.dart';
import '../../bloc/product_state.dart';
import '../../models/product.dart';
import '../../models/color.dart';
import '../widgets/color_palette_widget.dart';
import '../widgets/product_image_carousel.dart';

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
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Added ${product.name} to cart'),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
                icon: const Icon(Icons.shopping_cart),
                label: const Text('Add to Cart'),
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.white,
              ),
            );
          }

          return const SizedBox();
        },
      ),
    );
  }
}
