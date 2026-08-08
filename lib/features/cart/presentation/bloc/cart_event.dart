import 'package:equatable/equatable.dart';
import '../../../products/domain/entities/product_entity.dart';

abstract class CartEvent extends Equatable {
  const CartEvent();
  @override
  List<Object> get props => [];
}

class LoadCartEvent extends CartEvent {}

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

class IncrementQuantityEvent extends CartEvent {
  final String productId;
  const IncrementQuantityEvent({required this.productId});
  @override
  List<Object> get props => [productId];
}

class DecrementQuantityEvent extends CartEvent {
  final String productId;
  const DecrementQuantityEvent({required this.productId});
  @override
  List<Object> get props => [productId];
}

class ClearCartEvent extends CartEvent {}