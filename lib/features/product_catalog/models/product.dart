import 'package:equatable/equatable.dart';
import 'brand.dart';
import 'color.dart';

enum PaintType { interior, exterior, specialty }

enum PaintFinish { matte, satin, semiGloss, gloss }

class Product extends Equatable {
  final int id;
  final String name;
  final String description;
  final Brand brand;
  final List<ProductColor> availableColors;
  final List<String> imageUrls;
  final double basePrice;
  final PaintType paintType;
  final PaintFinish finish;
  final double coverage; // Square meters per liter
  final String size; // e.g., "1L", "5L", "20L"
  final bool isAvailable;
  final bool isFeatured;
  final double? rating;
  final int reviewCount;

  const Product({
    required this.id,
    required this.name,
    required this.description,
    required this.brand,
    required this.availableColors,
    required this.imageUrls,
    required this.basePrice,
    required this.paintType,
    required this.finish,
    required this.coverage,
    required this.size,
    this.isAvailable = true,
    this.isFeatured = false,
    this.rating,
    this.reviewCount = 0,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
    id: json['id'] as int,
    name: json['name'] as String,
    description: json['description'] as String,
    brand: Brand.fromJson(json['brand'] as Map<String, dynamic>),
    availableColors:
        (json['availableColors'] as List<dynamic>)
            .map(
              (color) => ProductColor.fromJson(color as Map<String, dynamic>),
            )
            .toList(),
    imageUrls: (json['imageUrls'] as List<dynamic>).cast<String>(),
    basePrice: (json['basePrice'] as num).toDouble(),
    paintType: PaintType.values.byName(json['paintType'] as String),
    finish: PaintFinish.values.byName(json['finish'] as String),
    coverage: (json['coverage'] as num).toDouble(),
    size: json['size'] as String,
    isAvailable: json['isAvailable'] as bool? ?? true,
    isFeatured: json['isFeatured'] as bool? ?? false,
    rating: (json['rating'] as num?)?.toDouble(),
    reviewCount: json['reviewCount'] as int? ?? 0,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'brand': brand.toJson(),
    'availableColors': availableColors.map((color) => color.toJson()).toList(),
    'imageUrls': imageUrls,
    'basePrice': basePrice,
    'paintType': paintType.name,
    'finish': finish.name,
    'coverage': coverage,
    'size': size,
    'isAvailable': isAvailable,
    'isFeatured': isFeatured,
    'rating': rating,
    'reviewCount': reviewCount,
  };

  @override
  List<Object?> get props => [
    id,
    name,
    description,
    brand,
    availableColors,
    imageUrls,
    basePrice,
    paintType,
    finish,
    coverage,
    size,
    isAvailable,
    isFeatured,
    rating,
    reviewCount,
  ];

  Product copyWith({
    int? id,
    String? name,
    String? description,
    Brand? brand,
    List<ProductColor>? availableColors,
    List<String>? imageUrls,
    double? basePrice,
    PaintType? paintType,
    PaintFinish? finish,
    double? coverage,
    String? size,
    bool? isAvailable,
    bool? isFeatured,
    double? rating,
    int? reviewCount,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      brand: brand ?? this.brand,
      availableColors: availableColors ?? this.availableColors,
      imageUrls: imageUrls ?? this.imageUrls,
      basePrice: basePrice ?? this.basePrice,
      paintType: paintType ?? this.paintType,
      finish: finish ?? this.finish,
      coverage: coverage ?? this.coverage,
      size: size ?? this.size,
      isAvailable: isAvailable ?? this.isAvailable,
      isFeatured: isFeatured ?? this.isFeatured,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
    );
  }
}
