import '../entities/favorite_entity.dart';

abstract class FavoriteRepository {
  Future<List<FavoriteEntity>> getFavorites();
  Future<void> toggleFavorite(FavoriteEntity item);
  Future<bool> isFavorite(String id);
}