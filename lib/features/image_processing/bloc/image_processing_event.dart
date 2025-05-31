import 'dart:io';
import 'package:equatable/equatable.dart';
import '../models/processed_image.dart';

abstract class ImageProcessingEvent extends Equatable {
  const ImageProcessingEvent();

  @override
  List<Object?> get props => [];
}

class UploadImageEvent extends ImageProcessingEvent {
  final File imageFile;

  const UploadImageEvent({required this.imageFile});

  @override
  List<Object> get props => [imageFile];
}

class SelectRegionEvent extends ImageProcessingEvent {
  final List<RegionPoint> regionPoints;

  const SelectRegionEvent({required this.regionPoints});

  @override
  List<Object> get props => [regionPoints];
}

class ApplyColorEvent extends ImageProcessingEvent {
  final String colorHex;

  const ApplyColorEvent({required this.colorHex});

  @override
  List<Object> get props => [colorHex];
}

class ResetImageProcessingEvent extends ImageProcessingEvent {
  const ResetImageProcessingEvent();
}

class SaveProcessedImageEvent extends ImageProcessingEvent {
  const SaveProcessedImageEvent();
}

class LoadDemoImageEvent extends ImageProcessingEvent {
  final String demoImagePath;

  const LoadDemoImageEvent({required this.demoImagePath});

  @override
  List<Object> get props => [demoImagePath];
}
