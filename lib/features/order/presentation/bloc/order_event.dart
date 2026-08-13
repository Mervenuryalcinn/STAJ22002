abstract class OrderEvent {}

class LoadOrdersEvent extends OrderEvent {
  final String userId;

  LoadOrdersEvent({required this.userId});
}

class LoadOrderDetailEvent extends OrderEvent {
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