import 'dart:io';
import 'package:flutter/material.dart';
import '../models/processed_image.dart';

class ImagePreviewWidget extends StatefulWidget {
  final ProcessedImage processedImage;

  const ImagePreviewWidget({super.key, required this.processedImage});

  @override
  State<ImagePreviewWidget> createState() => _ImagePreviewWidgetState();
}

class _ImagePreviewWidgetState extends State<ImagePreviewWidget> {
  bool _showProcessed = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          // Image display area
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
              ),
              child: _buildImageDisplay(),
            ),
          ),

          // Controls area
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(12),
              ),
            ),
            child: _buildControls(),
          ),
        ],
      ),
    );
  }

  Widget _buildImageDisplay() {
    final imageToShow =
        _showProcessed && widget.processedImage.processedImage != null
            ? widget.processedImage.processedImage!
            : widget.processedImage.originalImage;

    return Container(
      width: double.infinity,
      child: Image.file(
        imageToShow,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            color: Colors.grey[200],
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 48, color: Colors.grey[600]),
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
    );
  }

  Widget _buildControls() {
    return Column(
      children: [
        // Image info
        Row(
          children: [
            Icon(Icons.info_outline, size: 16, color: Colors.grey[600]),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                _showProcessed && widget.processedImage.processedImage != null
                    ? 'Processed Image'
                    : 'Original Image',
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w500),
              ),
            ),
            if (widget.processedImage.selectedColor != null)
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: _hexToColor(widget.processedImage.selectedColor!),
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: Colors.grey[400]!),
                ),
              ),
          ],
        ),

        // Toggle button (only show if processed image exists)
        if (widget.processedImage.processedImage != null) ...[
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: SegmentedButton<bool>(
              segments: const [
                ButtonSegment<bool>(
                  value: false,
                  label: Text('Original'),
                  icon: Icon(Icons.image_outlined),
                ),
                ButtonSegment<bool>(
                  value: true,
                  label: Text('Processed'),
                  icon: Icon(Icons.palette_outlined),
                ),
              ],
              selected: {_showProcessed},
              onSelectionChanged: (Set<bool> newSelection) {
                setState(() {
                  _showProcessed = newSelection.first;
                });
              },
            ),
          ),
        ],
      ],
    );
  }

  Color _hexToColor(String hex) {
    final hexCode = hex.replaceAll('#', '');
    return Color(int.parse('FF$hexCode', radix: 16));
  }
}
