import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/image_processing_bloc.dart';
import '../bloc/image_processing_event.dart';
import '../bloc/image_processing_state.dart';
import '../widgets/region_selection_widget.dart';
import '../widgets/color_picker_widget.dart';
import 'image_upload_screen.dart';

class ImageProcessingScreen extends StatelessWidget {
  const ImageProcessingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Paint Color Swap'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<ImageProcessingBloc>().add(
                const ResetImageProcessingEvent(),
              );
            },
          ),
        ],
      ),
      body: BlocProvider(
        create: (context) => ImageProcessingBloc(),
        child: const ImageProcessingView(),
      ),
    );
  }
}

class ImageProcessingView extends StatelessWidget {
  const ImageProcessingView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ImageProcessingBloc, ImageProcessingState>(
      builder: (context, state) {
        return _buildCurrentStep(context, state);
      },
    );
  }

  Widget _buildCurrentStep(BuildContext context, ImageProcessingState state) {
    if (state is ImageProcessingInitial) {
      return const ImageUploadView();
    }

    if (state is ImageProcessingLoading) {
      return _buildLoadingView(context, state);
    }

    if (state is ImageUploadedState) {
      return _buildRegionSelectionStep(context, state);
    }

    if (state is RegionSelectedState) {
      return _buildColorSelectionStep(context, state);
    }

    if (state is ColorAppliedState || state is ImageProcessingSuccess) {
      return _buildResultStep(context, state);
    }

    if (state is ImageProcessingError) {
      return _buildErrorView(context, state);
    }

    return const ImageUploadView();
  }

  Widget _buildLoadingView(BuildContext context, ImageProcessingLoading state) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 16),
          Text(
            state.message ?? 'Processing...',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ],
      ),
    );
  }

  Widget _buildRegionSelectionStep(
    BuildContext context,
    ImageUploadedState state,
  ) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Step indicator
          _buildStepIndicator(context, 1),
          const SizedBox(height: 16),

          // Instructions
          Text(
            'Select Region to Paint',
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Tap or draw on the image to select the area you want to paint',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),

          // Region selection widget
          Expanded(
            child: RegionSelectionWidget(
              imageFile: state.processedImage.originalImage,
              existingRegion: state.processedImage.selectedRegion,
              onRegionSelected: (points) {
                context.read<ImageProcessingBloc>().add(
                  SelectRegionEvent(regionPoints: points),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildColorSelectionStep(
    BuildContext context,
    RegionSelectedState state,
  ) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Step indicator
          _buildStepIndicator(context, 2),
          const SizedBox(height: 16),

          // Instructions
          Text(
            'Choose Paint Color',
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Select a color to apply to the selected region',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),

          // Image preview (smaller)
          Container(
            height: 200,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(12),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.file(
                state.processedImage.originalImage,
                fit: BoxFit.contain,
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Color picker
          Expanded(
            child: ColorPickerWidget(
              selectedColor: state.processedImage.selectedColor,
              onColorSelected: (colorHex) {
                context.read<ImageProcessingBloc>().add(
                  ApplyColorEvent(colorHex: colorHex),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultStep(BuildContext context, ImageProcessingState state) {
    final processedImage =
        state is ColorAppliedState
            ? state.processedImage
            : (state as ImageProcessingSuccess).processedImage;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Step indicator
          _buildStepIndicator(context, 3),
          const SizedBox(height: 16),

          // Instructions
          Text(
            'Result Preview',
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Your paint color has been applied! Compare the before and after.',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),

          // Before/After comparison
          Expanded(
            child: Row(
              children: [
                // Before
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        'Before',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 8),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey[300]!),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.file(
                              processedImage.originalImage,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 16),

                // After
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        'After',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 8),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey[300]!),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child:
                                processedImage.processedImage != null
                                    ? Image.file(
                                      processedImage.processedImage!,
                                      fit: BoxFit.contain,
                                    )
                                    : Container(
                                      color: Colors.grey[200],
                                      child: const Center(
                                        child: Text('No processed image'),
                                      ),
                                    ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Action buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    context.read<ImageProcessingBloc>().add(
                      const ResetImageProcessingEvent(),
                    );
                  },
                  icon: const Icon(Icons.refresh),
                  label: const Text('Start Over'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    context.read<ImageProcessingBloc>().add(
                      const SaveProcessedImageEvent(),
                    );
                  },
                  icon: const Icon(Icons.save),
                  label: const Text('Save'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildErrorView(BuildContext context, ImageProcessingError state) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.red[400]),
            const SizedBox(height: 16),
            Text(
              'Something went wrong',
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(color: Colors.red[600]),
            ),
            const SizedBox(height: 8),
            Text(
              state.errorMessage,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                context.read<ImageProcessingBloc>().add(
                  const ResetImageProcessingEvent(),
                );
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepIndicator(BuildContext context, int currentStep) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildStepCircle(context, 1, currentStep >= 1, 'Upload'),
        _buildStepLine(currentStep >= 2),
        _buildStepCircle(context, 2, currentStep >= 2, 'Select'),
        _buildStepLine(currentStep >= 3),
        _buildStepCircle(context, 3, currentStep >= 3, 'Result'),
      ],
    );
  }

  Widget _buildStepCircle(
    BuildContext context,
    int step,
    bool isActive,
    String label,
  ) {
    return Column(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: isActive ? Colors.blue : Colors.grey[300],
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              step.toString(),
              style: TextStyle(
                color: isActive ? Colors.white : Colors.grey[600],
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: isActive ? Colors.blue : Colors.grey[600],
            fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  Widget _buildStepLine(bool isActive) {
    return Container(
      width: 40,
      height: 2,
      color: isActive ? Colors.blue : Colors.grey[300],
      margin: const EdgeInsets.only(bottom: 20),
    );
  }
}
