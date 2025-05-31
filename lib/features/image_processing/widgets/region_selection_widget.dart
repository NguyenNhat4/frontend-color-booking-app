import 'dart:io';
import 'package:flutter/material.dart';
import '../models/processed_image.dart';

class RegionSelectionWidget extends StatefulWidget {
  final File imageFile;
  final List<RegionPoint>? existingRegion;
  final Function(List<RegionPoint>) onRegionSelected;

  const RegionSelectionWidget({
    super.key,
    required this.imageFile,
    this.existingRegion,
    required this.onRegionSelected,
  });

  @override
  State<RegionSelectionWidget> createState() => _RegionSelectionWidgetState();
}

class _RegionSelectionWidgetState extends State<RegionSelectionWidget> {
  List<RegionPoint> _selectedPoints = [];
  bool _isDrawing = false;
  RegionSelectionMode _selectionMode = RegionSelectionMode.tap;

  @override
  void initState() {
    super.initState();
    if (widget.existingRegion != null) {
      _selectedPoints = List.from(widget.existingRegion!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Mode selection
        _buildModeSelector(),
        const SizedBox(height: 16),

        // Image with region selection
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(12),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: _buildInteractiveImage(),
            ),
          ),
        ),

        const SizedBox(height: 16),

        // Action buttons
        _buildActionButtons(),
      ],
    );
  }

  Widget _buildModeSelector() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildModeButton(RegionSelectionMode.tap, Icons.touch_app, 'Tap'),
          const SizedBox(width: 8),
          _buildModeButton(RegionSelectionMode.draw, Icons.brush, 'Draw'),
        ],
      ),
    );
  }

  Widget _buildModeButton(
    RegionSelectionMode mode,
    IconData icon,
    String label,
  ) {
    final isSelected = _selectionMode == mode;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectionMode = mode;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 18,
              color: isSelected ? Colors.white : Colors.grey[600],
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.grey[600],
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInteractiveImage() {
    return GestureDetector(
      onTapDown: _selectionMode == RegionSelectionMode.tap ? _handleTap : null,
      onPanStart:
          _selectionMode == RegionSelectionMode.draw ? _handlePanStart : null,
      onPanUpdate:
          _selectionMode == RegionSelectionMode.draw ? _handlePanUpdate : null,
      onPanEnd:
          _selectionMode == RegionSelectionMode.draw ? _handlePanEnd : null,
      child: Stack(
        children: [
          // Base image
          Container(
            width: double.infinity,
            height: double.infinity,
            child: Image.file(
              widget.imageFile,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.grey[200],
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 48,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Failed to load image',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // Region overlay
          if (_selectedPoints.isNotEmpty)
            CustomPaint(
              size: Size.infinite,
              painter: RegionPainter(
                points: _selectedPoints,
                selectionMode: _selectionMode,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: _selectedPoints.isEmpty ? null : _clearSelection,
            icon: const Icon(Icons.clear),
            label: const Text('Clear'),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: _selectedPoints.isEmpty ? null : _confirmSelection,
            icon: const Icon(Icons.check),
            label: const Text('Confirm'),
          ),
        ),
      ],
    );
  }

  void _handleTap(TapDownDetails details) {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final localPosition = renderBox.globalToLocal(details.globalPosition);

    setState(() {
      _selectedPoints.add(
        RegionPoint(x: localPosition.dx, y: localPosition.dy),
      );
    });
  }

  void _handlePanStart(DragStartDetails details) {
    setState(() {
      _isDrawing = true;
      _selectedPoints.clear();
    });
    _addPointFromPan(details.localPosition);
  }

  void _handlePanUpdate(DragUpdateDetails details) {
    if (_isDrawing) {
      _addPointFromPan(details.localPosition);
    }
  }

  void _handlePanEnd(DragEndDetails details) {
    setState(() {
      _isDrawing = false;
    });
  }

  void _addPointFromPan(Offset position) {
    setState(() {
      _selectedPoints.add(RegionPoint(x: position.dx, y: position.dy));
    });
  }

  void _clearSelection() {
    setState(() {
      _selectedPoints.clear();
    });
  }

  void _confirmSelection() {
    if (_selectedPoints.isNotEmpty) {
      widget.onRegionSelected(_selectedPoints);
    }
  }
}

enum RegionSelectionMode { tap, draw }

class RegionPainter extends CustomPainter {
  final List<RegionPoint> points;
  final RegionSelectionMode selectionMode;

  RegionPainter({required this.points, required this.selectionMode});

  @override
  void paint(Canvas canvas, Size size) {
    if (points.isEmpty) return;

    final paint =
        Paint()
          ..color = Colors.blue.withOpacity(0.3)
          ..style = PaintingStyle.fill;

    final strokePaint =
        Paint()
          ..color = Colors.blue
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.0;

    final pointPaint =
        Paint()
          ..color = Colors.blue
          ..style = PaintingStyle.fill;

    if (selectionMode == RegionSelectionMode.tap) {
      // Draw individual tap points
      for (final point in points) {
        canvas.drawCircle(Offset(point.x, point.y), 8.0, pointPaint);
        canvas.drawCircle(Offset(point.x, point.y), 8.0, strokePaint);
      }

      // If we have enough points, draw a polygon
      if (points.length >= 3) {
        final path = Path();
        path.moveTo(points.first.x, points.first.y);
        for (int i = 1; i < points.length; i++) {
          path.lineTo(points[i].x, points[i].y);
        }
        path.close();

        canvas.drawPath(path, paint);
        canvas.drawPath(path, strokePaint);
      }
    } else {
      // Draw continuous line for drawing mode
      if (points.length > 1) {
        final path = Path();
        path.moveTo(points.first.x, points.first.y);
        for (int i = 1; i < points.length; i++) {
          path.lineTo(points[i].x, points[i].y);
        }

        canvas.drawPath(path, strokePaint);

        // Fill the drawn area if it forms a closed shape
        if (points.length > 10) {
          path.close();
          canvas.drawPath(path, paint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
