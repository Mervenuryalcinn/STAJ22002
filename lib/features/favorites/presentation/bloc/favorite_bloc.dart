import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/favorite_repository.dart';
import 'favorite_event.dart';
import 'favorite_state.dart';

class FavoriteBloc extends Bloc<FavoriteEvent, FavoriteState> {
  final FavoriteRepository repository;

  FavoriteBloc({required this.repository}) : super(FavoriteInitialState()) {
    on<LoadFavoritesEvent>(_onLoadFavorites);
    on<ToggleFavoriteEvent>(_onToggleFavorite);

    add(LoadFavoritesEvent());
  }

  Future<void> _onLoadFavorites(LoadFavoritesEvent event, Emitter<FavoriteState> emit) async {
    emit(FavoriteLoadingState());
    try {
      final list = await repository.getFavorites();
      emit(FavoritesLoadedState(favorites: list));
    } catch (e) {
      emit(FavoriteErrorState(message: e.toString()));
    }
  }

  Future<void> _onToggleFavorite(ToggleFavoriteEvent event, Emitter<FavoriteState> emit) async {
    try {
      await repository.toggleFavorite(event.favorite);
      final list = await repository.getFavorites();
      emit(FavoritesLoadedState(favorites: list));
    } catch (e) {
      emit(FavoriteErrorState(message: e.toString()));
    }
  }
}