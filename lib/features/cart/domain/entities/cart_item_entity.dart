import '../../../products/domain/entities/product_entity.dart';

class CartItemEntity {
  final ProductEntity product;
  int quantity;

  CartItemEntity({
    required this.product,
    this.quantity = 1,
  });

  double get totalprice => product.price * quantity;

}