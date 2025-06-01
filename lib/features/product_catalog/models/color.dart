import 'package:equatable/equatable.dart';

class ProductColor extends Equatable {
  final int id;
  final String name;
  final String hexCode;
  final String? description;
  final bool isAvailable;

  const ProductColor({
    required this.id,
    required this.name,
    required this.hexCode,
    this.description,
    this.isAvailable = true,
  });

  factory ProductColor.fromJson(Map<String, dynamic> json) => ProductColor(
    id: json['id'] as int,
    name: json['name'] as String,
    hexCode: json['hexCode'] as String,
    description: json['description'] as String?,
    isAvailable: json['isAvailable'] as bool? ?? true,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'hexCode': hexCode,
    'description': description,
    'isAvailable': isAvailable,
  };

  @override
  List<Object?> get props => [id, name, hexCode, description, isAvailable];

  ProductColor copyWith({
    int? id,
    String? name,
    String? hexCode,
    String? description,
    bool? isAvailable,
  }) {
    return ProductColor(
      id: id ?? this.id,
      name: name ?? this.name,
      hexCode: hexCode ?? this.hexCode,
      description: description ?? this.description,
      isAvailable: isAvailable ?? this.isAvailable,
    );
  }
}
