import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/order_repository.dart';
import 'order_event.dart';
import 'order_state.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final OrderRepository orderRepository;
  final dynamic getOrdersUseCase;

  OrderBloc({
    required this.orderRepository,
    required this.getOrdersUseCase,
  }) : super(OrderInitialState()) {

    // ==========================================
    // SİPARİŞLER
    // ==========================================

    on<LoadOrdersEvent>((event, emit) async {
      emit(OrderLoadingState());

      try {
        print('========================================');
        print('📦 ORDER BLOC - SİPARİŞLER');
        print('👤 USER ID: ${event.userId}');
        print('========================================');

        final orders = await orderRepository.getOrders(
          event.userId,
        );

        emit(
          OrderLoadedState(
            orders: orders,
          ),
        );
      } catch (e, stackTrace) {
        print('❌ SİPARİŞLER HATASI: $e');
        print(stackTrace);

        emit(
          OrderErrorState(
            message: e.toString(),
          ),
        );
      }
    });

    // ==========================================
    // SİPARİŞ DETAYI
    // ==========================================

    on<LoadOrderDetailEvent>((event, emit) async {
      print('========================================');
      print('🔍 ORDER DETAIL');
      print('🆔 ORDER ID: ${event.orderId}');
      print('========================================');

      emit(OrderLoadingState());

      try {
        print('➡️ API çağrılıyor...');

        final order = await orderRepository.getOrderById(
          event.orderId,
        );

        print('✅ API BAŞARILI');
        print('🆔 ID: ${order.id}');
        print('📌 STATUS: ${order.status}');
        print('💰 TOTAL: ${order.totalAmount}');
        print('📦 ITEM SAYISI: ${order.items.length}');

        emit(
          OrderDetailLoadedState(
            order: order,
          ),
        );

        print('✅ OrderDetailLoadedState gönderildi.');
      } catch (e, stackTrace) {
        print('========================================');
        print('❌ ORDER DETAIL HATASI');
        print('$e');
        print('========================================');

        print(stackTrace);

        emit(
          OrderErrorState(
            message: e.toString(),
          ),
        );
      }
    });

    // ==========================================
    // SİPARİŞ OLUŞTUR
    // ==========================================

    on<CreateOrderEvent>((event, emit) async {
      emit(OrderLoadingState());

      try {
        print('========================================');
        print('🛒 SİPARİŞ OLUŞTURULUYOR');
        print('👤 USER ID: ${event.userId}');
        print('🏥 ECZANE ID: ${event.eczaneId}');
        print('💰 TOPLAM: ${event.totalAmount}');
        print('========================================');

        await orderRepository.createOrder(
          userId: event.userId,
          eczaneId: event.eczaneId,
          totalAmount: event.totalAmount,
          items: event.items,
        );

        final orders = await orderRepository.getOrders(
          event.userId,
        );

        emit(
          OrderLoadedState(
            orders: orders,
          ),
        );
      } catch (e, stackTrace) {
        print('❌ SİPARİŞ OLUŞTURMA HATASI: $e');
        print(stackTrace);

        emit(
          OrderErrorState(
            message: e.toString(),
          ),
        );
      }
    });
  }
}