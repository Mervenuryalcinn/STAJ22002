import '../../domain/entities/order_entity.dart';

class OrderItemModel extends OrderItemEntity {
  OrderItemModel({
    required super.productId,
    required super.productName,
    required super.quantity,
    required super.unitPrice,
  });

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    return OrderItemModel(
      productId: int.tryParse(json['product_id'].toString()) ?? 0,
      productName: json['product_name'] ?? '',
      quantity: int.tryParse(json['quantity'].toString()) ?? 0,
      unitPrice: double.tryParse(json['unit_price'].toString()) ?? 0.0,
    );
  }
}

class OrderModel extends OrderEntity {
  OrderModel({
    required super.id,
    required super.totalAmount,
    required super.status,
    required super.createdAt,
    required super.address,
    required super.items,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    var rawItems = json['items'] as List<dynamic>? ?? [];
    List<OrderItemModel> parsedItems = rawItems
        .map((item) => OrderItemModel.fromJson(item))
        .toList();

    return OrderModel(
      id: json['id'].toString(),
      totalAmount: double.tryParse(json['total_amount'].toString()) ?? 0.0,
      status: json['status'] ?? '',
      createdAt: json['created_at'] ?? '',
      address: json['address'] ?? '',
      items: parsedItems,
    );
  }
}