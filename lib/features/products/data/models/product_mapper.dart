import '../../domain/entities/product_entity.dart';
import 'product_model.dart';

extension ProductMapper on ProductModel {
  ProductEntity toEntity() {
    return ProductEntity(
      id: id,
      name: name,
      description: description,
      price: price,
      imageUrl: imageUrl,
      stock: stock,
    );
  }
}