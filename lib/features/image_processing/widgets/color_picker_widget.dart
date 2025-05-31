import 'package:flutter/material.dart';

class ColorPickerWidget extends StatefulWidget {
  final String? selectedColor;
  final Function(String) onColorSelected;

  const ColorPickerWidget({
    super.key,
    this.selectedColor,
    required this.onColorSelected,
  });

  @override
  State<ColorPickerWidget> createState() => _ColorPickerWidgetState();
}

class _ColorPickerWidgetState extends State<ColorPickerWidget> {
  String? _selectedColor;

  // Predefined paint colors (common paint colors)
  final List<ColorOption> _predefinedColors = [
    ColorOption('Classic White', '#FFFFFF'),
    ColorOption('Warm Beige', '#F5F5DC'),
    ColorOption('Light Gray', '#D3D3D3'),
    ColorOption('Soft Blue', '#87CEEB'),
    ColorOption('Sage Green', '#9CAF88'),
    ColorOption('Warm Yellow', '#F0E68C'),
    ColorOption('Coral Pink', '#FF7F7F'),
    ColorOption('Lavender', '#E6E6FA'),
    ColorOption('Mint Green', '#98FB98'),
    ColorOption('Peach', '#FFCBA4'),
    ColorOption('Sky Blue', '#87CEEB'),
    ColorOption('Rose Gold', '#E8B4B8'),
    ColorOption('Charcoal', '#36454F'),
    ColorOption('Navy Blue', '#000080'),
    ColorOption('Forest Green', '#228B22'),
    ColorOption('Burgundy', '#800020'),
    ColorOption('Cream', '#FFFDD0'),
    ColorOption('Taupe', '#483C32'),
  ];

  @override
  void initState() {
    super.initState();
    _selectedColor = widget.selectedColor;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Popular colors section
        Text(
          'Popular Paint Colors',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 12),

        Expanded(
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.2,
            ),
            itemCount: _predefinedColors.length,
            itemBuilder: (context, index) {
              final colorOption = _predefinedColors[index];
              final isSelected = _selectedColor == colorOption.hex;

              return GestureDetector(
                onTap: () => _selectColor(colorOption.hex),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected ? Colors.blue : Colors.grey[300]!,
                      width: isSelected ? 3 : 1,
                    ),
                  ),
                  child: Column(
                    children: [
                      // Color swatch
                      Expanded(
                        flex: 3,
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: _hexToColor(colorOption.hex),
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(11),
                            ),
                          ),
                          child:
                              isSelected
                                  ? const Center(
                                    child: Icon(
                                      Icons.check,
                                      color: Colors.white,
                                      size: 24,
                                    ),
                                  )
                                  : null,
                        ),
                      ),

                      // Color name
                      Expanded(
                        flex: 2,
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.grey[50],
                            borderRadius: const BorderRadius.vertical(
                              bottom: Radius.circular(11),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              colorOption.name,
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(fontWeight: FontWeight.w500),
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),

        const SizedBox(height: 16),

        // Custom color section
        Text(
          'Custom Color',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 12),

        // Custom color picker button
        GestureDetector(
          onTap: _showCustomColorPicker,
          child: Container(
            height: 60,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                // Color preview
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color:
                        _selectedColor != null &&
                                !_isPredefinedColor(_selectedColor!)
                            ? _hexToColor(_selectedColor!)
                            : Colors.grey[200],
                    borderRadius: const BorderRadius.horizontal(
                      left: Radius.circular(12),
                    ),
                  ),
                  child: const Center(
                    child: Icon(Icons.palette, color: Colors.grey),
                  ),
                ),

                // Text
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'Choose custom color',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ),

                // Arrow
                Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _selectColor(String colorHex) {
    setState(() {
      _selectedColor = colorHex;
    });
    widget.onColorSelected(colorHex);
  }

  bool _isPredefinedColor(String colorHex) {
    return _predefinedColors.any((color) => color.hex == colorHex);
  }

  void _showCustomColorPicker() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Choose Custom Color'),
          content: SizedBox(
            width: 300,
            height: 400,
            child: _buildBasicColorPicker(),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildBasicColorPicker() {
    // Basic color picker with common colors
    final List<String> basicColors = [
      '#FF0000',
      '#00FF00',
      '#0000FF',
      '#FFFF00',
      '#FF00FF',
      '#00FFFF',
      '#800000',
      '#008000',
      '#000080',
      '#808000',
      '#800080',
      '#008080',
      '#FFA500',
      '#FFC0CB',
      '#A52A2A',
      '#808080',
      '#000000',
      '#FFFFFF',
    ];

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 6,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: basicColors.length,
      itemBuilder: (context, index) {
        final color = basicColors[index];
        return GestureDetector(
          onTap: () {
            _selectColor(color);
            Navigator.of(context).pop();
          },
          child: Container(
            decoration: BoxDecoration(
              color: _hexToColor(color),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[300]!),
            ),
          ),
        );
      },
    );
  }

  Color _hexToColor(String hex) {
    final hexCode = hex.replaceAll('#', '');
    return Color(int.parse('FF$hexCode', radix: 16));
  }
}

class ColorOption {
  final String name;
  final String hex;

  ColorOption(this.name, this.hex);
}
