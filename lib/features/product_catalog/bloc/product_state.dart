import 'package:equatable/equatable.dart';
import '../models/product.dart';
import '../models/brand.dart';

abstract class ProductState extends Equatable {
  const ProductState();

  @override
  List<Object?> get props => [];
}

class ProductInitial extends ProductState {
  const ProductInitial();
}

class ProductLoading extends ProductState {
  const ProductLoading();
}

class ProductsLoaded extends ProductState {
  final List<Product> products;
  final bool hasReachedMax;
  final bool isLoadingMore;
  final String? currentSearchQuery;
  final int? currentBrandFilter;
  final PaintType? currentPaintTypeFilter;
  final PaintFinish? currentFinishFilter;

  const ProductsLoaded({
    required this.products,
    this.hasReachedMax = false,
    this.isLoadingMore = false,
    this.currentSearchQuery,
    this.currentBrandFilter,
    this.currentPaintTypeFilter,
    this.currentFinishFilter,
  });

  @override
  List<Object?> get props => [
    products,
    hasReachedMax,
    isLoadingMore,
    currentSearchQuery,
    currentBrandFilter,
    currentPaintTypeFilter,
    currentFinishFilter,
  ];

  ProductsLoaded copyWith({
    List<Product>? products,
    bool? hasReachedMax,
    bool? isLoadingMore,
    String? currentSearchQuery,
    int? currentBrandFilter,
    PaintType? currentPaintTypeFilter,
    PaintFinish? currentFinishFilter,
  }) {
    return ProductsLoaded(
      products: products ?? this.products,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      currentSearchQuery: currentSearchQuery ?? this.currentSearchQuery,
      currentBrandFilter: currentBrandFilter ?? this.currentBrandFilter,
      currentPaintTypeFilter:
          currentPaintTypeFilter ?? this.currentPaintTypeFilter,
      currentFinishFilter: currentFinishFilter ?? this.currentFinishFilter,
    );
  }
}

class ProductDetailLoaded extends ProductState {
  final Product product;
  final List<Product> relatedProducts;
  final bool isLoadingRelated;

  const ProductDetailLoaded({
    required this.product,
    this.relatedProducts = const [],
    this.isLoadingRelated = false,
  });

  @override
  List<Object> get props => [product, relatedProducts, isLoadingRelated];

  ProductDetailLoaded copyWith({
    Product? product,
    List<Product>? relatedProducts,
    bool? isLoadingRelated,
  }) {
    return ProductDetailLoaded(
      product: product ?? this.product,
      relatedProducts: relatedProducts ?? this.relatedProducts,
      isLoadingRelated: isLoadingRelated ?? this.isLoadingRelated,
    );
  }
}

class FeaturedProductsLoaded extends ProductState {
  final List<Product> featuredProducts;

  const FeaturedProductsLoaded({required this.featuredProducts});

  @override
  List<Object> get props => [featuredProducts];
}

class ProductError extends ProductState {
  final String message;

  const ProductError({required this.message});

  @override
  List<Object> get props => [message];
}
