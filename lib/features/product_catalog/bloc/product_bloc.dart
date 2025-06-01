import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/product_repository.dart';
import '../models/product.dart';
import 'product_event.dart';
import 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductRepository _productRepository;
  int _currentPage = 1;
  static const int _pageSize = 20;

  ProductBloc({ProductRepository? productRepository})
    : _productRepository = productRepository ?? ProductRepository(),
      super(const ProductInitial()) {
    on<LoadProducts>(_onLoadProducts);
    on<LoadMoreProducts>(_onLoadMoreProducts);
    on<SearchProducts>(_onSearchProducts);
    on<FilterProducts>(_onFilterProducts);
    on<LoadProductDetail>(_onLoadProductDetail);
    on<LoadFeaturedProducts>(_onLoadFeaturedProducts);
    on<LoadRelatedProducts>(_onLoadRelatedProducts);
    on<ClearFilters>(_onClearFilters);
  }

  Future<void> _onLoadProducts(
    LoadProducts event,
    Emitter<ProductState> emit,
  ) async {
    try {
      if (event.isRefresh) {
        emit(const ProductLoading());
        _currentPage = 1;
      } else {
        emit(const ProductLoading());
        _currentPage = 1;
      }

      final products = await _productRepository.getProducts(
        searchQuery: event.searchQuery,
        brandId: event.brandId,
        paintType: event.paintType,
        finish: event.finish,
        page: _currentPage,
        limit: _pageSize,
      );

      emit(
        ProductsLoaded(
          products: products,
          hasReachedMax: products.length < _pageSize,
          currentSearchQuery: event.searchQuery,
          currentBrandFilter: event.brandId,
          currentPaintTypeFilter: event.paintType,
          currentFinishFilter: event.finish,
        ),
      );
    } catch (error) {
      emit(ProductError(message: error.toString()));
    }
  }

  Future<void> _onLoadMoreProducts(
    LoadMoreProducts event,
    Emitter<ProductState> emit,
  ) async {
    final currentState = state;
    if (currentState is! ProductsLoaded || currentState.hasReachedMax) {
      return;
    }

    emit(currentState.copyWith(isLoadingMore: true));

    try {
      _currentPage++;
      final newProducts = await _productRepository.getProducts(
        searchQuery: currentState.currentSearchQuery,
        brandId: currentState.currentBrandFilter,
        paintType: currentState.currentPaintTypeFilter,
        finish: currentState.currentFinishFilter,
        page: _currentPage,
        limit: _pageSize,
      );

      emit(
        currentState.copyWith(
          products: [...currentState.products, ...newProducts],
          hasReachedMax: newProducts.length < _pageSize,
          isLoadingMore: false,
        ),
      );
    } catch (error) {
      emit(ProductError(message: error.toString()));
    }
  }

  Future<void> _onSearchProducts(
    SearchProducts event,
    Emitter<ProductState> emit,
  ) async {
    add(LoadProducts(searchQuery: event.query));
  }

  Future<void> _onFilterProducts(
    FilterProducts event,
    Emitter<ProductState> emit,
  ) async {
    final currentState = state;
    String? currentSearchQuery;

    if (currentState is ProductsLoaded) {
      currentSearchQuery = currentState.currentSearchQuery;
    }

    add(
      LoadProducts(
        searchQuery: currentSearchQuery,
        brandId: event.brandId,
        paintType: event.paintType,
        finish: event.finish,
      ),
    );
  }

  Future<void> _onLoadProductDetail(
    LoadProductDetail event,
    Emitter<ProductState> emit,
  ) async {
    try {
      emit(const ProductLoading());

      final product = await _productRepository.getProductById(event.productId);

      if (product != null) {
        emit(ProductDetailLoaded(product: product, isLoadingRelated: true));

        // Load related products asynchronously
        add(LoadRelatedProducts(event.productId));
      } else {
        emit(const ProductError(message: 'Product not found'));
      }
    } catch (error) {
      emit(ProductError(message: error.toString()));
    }
  }

  Future<void> _onLoadFeaturedProducts(
    LoadFeaturedProducts event,
    Emitter<ProductState> emit,
  ) async {
    try {
      emit(const ProductLoading());

      final featuredProducts = await _productRepository.getFeaturedProducts();

      emit(FeaturedProductsLoaded(featuredProducts: featuredProducts));
    } catch (error) {
      emit(ProductError(message: error.toString()));
    }
  }

  Future<void> _onLoadRelatedProducts(
    LoadRelatedProducts event,
    Emitter<ProductState> emit,
  ) async {
    final currentState = state;
    if (currentState is! ProductDetailLoaded) return;

    try {
      final relatedProducts = await _productRepository.getRelatedProducts(
        event.productId,
      );

      emit(
        currentState.copyWith(
          relatedProducts: relatedProducts,
          isLoadingRelated: false,
        ),
      );
    } catch (error) {
      // Don't emit error for related products, just stop loading
      emit(currentState.copyWith(isLoadingRelated: false));
    }
  }

  Future<void> _onClearFilters(
    ClearFilters event,
    Emitter<ProductState> emit,
  ) async {
    add(const LoadProducts());
  }
}
