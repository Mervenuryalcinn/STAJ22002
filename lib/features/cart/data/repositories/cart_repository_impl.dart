import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/error/exceptions.dart';
import '../../domain/repositories/cart_repository.dart';
import '../../domain/entities/cart_item_entity.dart';
import '../datasources/cart_remote_datasource.dart';
import '../models/cart_item_mapper.dart'; // Mapper'ı import ediyoruz

class CartRepositoryImpl implements CartRepository {
  final CartRemoteDataSource remoteDataSource;
  final String userId;

  CartRepositoryImpl({
    required this.remoteDataSource,
    required this.userId,
  });

  @override
  Future<Either<Failure, List<CartItemEntity>>> getCartItems() async {
    try {
      final models = await remoteDataSource.fetchCartFromServer(userId);
      // Model listesini Mapper kullanarak Entity listesine çeviriyoruz
      final entities = models.map((model) => model.toEntity()).toList();
      return Right(entities);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> saveCartItems(List<CartItemEntity> items) async {
    try {
      // Entity listesini Mapper kullanarak Model listesine çeviriyoruz
      final models = items.map((item) => item.toModel()).toList();
      await remoteDataSource.syncCartToServer(userId, models);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}