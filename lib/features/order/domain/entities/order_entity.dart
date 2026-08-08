class OrderItemEntity {
  final int productId;
  final String productName;
  final int quantity;
  final double unitPrice;

  OrderItemEntity({
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.unitPrice,
  });
}

class OrderEntity {
  final String id;
  final double totalAmount;
  final String status;
  final String createdAt;
  final String address;
  final List<OrderItemEntity> items;

  OrderEntity({
    required this.id,
    required this.totalAmount,
    required this.status,
    required this.createdAt,
    required this.address,
    required this.items,
  });
}