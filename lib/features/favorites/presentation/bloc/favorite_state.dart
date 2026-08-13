import '../../domain/entities/favorite_entity.dart';

abstract class FavoriteState {}

class FavoriteInitialState extends FavoriteState {}

class FavoriteLoadingState extends FavoriteState {}

class FavoritesLoadedState extends FavoriteState {
  final List<FavoriteEntity> favorites;
  FavoritesLoadedState({required this.favorites});
}

class FavoriteErrorState extends FavoriteState {
  final String message;
  FavoriteErrorState({required this.message});
}
