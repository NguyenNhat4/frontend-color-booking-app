import 'dart:io';
import 'package:equatable/equatable.dart';

class ProcessedImage extends Equatable {
  final String id;
  final File originalImage;
  final File? processedImage;
  final String? selectedColor;
  final List<RegionPoint>? selectedRegion;
  final DateTime createdAt;
  final ProcessingStatus status;

  const ProcessedImage({
    required this.id,
    required this.originalImage,
    this.processedImage,
    this.selectedColor,
    this.selectedRegion,
    required this.createdAt,
    required this.status,
  });

  ProcessedImage copyWith({
    String? id,
    File? originalImage,
    File? processedImage,
    String? selectedColor,
    List<RegionPoint>? selectedRegion,
    DateTime? createdAt,
    ProcessingStatus? status,
  }) {
    return ProcessedImage(
      id: id ?? this.id,
      originalImage: originalImage ?? this.originalImage,
      processedImage: processedImage ?? this.processedImage,
      selectedColor: selectedColor ?? this.selectedColor,
      selectedRegion: selectedRegion ?? this.selectedRegion,
      createdAt: createdAt ?? this.createdAt,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [
    id,
    originalImage,
    processedImage,
    selectedColor,
    selectedRegion,
    createdAt,
    status,
  ];
}

class RegionPoint extends Equatable {
  final double x;
  final double y;

  const RegionPoint({required this.x, required this.y});

  @override
  List<Object> get props => [x, y];
}

enum ProcessingStatus { initial, uploading, processing, completed, error }
