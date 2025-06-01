import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../bloc/image_processing_bloc.dart';
import '../bloc/image_processing_event.dart';
import '../bloc/image_processing_state.dart';
import '../widgets/image_preview_widget.dart';
import '../widgets/upload_button_widget.dart';

class ImageUploadScreen extends StatelessWidget {
  const ImageUploadScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Paint Color Swap'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: BlocProvider(
        create: (context) => ImageProcessingBloc(),
        child: const ImageUploadView(),
      ),
    );
  }
}

class ImageUploadView extends StatelessWidget {
  const ImageUploadView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ImageProcessingBloc, ImageProcessingState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header section với upload button
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey[300]!,
                    style: BorderStyle.solid,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.cloud_upload_outlined,
                      size: 48,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      onPressed: () => _showUploadOptions(context),
                      icon: const Icon(Icons.upload),
                      label: const Text('Tải ảnh phòng khách lên'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Image preview section
              Expanded(
                flex: 3,
                child: _buildImagePreviewSection(context, state),
              ),

              const SizedBox(height: 24),

              // Upload buttons section
              _buildUploadButtonsSection(context, state),

              const SizedBox(height: 16),

              // Demo images section
              _buildDemoImagesSection(context),

              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  Widget _buildImagePreviewSection(
    BuildContext context,
    ImageProcessingState state,
  ) {
    if (state is ImageProcessingLoading) {
      return Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 16),
              Text(
                state.message ?? 'Processing...',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      );
    }

    if (state is ImageUploadedState ||
        state is RegionSelectedState ||
        state is ColorAppliedState) {
      return ImagePreviewWidget(
        processedImage:
            state is ImageUploadedState
                ? state.processedImage
                : state is RegionSelectedState
                ? state.processedImage
                : (state as ColorAppliedState).processedImage,
      );
    }

    if (state is ImageProcessingError) {
      return Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.red[300]!),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 64, color: Colors.red[400]),
              const SizedBox(height: 16),
              Text(
                'Error',
                style: Theme.of(
                  context,
                ).textTheme.headlineSmall?.copyWith(color: Colors.red[600]),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  state.errorMessage,
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Default empty state
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!, style: BorderStyle.solid),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.image_outlined, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'No Image Selected',
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(color: Colors.grey[600]),
            ),
            const SizedBox(height: 8),
            Text(
              'Upload a photo to get started',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.grey[500]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUploadButtonsSection(
    BuildContext context,
    ImageProcessingState state,
  ) {
    final isLoading = state is ImageProcessingLoading;

    return Row(
      children: [
        Expanded(
          child: UploadButtonWidget(
            icon: Icons.camera_alt,
            label: 'Camera',
            onPressed:
                isLoading
                    ? null
                    : () => _pickImage(context, ImageSource.camera),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: UploadButtonWidget(
            icon: Icons.photo_library,
            label: 'Gallery',
            onPressed:
                isLoading
                    ? null
                    : () => _pickImage(context, ImageSource.gallery),
          ),
        ),
      ],
    );
  }

  Widget _buildDemoImagesSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Or try with demo images:',
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 80,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 3, // Placeholder for demo images
            itemBuilder: (context, index) {
              return Container(
                margin: const EdgeInsets.only(right: 12),
                child: GestureDetector(
                  onTap: () => _loadDemoImage(context, index),
                  child: Container(
                    width: 80,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.home, color: Colors.grey[600], size: 32),
                        const SizedBox(height: 4),
                        Text(
                          'Demo ${index + 1}',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Future<void> _pickImage(BuildContext context, ImageSource source) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: source,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (image != null) {
        final File imageFile = File(image.path);
        if (context.mounted) {
          context.read<ImageProcessingBloc>().add(
            UploadImageEvent(imageFile: imageFile),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to pick image: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _loadDemoImage(BuildContext context, int index) {
    context.read<ImageProcessingBloc>().add(
      LoadDemoImageEvent(demoImagePath: 'demo_$index'),
    );
  }

  void _showUploadOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Chọn nguồn ảnh',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        _pickImage(context, ImageSource.camera);
                      },
                      icon: const Icon(Icons.camera_alt),
                      label: const Text('Camera'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        _pickImage(context, ImageSource.gallery);
                      },
                      icon: const Icon(Icons.photo_library),
                      label: const Text('Thư viện'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
