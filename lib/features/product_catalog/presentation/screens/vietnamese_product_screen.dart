import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/product_bloc.dart';
import '../../bloc/product_event.dart';
import '../../bloc/product_state.dart';
import '../../models/product.dart';
import '../../models/brand.dart';
import '../../models/color.dart';
import '../../data/product_repository.dart';
import '../widgets/filter_bar_widget.dart';
import '../widgets/color_palette_bar.dart';
import '../widgets/vietnamese_product_card.dart';

class VietnameseProductScreen extends StatefulWidget {
  const VietnameseProductScreen({super.key});

  @override
  State<VietnameseProductScreen> createState() =>
      _VietnameseProductScreenState();

  // Static method to create screen with Bloc provider
  static Widget withBloc() {
    return BlocProvider(
      create: (context) => ProductBloc()..add(const LoadProducts()),
      child: const VietnameseProductScreen(),
    );
  }
}

class _VietnameseProductScreenState extends State<VietnameseProductScreen> {
  PaintType? selectedPaintType;
  Brand? selectedBrand;
  String? selectedUsage;
  ProductColor? selectedColor;

  final ProductRepository _repository = ProductRepository();
  List<Brand> availableBrands = [];
  List<ProductColor> availableColors = [];
  Map<int, ProductColor> productSelectedColors = {};

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  void _loadInitialData() async {
    availableBrands = await _repository.getBrands();
    availableColors = await _repository.getColors();
    setState(() {
      selectedColor = availableColors.isNotEmpty ? availableColors.first : null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          'Sản Phẩm Sơn',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 1,
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Filter Bar
          FilterBarWidget(
            selectedPaintType: selectedPaintType,
            selectedBrand: selectedBrand,
            selectedUsage: selectedUsage,
            brands: availableBrands,
            onPaintTypeChanged: (paintType) {
              setState(() {
                selectedPaintType = paintType;
              });
              _applyFilters();
            },
            onBrandChanged: (brand) {
              setState(() {
                selectedBrand = brand;
              });
              _applyFilters();
            },
            onUsageChanged: (usage) {
              setState(() {
                selectedUsage = usage;
              });
              _applyFilters();
            },
          ),

          // Color Palette Bar
          ColorPaletteBar(
            colors: availableColors,
            selectedColor: selectedColor,
            onColorTap: (color) {
              setState(() {
                selectedColor = color;
              });
            },
          ),

          // Product List
          Expanded(
            child: BlocBuilder<ProductBloc, ProductState>(
              builder: (context, state) {
                if (state is ProductLoading) {
                  return const Center(
                    child: CircularProgressIndicator(color: Color(0xFF4A90E2)),
                  );
                }

                if (state is ProductError) {
                  return Center(
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
                          'Có lỗi xảy ra',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          state.message,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: Colors.grey[600]),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton.icon(
                          onPressed: () {
                            context.read<ProductBloc>().add(
                              const LoadProducts(),
                            );
                          },
                          icon: const Icon(Icons.refresh),
                          label: const Text('Thử lại'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF4A90E2),
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                if (state is ProductsLoaded) {
                  if (state.products.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.search_off,
                            size: 64,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Không tìm thấy sản phẩm',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Thử điều chỉnh bộ lọc của bạn',
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(color: Colors.grey[600]),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton.icon(
                            onPressed: () {
                              setState(() {
                                selectedPaintType = null;
                                selectedBrand = null;
                                selectedUsage = null;
                              });
                              context.read<ProductBloc>().add(
                                const ClearFilters(),
                              );
                            },
                            icon: const Icon(Icons.clear_all),
                            label: const Text('Xóa bộ lọc'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF4A90E2),
                              foregroundColor: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: state.products.length,
                    itemBuilder: (context, index) {
                      final product = state.products[index];

                      // Get the selected color for this product or default to the first available color
                      final productSelectedColor =
                          productSelectedColors[product.id] ??
                          selectedColor ??
                          (product.availableColors.isNotEmpty
                              ? product.availableColors.first
                              : availableColors.first);

                      return VietnameseProductCard(
                        product: product,
                        selectedColor: productSelectedColor,
                        onColorChanged: (color) {
                          setState(() {
                            productSelectedColors[product.id] = color;
                          });
                        },
                        onTap: () {
                          // Navigate to product detail or show color picker
                          _showColorPicker(product);
                        },
                      );
                    },
                  );
                }

                return const SizedBox();
              },
            ),
          ),
        ],
      ),
    );
  }

  void _applyFilters() {
    context.read<ProductBloc>().add(
      FilterProducts(
        paintType: selectedPaintType,
        brandId: selectedBrand?.id,
        finish: null, // Not used in Vietnamese UI
      ),
    );
  }

  void _showColorPicker(Product product) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Chọn màu cho ${product.name}'),
            content: SizedBox(
              width: 300,
              height: 200,
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: product.availableColors.length,
                itemBuilder: (context, index) {
                  final color = product.availableColors[index];
                  final isSelected =
                      productSelectedColors[product.id]?.id == color.id;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        productSelectedColors[product.id] = color;
                      });
                      Navigator.pop(context);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: _parseHexColor(color.hexCode),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color:
                              isSelected ? Colors.black87 : Colors.grey[300]!,
                          width: isSelected ? 3 : 1,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          color.name,
                          style: TextStyle(
                            color: _getContrastColor(color.hexCode),
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Đóng'),
              ),
            ],
          ),
    );
  }

  Color _parseHexColor(String hexColor) {
    try {
      final hex = hexColor.replaceAll('#', '');
      return Color(int.parse('FF$hex', radix: 16));
    } catch (e) {
      return Colors.grey;
    }
  }

  Color _getContrastColor(String hexColor) {
    final color = _parseHexColor(hexColor);
    final luminance = color.computeLuminance();
    return luminance > 0.5 ? Colors.black : Colors.white;
  }
}
