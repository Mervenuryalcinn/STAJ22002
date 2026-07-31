import 'package:equatable/equatable.dart';
import '../../../products/domain/entities/product_entity.dart';

abstract class CartEvent extends Equatable {
  const CartEvent();
  @override
  List<Object> get props => [];
}

class AddToCartEvent extends CartEvent {
  final ProductEntity product;
  const AddToCartEvent({required this.product});
  @override
  List<Object> get props => [product];
}

class RemoveFromCartEvent extends CartEvent {
  final String productId;
  const RemoveFromCartEvent({required this.productId});
  @override
  List<Object> get props => [productId];
}