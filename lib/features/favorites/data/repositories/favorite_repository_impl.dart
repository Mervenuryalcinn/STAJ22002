import '../../domain/entities/favorite_entity.dart';
import '../../domain/repositories/favorite_repository.dart';
import '../datasources/favorite_remote_datasource.dart';
import '../models/favorite_model.dart';

class FavoriteRepositoryImpl implements FavoriteRepository {
  final FavoriteRemoteDataSource remoteDataSource;
  final String currentUserId; // Aktif kullanıcı ID'si

  FavoriteRepositoryImpl({
    required this.remoteDataSource,
    required this.currentUserId,
  });

  @override
  Future<List<FavoriteEntity>> getFavorites() async {
    return await remoteDataSource.getFavorites(currentUserId);
  }

  @override
  Future<void> toggleFavorite(FavoriteEntity item) async {
    final model = FavoriteModel(
      id: item.id,
      title: item.title,
      type: item.type,
    );
    await remoteDataSource.toggleFavorite(currentUserId, model);
  }

  @override
  Future<bool> isFavorite(String id) async {
    return await remoteDataSource.isFavorite(currentUserId, id);
  }
}