import 'package:flutter_bloc/flutter_bloc.dart';
import 'order_event.dart';
import 'order_state.dart';
import '../models/order.dart';
import '../models/order_item.dart';
import '../models/order_status.dart';
import '../../product_catalog/models/product.dart';
import '../../product_catalog/models/color.dart';
import '../../product_catalog/models/brand.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  OrderBloc() : super(const OrderInitial()) {
    on<FetchOrderHistory>(_onFetchOrderHistory);
    on<FetchOrderDetail>(_onFetchOrderDetail);
    on<RefreshOrderHistory>(_onRefreshOrderHistory);
    on<CancelOrder>(_onCancelOrder);
    on<ReorderFromOrder>(_onReorderFromOrder);
    on<TrackOrder>(_onTrackOrder);
  }

  Future<void> _onFetchOrderHistory(
    FetchOrderHistory event,
    Emitter<OrderState> emit,
  ) async {
    emit(const OrderHistoryLoading());

    try {
      // Simulate API delay
      await Future.delayed(const Duration(seconds: 1));

      // Mock order data for MVP
      final orders = _generateMockOrders();

      if (orders.isEmpty) {
        emit(const OrderHistoryEmpty());
      } else {
        emit(OrderHistoryLoaded(orders: orders));
      }
    } catch (e) {
      emit(
        OrderError(
          errorMessage: 'Failed to load order history: ${e.toString()}',
        ),
      );
    }
  }

  Future<void> _onFetchOrderDetail(
    FetchOrderDetail event,
    Emitter<OrderState> emit,
  ) async {
    emit(OrderDetailLoading(orderId: event.orderId));

    try {
      // Simulate API delay
      await Future.delayed(const Duration(milliseconds: 800));

      // Find order by ID from mock data
      final orders = _generateMockOrders();
      final order = orders.firstWhere(
        (order) => order.id == event.orderId,
        orElse: () => throw Exception('Order not found'),
      );

      emit(OrderDetailLoaded(order: order));
    } catch (e) {
      emit(
        OrderError(
          errorMessage: 'Failed to load order details: ${e.toString()}',
        ),
      );
    }
  }

  Future<void> _onRefreshOrderHistory(
    RefreshOrderHistory event,
    Emitter<OrderState> emit,
  ) async {
    // For refresh, we'll just fetch the history again
    add(const FetchOrderHistory());
  }

  Future<void> _onCancelOrder(
    CancelOrder event,
    Emitter<OrderState> emit,
  ) async {
    emit(
      OrderOperationInProgress(
        operationMessage: 'Cancelling order...',
        orderId: event.orderId,
      ),
    );

    try {
      // Simulate API delay
      await Future.delayed(const Duration(seconds: 2));

      // Mock order cancellation
      emit(
        const OrderOperationSuccess(
          successMessage: 'Order has been cancelled successfully',
        ),
      );

      // Refresh order history
      add(const FetchOrderHistory());
    } catch (e) {
      emit(OrderError(errorMessage: 'Failed to cancel order: ${e.toString()}'));
    }
  }

  Future<void> _onReorderFromOrder(
    ReorderFromOrder event,
    Emitter<OrderState> emit,
  ) async {
    emit(
      OrderOperationInProgress(
        operationMessage: 'Adding items to cart...',
        orderId: event.orderId,
      ),
    );

    try {
      // Simulate API delay
      await Future.delayed(const Duration(seconds: 1));

      // Mock reorder functionality
      emit(
        const OrderOperationSuccess(
          successMessage: 'Items have been added to your cart',
        ),
      );
    } catch (e) {
      emit(OrderError(errorMessage: 'Failed to reorder: ${e.toString()}'));
    }
  }

  Future<void> _onTrackOrder(TrackOrder event, Emitter<OrderState> emit) async {
    emit(
      OrderOperationInProgress(
        operationMessage: 'Loading tracking information...',
        orderId: event.orderId,
      ),
    );

    try {
      // Simulate API delay
      await Future.delayed(const Duration(seconds: 1));

      // Mock tracking functionality
      emit(
        const OrderOperationSuccess(
          successMessage: 'Tracking information updated',
        ),
      );
    } catch (e) {
      emit(
        OrderError(errorMessage: 'Failed to load tracking: ${e.toString()}'),
      );
    }
  }

  /// Generate mock orders for MVP testing
  List<Order> _generateMockOrders() {
    final mockBrand = Brand(
      id: 1,
      name: 'PaintPro',
      description: 'Premium paint brand',
      logoUrl: 'https://example.com/brand.png',
    );

    final mockProduct1 = Product(
      id: 1,
      name: 'Premium Wall Paint',
      description: 'High-quality interior wall paint',
      brand: mockBrand,
      imageUrls: ['https://example.com/paint1.jpg'],
      availableColors: [],
      basePrice: 25.99,
      paintType: PaintType.interior,
      coverage: 12.0,
      finish: PaintFinish.matte,
      size: '5L',
    );

    final mockProduct2 = Product(
      id: 2,
      name: 'Ceiling Paint',
      description: 'Specialized paint for ceilings',
      brand: mockBrand,
      imageUrls: ['https://example.com/paint2.jpg'],
      availableColors: [],
      basePrice: 19.99,
      paintType: PaintType.interior,
      coverage: 10.0,
      finish: PaintFinish.matte,
      size: '5L',
    );

    final mockColor1 = ProductColor(
      id: 1,
      name: 'Ocean Blue',
      hexCode: '#1E90FF',
      description: 'Beautiful ocean blue color',
    );

    final mockColor2 = ProductColor(
      id: 2,
      name: 'Pure White',
      hexCode: '#FFFFFF',
      description: 'Clean pure white color',
    );

    final now = DateTime.now();

    return [
      Order(
        id: 'order1',
        userId: 'user1',
        items: [
          OrderItem(
            id: 'item1',
            product: mockProduct1,
            selectedColor: mockColor1,
            quantity: 2,
            priceAtPurchase: 25.99,
            notes: 'For living room',
          ),
        ],
        status: OrderStatus.delivered,
        subtotal: 51.98,
        tax: 5.20,
        total: 57.18,
        shippingAddress: '123 Main St, City, State 12345',
        notes: 'Leave at front door',
        createdAt: now.subtract(const Duration(days: 7)),
        updatedAt: now.subtract(const Duration(days: 2)),
      ),
      Order(
        id: 'order2',
        userId: 'user1',
        items: [
          OrderItem(
            id: 'item2',
            product: mockProduct2,
            selectedColor: mockColor2,
            quantity: 1,
            priceAtPurchase: 19.99,
            notes: 'For bedroom ceiling',
          ),
          OrderItem(
            id: 'item3',
            product: mockProduct1,
            selectedColor: mockColor1,
            quantity: 1,
            priceAtPurchase: 25.99,
          ),
        ],
        status: OrderStatus.shipped,
        subtotal: 45.98,
        tax: 4.60,
        total: 50.58,
        shippingAddress: '123 Main St, City, State 12345',
        createdAt: now.subtract(const Duration(days: 3)),
        updatedAt: now.subtract(const Duration(days: 1)),
      ),
      Order(
        id: 'order3',
        userId: 'user1',
        items: [
          OrderItem(
            id: 'item4',
            product: mockProduct1,
            selectedColor: mockColor1,
            quantity: 3,
            priceAtPurchase: 25.99,
            notes: 'Entire house project',
          ),
        ],
        status: OrderStatus.processing,
        subtotal: 77.97,
        tax: 7.80,
        total: 85.77,
        shippingAddress: '123 Main St, City, State 12345',
        notes: 'Call before delivery',
        createdAt: now.subtract(const Duration(days: 1)),
        updatedAt: now.subtract(const Duration(hours: 12)),
      ),
    ];
  }
}
