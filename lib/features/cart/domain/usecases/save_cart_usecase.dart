import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/cart_item_entity.dart';
import '../repositories/cart_repository.dart';

class SaveCartUseCase {
  final CartRepository repository;

  SaveCartUseCase(this.repository);

  Future<Either<Failure, void>> call(List<CartItemEntity> items) async {
    return await repository.saveCartItems(items);
  }
}