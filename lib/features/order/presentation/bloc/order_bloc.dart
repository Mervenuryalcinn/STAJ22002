
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
// SİPARİŞLERİ GETİR
// ==========================================

on<LoadOrdersEvent>((event, emit) async {
emit(OrderLoadingState());

try {
print('========================================');
print('📦 ORDER BLOC - SİPARİŞLER GETİRİLİYOR');
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
} catch (e) {
print('❌ ORDER BLOC HATASI: $e');

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
emit(OrderLoadingState());

try {
final order = await orderRepository.getOrderById(
event.orderId,
);

emit(
OrderDetailLoadedState(
order: order,
),
);
} catch (e) {
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
print('🛒 ORDER BLOC - SİPARİŞ OLUŞTURULUYOR');
print('👤 USER ID: ${event.userId}');
print('🏥 ECZANE ID: ${event.eczaneId}');
print('💰 TOPLAM: ${event.totalAmount}');
print('========================================');

// Önce siparişi oluştur
await orderRepository.createOrder(
userId: event.userId,
eczaneId: event.eczaneId,
totalAmount: event.totalAmount,
items: event.items,
);

// Sipariş oluşturulduktan sonra
// aynı kullanıcının siparişlerini getir
final orders = await orderRepository.getOrders(
event.userId,
);

emit(
OrderLoadedState(
orders: orders,
),
);
} catch (e) {
print('❌ SİPARİŞ OLUŞTURMA HATASI: $e');

emit(
OrderErrorState(
message: e.toString(),
),
);
}
});
}


}