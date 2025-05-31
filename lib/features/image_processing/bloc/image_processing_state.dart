import 'package:equatable/equatable.dart';
import '../models/processed_image.dart';

abstract class ImageProcessingState extends Equatable {
  const ImageProcessingState();

  @override
  List<Object?> get props => [];
}

class ImageProcessingInitial extends ImageProcessingState {
  const ImageProcessingInitial();
}

class ImageProcessingLoading extends ImageProcessingState {
  final String? message;

  const ImageProcessingLoading({this.message});

  @override
  List<Object?> get props => [message];
}

class ImageUploadedState extends ImageProcessingState {
  final ProcessedImage processedImage;

  const ImageUploadedState({required this.processedImage});

  @override
  List<Object> get props => [processedImage];
}

class RegionSelectedState extends ImageProcessingState {
  final ProcessedImage processedImage;

  const RegionSelectedState({required this.processedImage});

  @override
  List<Object> get props => [processedImage];
}

class ColorAppliedState extends ImageProcessingState {
  final ProcessedImage processedImage;

  const ColorAppliedState({required this.processedImage});

  @override
  List<Object> get props => [processedImage];
}

class ImageProcessingSuccess extends ImageProcessingState {
  final ProcessedImage processedImage;
  final String? message;

  const ImageProcessingSuccess({required this.processedImage, this.message});

  @override
  List<Object?> get props => [processedImage, message];
}

class ImageProcessingError extends ImageProcessingState {
  final String errorMessage;
  final ProcessedImage? processedImage;

  const ImageProcessingError({required this.errorMessage, this.processedImage});

  @override
  List<Object?> get props => [errorMessage, processedImage];
}
