import 'package:flutter/material.dart';

class ColorPaletteWidget extends StatefulWidget {
  final Function(Color, String) onColorSelected;
  final Color? selectedColor;

  const ColorPaletteWidget({
    super.key,
    required this.onColorSelected,
    this.selectedColor,
  });

  @override
  State<ColorPaletteWidget> createState() => _ColorPaletteWidgetState();
}

class _ColorPaletteWidgetState extends State<ColorPaletteWidget> {
  // Màu sắc dựa trên UI design
  final List<Map<String, dynamic>> paintColors = [
    {'color': const Color(0xFFFFFFFF), 'name': 'Trắng'},
    {'color': const Color(0xFF87CEEB), 'name': 'Xanh Nhạt'},
    {'color': const Color(0xFFFFF8DC), 'name': 'Kem'},
    {'color': const Color(0xFFFFE4B5), 'name': 'Moccasin'},
    {'color': const Color(0xFFFFA500), 'name': 'Cam'},
    {'color': const Color(0xFF90EE90), 'name': 'Xanh Lá Nhạt'},
    {'color': const Color(0xFF708090), 'name': 'Xám Đá'},
    {'color': const Color(0xFF2F4F4F), 'name': 'Xám Đậm'},
    {'color': const Color(0xFF8B4513), 'name': 'Nâu'},
    {'color': const Color(0xFFFF6347), 'name': 'Đỏ Cà Chua'},
    {'color': const Color(0xFF800080), 'name': 'Tím'},
    {'color': const Color(0xFF4169E1), 'name': 'Xanh Hoàng Gia'},
    {'color': const Color(0xFF1E90FF), 'name': 'Xanh Dương'},
    {'color': const Color(0xFF000080), 'name': 'Xanh Navy'},
    {'color': const Color(0xFF2F4F4F), 'name': 'Xám Tối'},
    {'color': const Color(0xFF696969), 'name': 'Xám'},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Chọn màu sơn:',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 8,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 1,
            ),
            itemCount: paintColors.length,
            itemBuilder: (context, index) {
              final colorData = paintColors[index];
              final color = colorData['color'] as Color;
              final name = colorData['name'] as String;
              final isSelected = widget.selectedColor == color;

              return GestureDetector(
                onTap: () => widget.onColorSelected(color, name),
                child: Container(
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isSelected ? Colors.blue : Colors.grey[300]!,
                      width: isSelected ? 3 : 1,
                    ),
                    boxShadow:
                        isSelected
                            ? [
                              BoxShadow(
                                color: Colors.blue.withValues(alpha: 0.3),
                                spreadRadius: 2,
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ]
                            : null,
                  ),
                  child:
                      color == const Color(0xFFFFFFFF)
                          ? Icon(
                            Icons.circle_outlined,
                            color: Colors.grey[400],
                            size: 16,
                          )
                          : null,
                ),
              );
            },
          ),
          if (widget.selectedColor != null) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: widget.selectedColor,
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      paintColors.firstWhere(
                        (c) => c['color'] == widget.selectedColor,
                        orElse: () => {'name': 'Màu đã chọn'},
                      )['name'],
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
