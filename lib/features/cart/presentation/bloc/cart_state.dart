import 'package:equatable/equatable.dart';
import '../../domain/entities/cart_item_entity.dart';
class CartState extends Equatable {
  final List<CartItemEntity> items;

  const CartState({this.items = const []});

  double get totalAmount => items.fold(0, (sum, item) => sum + item.totalprice);

  @override
  List<Object> get props => [items];
}