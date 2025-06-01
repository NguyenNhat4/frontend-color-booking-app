import 'package:equatable/equatable.dart';
import '../models/product.dart';

abstract class ProductEvent extends Equatable {
  const ProductEvent();

  @override
  List<Object?> get props => [];
}

class LoadProducts extends ProductEvent {
  final String? searchQuery;
  final int? brandId;
  final PaintType? paintType;
  final PaintFinish? finish;
  final bool isRefresh;

  const LoadProducts({
    this.searchQuery,
    this.brandId,
    this.paintType,
    this.finish,
    this.isRefresh = false,
  });

  @override
  List<Object?> get props => [
    searchQuery,
    brandId,
    paintType,
    finish,
    isRefresh,
  ];
}

class LoadMoreProducts extends ProductEvent {
  const LoadMoreProducts();
}

class SearchProducts extends ProductEvent {
  final String query;

  const SearchProducts(this.query);

  @override
  List<Object> get props => [query];
}

class FilterProducts extends ProductEvent {
  final int? brandId;
  final PaintType? paintType;
  final PaintFinish? finish;

  const FilterProducts({this.brandId, this.paintType, this.finish});

  @override
  List<Object?> get props => [brandId, paintType, finish];
}

class LoadProductDetail extends ProductEvent {
  final int productId;

  const LoadProductDetail(this.productId);

  @override
  List<Object> get props => [productId];
}

class LoadFeaturedProducts extends ProductEvent {
  const LoadFeaturedProducts();
}

class LoadRelatedProducts extends ProductEvent {
  final int productId;

  const LoadRelatedProducts(this.productId);

  @override
  List<Object> get props => [productId];
}

class ClearFilters extends ProductEvent {
  const ClearFilters();
}
