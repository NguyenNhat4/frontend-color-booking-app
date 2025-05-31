import 'dart:io';
import 'dart:math';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as img;

import 'image_processing_event.dart';
import 'image_processing_state.dart';
import '../models/processed_image.dart';

class ImageProcessingBloc
    extends Bloc<ImageProcessingEvent, ImageProcessingState> {
  ImageProcessingBloc() : super(const ImageProcessingInitial()) {
    on<UploadImageEvent>(_onUploadImage);
    on<SelectRegionEvent>(_onSelectRegion);
    on<ApplyColorEvent>(_onApplyColor);
    on<ResetImageProcessingEvent>(_onResetImageProcessing);
    on<SaveProcessedImageEvent>(_onSaveProcessedImage);
    on<LoadDemoImageEvent>(_onLoadDemoImage);
  }

  ProcessedImage? _currentProcessedImage;

  Future<void> _onUploadImage(
    UploadImageEvent event,
    Emitter<ImageProcessingState> emit,
  ) async {
    try {
      emit(const ImageProcessingLoading(message: 'Uploading image...'));

      // Validate image file
      if (!await event.imageFile.exists()) {
        emit(
          const ImageProcessingError(errorMessage: 'Image file does not exist'),
        );
        return;
      }

      // Create a new ProcessedImage instance
      final processedImage = ProcessedImage(
        id: _generateId(),
        originalImage: event.imageFile,
        createdAt: DateTime.now(),
        status: ProcessingStatus.uploading,
      );

      _currentProcessedImage = processedImage;

      // Update status to completed after successful upload
      final updatedImage = processedImage.copyWith(
        status: ProcessingStatus.completed,
      );

      _currentProcessedImage = updatedImage;
      emit(ImageUploadedState(processedImage: updatedImage));
    } catch (e) {
      emit(
        ImageProcessingError(
          errorMessage: 'Failed to upload image: ${e.toString()}',
          processedImage: _currentProcessedImage,
        ),
      );
    }
  }

  Future<void> _onSelectRegion(
    SelectRegionEvent event,
    Emitter<ImageProcessingState> emit,
  ) async {
    try {
      if (_currentProcessedImage == null) {
        emit(const ImageProcessingError(errorMessage: 'No image uploaded'));
        return;
      }

      emit(const ImageProcessingLoading(message: 'Selecting region...'));

      final updatedImage = _currentProcessedImage!.copyWith(
        selectedRegion: event.regionPoints,
      );

      _currentProcessedImage = updatedImage;
      emit(RegionSelectedState(processedImage: updatedImage));
    } catch (e) {
      emit(
        ImageProcessingError(
          errorMessage: 'Failed to select region: ${e.toString()}',
          processedImage: _currentProcessedImage,
        ),
      );
    }
  }

  Future<void> _onApplyColor(
    ApplyColorEvent event,
    Emitter<ImageProcessingState> emit,
  ) async {
    try {
      if (_currentProcessedImage == null) {
        emit(const ImageProcessingError(errorMessage: 'No image uploaded'));
        return;
      }

      if (_currentProcessedImage!.selectedRegion == null ||
          _currentProcessedImage!.selectedRegion!.isEmpty) {
        emit(
          ImageProcessingError(
            errorMessage: 'Please select a region first',
            processedImage: _currentProcessedImage,
          ),
        );
        return;
      }

      emit(const ImageProcessingLoading(message: 'Applying color...'));

      // Process the image with the selected color
      final processedImageFile = await _processImageWithColor(
        _currentProcessedImage!.originalImage,
        event.colorHex,
        _currentProcessedImage!.selectedRegion!,
      );

      final updatedImage = _currentProcessedImage!.copyWith(
        processedImage: processedImageFile,
        selectedColor: event.colorHex,
        status: ProcessingStatus.completed,
      );

      _currentProcessedImage = updatedImage;
      emit(ColorAppliedState(processedImage: updatedImage));
    } catch (e) {
      emit(
        ImageProcessingError(
          errorMessage: 'Failed to apply color: ${e.toString()}',
          processedImage: _currentProcessedImage,
        ),
      );
    }
  }

  Future<void> _onResetImageProcessing(
    ResetImageProcessingEvent event,
    Emitter<ImageProcessingState> emit,
  ) async {
    _currentProcessedImage = null;
    emit(const ImageProcessingInitial());
  }

  Future<void> _onSaveProcessedImage(
    SaveProcessedImageEvent event,
    Emitter<ImageProcessingState> emit,
  ) async {
    try {
      if (_currentProcessedImage?.processedImage == null) {
        emit(
          const ImageProcessingError(
            errorMessage: 'No processed image to save',
          ),
        );
        return;
      }

      emit(const ImageProcessingLoading(message: 'Saving image...'));

      // For now, just emit success. In a real app, you'd save to gallery
      emit(
        ImageProcessingSuccess(
          processedImage: _currentProcessedImage!,
          message: 'Image saved successfully',
        ),
      );
    } catch (e) {
      emit(
        ImageProcessingError(
          errorMessage: 'Failed to save image: ${e.toString()}',
          processedImage: _currentProcessedImage,
        ),
      );
    }
  }

  Future<void> _onLoadDemoImage(
    LoadDemoImageEvent event,
    Emitter<ImageProcessingState> emit,
  ) async {
    try {
      emit(const ImageProcessingLoading(message: 'Loading demo image...'));

      // Create a simple colored demo image
      final demoImage = await _createDemoImage(event.demoImagePath);

      // Create a new ProcessedImage instance with the demo image
      final processedImage = ProcessedImage(
        id: _generateId(),
        originalImage: demoImage,
        createdAt: DateTime.now(),
        status: ProcessingStatus.completed,
      );

      _currentProcessedImage = processedImage;
      emit(ImageUploadedState(processedImage: processedImage));
    } catch (e) {
      emit(
        ImageProcessingError(
          errorMessage: 'Failed to load demo image: ${e.toString()}',
        ),
      );
    }
  }

  Future<File> _createDemoImage(String demoImagePath) async {
    try {
      // Create a simple demo image with different colors based on the demo type
      final width = 400;
      final height = 300;

      img.Color backgroundColor;
      img.Color wallColor;

      switch (demoImagePath) {
        case 'demo_0':
          backgroundColor = img.ColorRgb8(240, 240, 240); // Light gray
          wallColor = img.ColorRgb8(255, 255, 255); // White
          break;
        case 'demo_1':
          backgroundColor = img.ColorRgb8(200, 220, 240); // Light blue
          wallColor = img.ColorRgb8(245, 245, 220); // Beige
          break;
        case 'demo_2':
          backgroundColor = img.ColorRgb8(220, 240, 220); // Light green
          wallColor = img.ColorRgb8(255, 248, 220); // Cornsilk
          break;
        default:
          backgroundColor = img.ColorRgb8(240, 240, 240);
          wallColor = img.ColorRgb8(255, 255, 255);
      }

      // Create a simple room-like image
      final image = img.Image(width: width, height: height);

      // Fill background
      img.fill(image, color: backgroundColor);

      // Draw a simple wall (rectangle)
      img.fillRect(
        image,
        x1: 50,
        y1: 50,
        x2: width - 50,
        y2: height - 100,
        color: wallColor,
      );

      // Add a simple border to make it look more like a wall
      img.drawRect(
        image,
        x1: 50,
        y1: 50,
        x2: width - 50,
        y2: height - 100,
        color: img.ColorRgb8(100, 100, 100),
      );

      // Save the demo image to a temporary file
      final tempDir = await getTemporaryDirectory();
      final demoFile = File(
        '${tempDir.path}/demo_${DateTime.now().millisecondsSinceEpoch}.png',
      );
      await demoFile.writeAsBytes(img.encodePng(image));

      return demoFile;
    } catch (e) {
      throw Exception('Failed to create demo image: $e');
    }
  }

  Future<File> _processImageWithColor(
    File originalImage,
    String colorHex,
    List<RegionPoint> region,
  ) async {
    try {
      // Read the original image
      final bytes = await originalImage.readAsBytes();
      final image = img.decodeImage(bytes);

      if (image == null) {
        throw Exception('Failed to decode image');
      }

      // Parse the hex color
      final color = _hexToColor(colorHex);

      // For now, we'll apply a simple color overlay to the entire image
      // In a real implementation, you'd apply color only to the selected region
      final processedImage = img.copyResize(
        image,
        width: image.width,
        height: image.height,
      );

      // Apply a simple color tint (this is a basic implementation)
      for (int y = 0; y < processedImage.height; y++) {
        for (int x = 0; x < processedImage.width; x++) {
          final pixel = processedImage.getPixel(x, y);
          final blended = _blendColors(pixel, color, 0.3); // 30% opacity
          processedImage.setPixel(x, y, blended);
        }
      }

      // Save the processed image to a temporary file
      final tempDir = await getTemporaryDirectory();
      final processedFile = File(
        '${tempDir.path}/processed_${DateTime.now().millisecondsSinceEpoch}.png',
      );
      await processedFile.writeAsBytes(img.encodePng(processedImage));

      return processedFile;
    } catch (e) {
      throw Exception('Failed to process image: $e');
    }
  }

  img.Color _hexToColor(String hex) {
    final hexCode = hex.replaceAll('#', '');
    final r = int.parse(hexCode.substring(0, 2), radix: 16);
    final g = int.parse(hexCode.substring(2, 4), radix: 16);
    final b = int.parse(hexCode.substring(4, 6), radix: 16);
    return img.ColorRgb8(r, g, b);
  }

  img.Color _blendColors(img.Color base, img.Color overlay, double opacity) {
    final baseR = base.r.toInt();
    final baseG = base.g.toInt();
    final baseB = base.b.toInt();

    final overlayR = overlay.r.toInt();
    final overlayG = overlay.g.toInt();
    final overlayB = overlay.b.toInt();

    final blendedR = ((1 - opacity) * baseR + opacity * overlayR).round();
    final blendedG = ((1 - opacity) * baseG + opacity * overlayG).round();
    final blendedB = ((1 - opacity) * baseB + opacity * overlayB).round();

    return img.ColorRgb8(blendedR, blendedG, blendedB);
  }

  String _generateId() {
    return DateTime.now().millisecondsSinceEpoch.toString() +
        Random().nextInt(1000).toString();
  }
}
