import 'package:flutter/material.dart';
import '../../models/product.dart';
import '../../models/brand.dart';

class FilterBarWidget extends StatelessWidget {
  final PaintType? selectedPaintType;
  final Brand? selectedBrand;
  final String? selectedUsage;
  final List<Brand> brands;
  final Function(PaintType?) onPaintTypeChanged;
  final Function(Brand?) onBrandChanged;
  final Function(String?) onUsageChanged;

  const FilterBarWidget({
    super.key,
    this.selectedPaintType,
    this.selectedBrand,
    this.selectedUsage,
    required this.brands,
    required this.onPaintTypeChanged,
    required this.onBrandChanged,
    required this.onUsageChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.grey[50],
      child: Row(
        children: [
          // Loại sơn (Paint Type)
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(4),
                color: Colors.white,
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<PaintType>(
                  value: selectedPaintType,
                  hint: const Text('Tất cả', style: TextStyle(fontSize: 14)),
                  onChanged: onPaintTypeChanged,
                  items: [
                    const DropdownMenuItem<PaintType>(
                      value: null,
                      child: Text('Tất cả'),
                    ),
                    ...PaintType.values.map(
                      (type) => DropdownMenuItem<PaintType>(
                        value: type,
                        child: Text(_getPaintTypeVietnameseName(type)),
                      ),
                    ),
                  ],
                  isExpanded: true,
                  icon: const Icon(Icons.keyboard_arrow_down),
                  style: const TextStyle(color: Colors.black87, fontSize: 14),
                  dropdownColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                ),
              ),
            ),
          ),

          const SizedBox(width: 12),

          // Thương hiệu (Brand)
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(4),
                color: Colors.white,
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<Brand>(
                  value: selectedBrand,
                  hint: const Text('Tất cả', style: TextStyle(fontSize: 14)),
                  onChanged: onBrandChanged,
                  items: [
                    const DropdownMenuItem<Brand>(
                      value: null,
                      child: Text('Tất cả'),
                    ),
                    ...brands.map(
                      (brand) => DropdownMenuItem<Brand>(
                        value: brand,
                        child: Text(brand.name),
                      ),
                    ),
                  ],
                  isExpanded: true,
                  icon: const Icon(Icons.keyboard_arrow_down),
                  style: const TextStyle(color: Colors.black87, fontSize: 14),
                  dropdownColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                ),
              ),
            ),
          ),

          const SizedBox(width: 12),

          // Công dụng (Usage)
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(4),
                color: Colors.white,
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: selectedUsage,
                  hint: const Text('Tất cả', style: TextStyle(fontSize: 14)),
                  onChanged: onUsageChanged,
                  items: const [
                    DropdownMenuItem<String>(
                      value: null,
                      child: Text('Tất cả'),
                    ),
                    DropdownMenuItem<String>(
                      value: 'interior',
                      child: Text('Trong nhà'),
                    ),
                    DropdownMenuItem<String>(
                      value: 'exterior',
                      child: Text('Ngoài trời'),
                    ),
                    DropdownMenuItem<String>(
                      value: 'decorative',
                      child: Text('Trang trí'),
                    ),
                  ],
                  isExpanded: true,
                  icon: const Icon(Icons.keyboard_arrow_down),
                  style: const TextStyle(color: Colors.black87, fontSize: 14),
                  dropdownColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getPaintTypeVietnameseName(PaintType type) {
    switch (type) {
      case PaintType.interior:
        return 'Sơn nội thất';
      case PaintType.exterior:
        return 'Sơn ngoại thất';
      case PaintType.specialty:
        return 'Sơn đặc biệt';
    }
  }
}
