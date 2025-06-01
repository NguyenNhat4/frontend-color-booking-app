import 'package:flutter/material.dart';
import '../../models/product.dart';
import '../../models/color.dart';

class VietnameseProductCard extends StatefulWidget {
  final Product product;
  final ProductColor selectedColor;
  final VoidCallback? onTap;
  final Function(ProductColor)? onColorChanged;

  const VietnameseProductCard({
    super.key,
    required this.product,
    required this.selectedColor,
    this.onTap,
    this.onColorChanged,
  });

  @override
  State<VietnameseProductCard> createState() => _VietnameseProductCardState();
}

class _VietnameseProductCardState extends State<VietnameseProductCard> {
  int quantity = 1;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Large Color Block
          GestureDetector(
            onTap: widget.onTap,
            child: Container(
              height: 160,
              width: double.infinity,
              decoration: BoxDecoration(
                color: _parseHexColor(widget.selectedColor.hexCode),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(8),
                ),
              ),
              child: Center(
                child: Text(
                  widget.selectedColor.name,
                  style: TextStyle(
                    color: _getContrastColor(widget.selectedColor.hexCode),
                    fontSize: 24,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
            ),
          ),

          // Product Information
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Vietnamese Product Name
                Text(
                  _getVietnameseProductName(widget.product),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),

                const SizedBox(height: 4),

                // English Product Name
                Text(
                  widget.product.name,
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),

                const SizedBox(height: 8),

                // Product Description
                Text(
                  _getVietnameseDescription(widget.product),
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[600],
                    height: 1.3,
                  ),
                ),

                const SizedBox(height: 12),

                // Price
                Text(
                  _formatVietnamesePrice(widget.product.basePrice),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),

                const SizedBox(height: 16),

                // Quantity and Add to Cart
                Row(
                  children: [
                    // Quantity Control
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[300]!),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed:
                                quantity > 1
                                    ? () {
                                      setState(() {
                                        quantity--;
                                      });
                                    }
                                    : null,
                            icon: const Icon(Icons.remove, size: 16),
                            iconSize: 20,
                            constraints: const BoxConstraints(
                              minWidth: 32,
                              minHeight: 32,
                            ),
                          ),
                          Container(
                            width: 40,
                            height: 32,
                            alignment: Alignment.center,
                            child: Text(
                              quantity.toString(),
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              setState(() {
                                quantity++;
                              });
                            },
                            icon: const Icon(Icons.add, size: 16),
                            iconSize: 20,
                            constraints: const BoxConstraints(
                              minWidth: 32,
                              minHeight: 32,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(width: 16),

                    // Add to Cart Button
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          _addToCart();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF4A90E2),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        child: const Text(
                          'Thêm vào giỏ',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
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

  String _getVietnameseProductName(Product product) {
    // Map English product names to Vietnamese
    const nameMap = {
      'Advance Interior Paint': 'Sơn nội thất Ocean Blue',
      'WeatherShield Exterior': 'Sơn ngoại thất Sunny Yellow',
      'Diamond Matt Emulsion': 'Sơn chống thấm Grey Sky',
      'Odour-less Premium': 'Sơn nội thất Pink Blossom',
      'Ultra Gloss Finish': 'Sơn bóng cao cấp',
      'EasyClean Interior': 'Sơn nội thất dễ lau chùi',
    };
    return nameMap[product.name] ?? product.name;
  }

  String _getVietnameseDescription(Product product) {
    // Map product descriptions to Vietnamese
    const descriptionMap = {
      'Advance Interior Paint':
          'Thương hiệu: Thường hiệu A\nCông dụng: Nội thất',
      'WeatherShield Exterior':
          'Thương hiệu: Thường hiệu B\nCông dụng: Ngoại thất',
      'Diamond Matt Emulsion':
          'Thương hiệu: Thường hiệu C\nCông dụng: Ngoại thất',
      'Odour-less Premium': 'Thương hiệu: Thường hiệu A\nCông dụng: Nội thất',
      'Ultra Gloss Finish': 'Thương hiệu: Thường hiệu D\nCông dụng: Đặc biệt',
      'EasyClean Interior': 'Thương hiệu: Thường hiệu E\nCông dụng: Nội thất',
    };
    return descriptionMap[product.name] ??
        'Thương hiệu: ${product.brand.name}\nCông dụng: Nội thất';
  }

  String _formatVietnamesePrice(double price) {
    // Convert USD to Vietnamese dong (approximate rate: 1 USD = 24,000 VND)
    final vndPrice = (price * 24000).toInt();
    final formattedPrice = vndPrice.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]}.',
    );
    return '$formattedPrice đ';
  }

  void _addToCart() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Đã thêm $quantity ${widget.product.name} (${widget.selectedColor.name}) vào giỏ hàng',
        ),
        duration: const Duration(seconds: 2),
        backgroundColor: const Color(0xFF4A90E2),
      ),
    );
  }
}
