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
extension ProductEntityMapper on ProductEntity {
  // ProductEntity -> ProductModel dönüşümü
  ProductModel toModel() {
    return this is ProductModel
        ? this as ProductModel
        : ProductModel(
      id: id,
      name: name,
      price: price,
      imageUrl: imageUrl,
      description: description,
      stock: stock,
    );
  }
}