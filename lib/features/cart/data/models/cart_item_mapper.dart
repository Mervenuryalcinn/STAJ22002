
import '../../domain/entities/cart_item_entity.dart';
import '../../../products/data/models/product_model.dart';
import '../../../products/data/models/product_mapper.dart';
import 'cart_item_model.dart';

extension CartItemMapper on CartItemModel {
  // Model -> Entity dönüşümü
  CartItemEntity toEntity() {
    return CartItemEntity(
      product: product.toEntity(),
      quantity: quantity,
    );
  }
}

extension CartItemEntityMapper on CartItemEntity {
  // Entity -> Model dönüşümü
  CartItemModel toModel() {
    return CartItemModel(
      product: product is ProductModel
          ? product as ProductModel
          : ProductModel(
        id: product.id,
        name: product.name,
        price: product.price,
        imageUrl: product.imageUrl,
        description: product.description,
        stock: product.stock,
      ),
      quantity: quantity,
    );
  }
}