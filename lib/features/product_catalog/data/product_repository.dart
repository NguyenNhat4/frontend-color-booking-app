import '../models/product.dart';
import '../models/brand.dart';
import '../models/color.dart';

class ProductRepository {
  // Singleton pattern
  static final ProductRepository _instance = ProductRepository._internal();
  factory ProductRepository() => _instance;
  ProductRepository._internal();

  // Fake data
  final List<Brand> _brands = [
    const Brand(
      id: 1,
      name: 'Benjamin Moore',
      description: 'Premium quality paints and coatings',
      logoUrl: 'https://example.com/benjamin-moore-logo.png',
    ),
    const Brand(
      id: 2,
      name: 'Sherwin-Williams',
      description: 'Professional paint solutions',
      logoUrl: 'https://example.com/sherwin-williams-logo.png',
    ),
    const Brand(
      id: 3,
      name: 'Dulux',
      description: 'Color and protection for life',
      logoUrl: 'https://example.com/dulux-logo.png',
    ),
    const Brand(
      id: 4,
      name: 'Nippon Paint',
      description: 'Asia\'s leading paint manufacturer',
      logoUrl: 'https://example.com/nippon-logo.png',
    ),
  ];

  final List<ProductColor> _colors = [
    const ProductColor(
      id: 1,
      name: 'Pure White',
      hexCode: '#FFFFFF',
      description: 'Classic clean white finish',
    ),
    const ProductColor(
      id: 2,
      name: 'Midnight Blue',
      hexCode: '#1B1B3C',
      description: 'Deep, sophisticated blue',
    ),
    const ProductColor(
      id: 3,
      name: 'Forest Green',
      hexCode: '#2D5A27',
      description: 'Natural forest green tone',
    ),
    const ProductColor(
      id: 4,
      name: 'Warm Gray',
      hexCode: '#8B8680',
      description: 'Versatile neutral gray',
    ),
    const ProductColor(
      id: 5,
      name: 'Coral Sunset',
      hexCode: '#FF6B6B',
      description: 'Vibrant coral with warm undertones',
    ),
    const ProductColor(
      id: 6,
      name: 'Ocean Breeze',
      hexCode: '#4ECDC4',
      description: 'Refreshing aqua blue',
    ),
    const ProductColor(
      id: 7,
      name: 'Lavender Dream',
      hexCode: '#9B59B6',
      description: 'Soft purple with calming effect',
    ),
    const ProductColor(
      id: 8,
      name: 'Sunshine Yellow',
      hexCode: '#F1C40F',
      description: 'Bright and cheerful yellow',
    ),
    const ProductColor(
      id: 9,
      name: 'Charcoal Black',
      hexCode: '#2C3E50',
      description: 'Rich charcoal with depth',
    ),
    const ProductColor(
      id: 10,
      name: 'Cream',
      hexCode: '#FDF6E3',
      description: 'Warm off-white cream',
    ),
  ];

  late final List<Product> _products = [
    Product(
      id: 1,
      name: 'Advance Interior Paint',
      description:
          'Premium water-based alkyd paint for interior walls and trim. Provides excellent durability and smooth finish.',
      brand: _brands[0], // Benjamin Moore
      availableColors: [_colors[0], _colors[1], _colors[3], _colors[9]],
      imageUrls: [
        'https://example.com/paint-can-1.jpg',
        'https://example.com/paint-can-1-2.jpg',
      ],
      basePrice: 45.99,
      paintType: PaintType.interior,
      finish: PaintFinish.satin,
      coverage: 12.0,
      size: '1L',
      isFeatured: true,
      rating: 4.8,
      reviewCount: 125,
    ),
    Product(
      id: 2,
      name: 'WeatherShield Exterior',
      description:
          'All-weather exterior paint with advanced protection against harsh conditions. Long-lasting and fade-resistant.',
      brand: _brands[1], // Sherwin-Williams
      availableColors: [_colors[2], _colors[3], _colors[8], _colors[9]],
      imageUrls: [
        'https://example.com/exterior-paint-1.jpg',
        'https://example.com/exterior-paint-1-2.jpg',
      ],
      basePrice: 52.99,
      paintType: PaintType.exterior,
      finish: PaintFinish.semiGloss,
      coverage: 10.0,
      size: '1L',
      isFeatured: true,
      rating: 4.6,
      reviewCount: 89,
    ),
    Product(
      id: 3,
      name: 'Diamond Matt Emulsion',
      description:
          'Superior quality matt emulsion paint with excellent coverage and washability. Perfect for living spaces.',
      brand: _brands[2], // Dulux
      availableColors: [
        _colors[0],
        _colors[4],
        _colors[5],
        _colors[6],
        _colors[9],
      ],
      imageUrls: [
        'https://example.com/dulux-diamond-1.jpg',
        'https://example.com/dulux-diamond-1-2.jpg',
        'https://example.com/dulux-diamond-1-3.jpg',
      ],
      basePrice: 38.99,
      paintType: PaintType.interior,
      finish: PaintFinish.matte,
      coverage: 14.0,
      size: '1L',
      rating: 4.5,
      reviewCount: 203,
    ),
    Product(
      id: 4,
      name: 'Odour-less Premium',
      description:
          'Low VOC, odourless interior paint perfect for bedrooms and children\'s rooms. Quick-drying formula.',
      brand: _brands[3], // Nippon Paint
      availableColors: [
        _colors[0],
        _colors[1],
        _colors[3],
        _colors[6],
        _colors[7],
      ],
      imageUrls: ['https://example.com/nippon-odourless-1.jpg'],
      basePrice: 41.99,
      paintType: PaintType.interior,
      finish: PaintFinish.satin,
      coverage: 13.0,
      size: '1L',
      rating: 4.7,
      reviewCount: 67,
    ),
    Product(
      id: 5,
      name: 'Ultra Gloss Finish',
      description:
          'High-gloss specialty paint for trim, doors, and furniture. Provides mirror-like finish with superior durability.',
      brand: _brands[0], // Benjamin Moore
      availableColors: [_colors[0], _colors[2], _colors[8], _colors[9]],
      imageUrls: [
        'https://example.com/ultra-gloss-1.jpg',
        'https://example.com/ultra-gloss-1-2.jpg',
      ],
      basePrice: 59.99,
      paintType: PaintType.specialty,
      finish: PaintFinish.gloss,
      coverage: 8.0,
      size: '1L',
      isFeatured: true,
      rating: 4.9,
      reviewCount: 45,
    ),
    Product(
      id: 6,
      name: 'EasyClean Interior',
      description:
          'Stain-resistant interior paint that wipes clean easily. Perfect for high-traffic areas and family homes.',
      brand: _brands[1], // Sherwin-Williams
      availableColors: [
        _colors[0],
        _colors[3],
        _colors[4],
        _colors[5],
        _colors[9],
      ],
      imageUrls: ['https://example.com/easyclean-1.jpg'],
      basePrice: 43.99,
      paintType: PaintType.interior,
      finish: PaintFinish.satin,
      coverage: 11.0,
      size: '1L',
      rating: 4.4,
      reviewCount: 156,
    ),
  ];

  // API methods
  Future<List<Product>> getProducts({
    String? searchQuery,
    int? brandId,
    PaintType? paintType,
    PaintFinish? finish,
    int page = 1,
    int limit = 20,
  }) async {
    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 800));

    List<Product> filteredProducts = List.from(_products);

    // Apply filters
    if (searchQuery != null && searchQuery.isNotEmpty) {
      filteredProducts =
          filteredProducts
              .where(
                (product) =>
                    product.name.toLowerCase().contains(
                      searchQuery.toLowerCase(),
                    ) ||
                    product.brand.name.toLowerCase().contains(
                      searchQuery.toLowerCase(),
                    ) ||
                    product.description.toLowerCase().contains(
                      searchQuery.toLowerCase(),
                    ),
              )
              .toList();
    }

    if (brandId != null) {
      filteredProducts =
          filteredProducts
              .where((product) => product.brand.id == brandId)
              .toList();
    }

    if (paintType != null) {
      filteredProducts =
          filteredProducts
              .where((product) => product.paintType == paintType)
              .toList();
    }

    if (finish != null) {
      filteredProducts =
          filteredProducts
              .where((product) => product.finish == finish)
              .toList();
    }

    // Apply pagination
    final startIndex = (page - 1) * limit;
    final endIndex = startIndex + limit;

    if (startIndex >= filteredProducts.length) {
      return [];
    }

    return filteredProducts.sublist(
      startIndex,
      endIndex > filteredProducts.length ? filteredProducts.length : endIndex,
    );
  }

  Future<Product?> getProductById(int id) async {
    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 300));

    try {
      return _products.firstWhere((product) => product.id == id);
    } catch (e) {
      return null;
    }
  }

  Future<List<Product>> getFeaturedProducts() async {
    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 500));

    return _products.where((product) => product.isFeatured).toList();
  }

  Future<List<Brand>> getBrands() async {
    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 200));

    return List.from(_brands);
  }

  Future<List<ProductColor>> getColors() async {
    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 200));

    return List.from(_colors);
  }

  Future<List<Product>> getRelatedProducts(int productId) async {
    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 400));

    final currentProduct = _products.firstWhere(
      (product) => product.id == productId,
    );

    // Return products from the same brand or with similar paint type
    return _products
        .where(
          (product) =>
              product.id != productId &&
              (product.brand.id == currentProduct.brand.id ||
                  product.paintType == currentProduct.paintType),
        )
        .take(4)
        .toList();
  }
}
