// order_event.dart içerisindeki LoadOrdersEvent sınıfı şu şekilde olmalıdır:

abstract class OrderEvent {}

class LoadOrdersEvent extends OrderEvent {
  final String userId;

  LoadOrdersEvent({required this.userId});
}// FetchOrdersEvent yerine

class LoadOrderDetailEvent extends OrderEvent { // FetchOrderDetailEvent yerine
  final String orderId;

  LoadOrderDetailEvent({required this.orderId});
}


class CreateOrderEvent extends OrderEvent {
  final String userId;
  final int eczaneId;
  final double totalAmount;
  final List<Map<String, dynamic>> items;

  CreateOrderEvent({
    required this.userId,
    required this.eczaneId,
    required this.totalAmount,
    required this.items,
  });
}