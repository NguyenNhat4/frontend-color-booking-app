import 'package:equatable/equatable.dart';

class Brand extends Equatable {
  final int id;
  final String name;
  final String? description;
  final String? logoUrl;
  final bool isActive;

  const Brand({
    required this.id,
    required this.name,
    this.description,
    this.logoUrl,
    this.isActive = true,
  });

  factory Brand.fromJson(Map<String, dynamic> json) => Brand(
    id: json['id'] as int,
    name: json['name'] as String,
    description: json['description'] as String?,
    logoUrl: json['logoUrl'] as String?,
    isActive: json['isActive'] as bool? ?? true,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'logoUrl': logoUrl,
    'isActive': isActive,
  };

  @override
  List<Object?> get props => [id, name, description, logoUrl, isActive];

  Brand copyWith({
    int? id,
    String? name,
    String? description,
    String? logoUrl,
    bool? isActive,
  }) {
    return Brand(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      logoUrl: logoUrl ?? this.logoUrl,
      isActive: isActive ?? this.isActive,
    );
  }
}
