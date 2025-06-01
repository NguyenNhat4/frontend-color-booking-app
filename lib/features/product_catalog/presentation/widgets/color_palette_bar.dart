import 'package:flutter/material.dart';
import '../../models/color.dart';

class ColorPaletteBar extends StatelessWidget {
  final List<ProductColor> colors;
  final ProductColor? selectedColor;
  final Function(ProductColor)? onColorTap;

  const ColorPaletteBar({
    super.key,
    required this.colors,
    this.selectedColor,
    this.onColorTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: Colors.grey[50],
      child: Row(
        children: [
          Text(
            'Màu sắc',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: colors.length,
              separatorBuilder: (context, index) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final color = colors[index];
                final isSelected = selectedColor?.id == color.id;

                return GestureDetector(
                  onTap: () => onColorTap?.call(color),
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: _parseHexColor(color.hexCode),
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                        color: isSelected ? Colors.black87 : Colors.grey[300]!,
                        width: isSelected ? 2 : 1,
                      ),
                      boxShadow:
                          isSelected
                              ? [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ]
                              : null,
                    ),
                  ),
                );
              },
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
}
