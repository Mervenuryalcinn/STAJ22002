import '../../domain/entities/favorite_entity.dart';

abstract class FavoriteEvent {}

class LoadFavoritesEvent extends FavoriteEvent {}

class ToggleFavoriteEvent extends FavoriteEvent {
  final FavoriteEntity favorite;
  ToggleFavoriteEvent({required this.favorite});
}
