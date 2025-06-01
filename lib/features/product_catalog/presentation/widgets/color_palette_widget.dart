import 'package:flutter/material.dart';
import '../../models/color.dart';

class ColorPaletteWidget extends StatelessWidget {
  final List<ProductColor> colors;
  final double size;
  final double spacing;
  final bool showMoreIndicator;
  final Function(ProductColor)? onColorTap;

  const ColorPaletteWidget({
    super.key,
    required this.colors,
    this.size = 24.0,
    this.spacing = 8.0,
    this.showMoreIndicator = false,
    this.onColorTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ...colors.map(
          (color) => Padding(
            padding: EdgeInsets.only(right: spacing),
            child: GestureDetector(
              onTap: () => onColorTap?.call(color),
              child: ColorSwatch(color: color, size: size),
            ),
          ),
        ),
        if (showMoreIndicator)
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              shape: BoxShape.circle,
              border: Border.all(color: Colors.grey[400]!, width: 1),
            ),
            child: Icon(
              Icons.more_horiz,
              size: size * 0.6,
              color: Colors.grey[600],
            ),
          ),
      ],
    );
  }
}

class ColorSwatch extends StatelessWidget {
  final ProductColor color;
  final double size;
  final bool isSelected;

  const ColorSwatch({
    super.key,
    required this.color,
    this.size = 24.0,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    final colorValue = _parseHexColor(color.hexCode);

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: colorValue,
        shape: BoxShape.circle,
        border: Border.all(
          color:
              isSelected ? Theme.of(context).primaryColor : Colors.grey[300]!,
          width: isSelected ? 2 : 1,
        ),
        boxShadow:
            isSelected
                ? [
                  BoxShadow(
                    color: Theme.of(context).primaryColor.withOpacity(0.3),
                    blurRadius: 4,
                    spreadRadius: 1,
                  ),
                ]
                : null,
      ),
      child:
          color.hexCode.toLowerCase() == '#ffffff'
              ? Icon(Icons.circle, size: size * 0.3, color: Colors.grey[400])
              : null,
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
