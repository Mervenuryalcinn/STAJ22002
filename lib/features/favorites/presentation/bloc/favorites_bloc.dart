import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../products/domain/entities/product_entity.dart';
import 'package:equatable/equatable.dart';

abstract class FavoritesEvent extends Equatable {
  const FavoritesEvent();
  @override
  List<Object> get props => [];
}

class ToggleFavoriteEvent extends FavoritesEvent {
  final ProductEntity product;
  const ToggleFavoriteEvent({required this.product});
  @override
  List<Object> get props => [product];
}

class FavoritesState extends Equatable {
  final List<ProductEntity> favorites;
  const FavoritesState({this.favorites = const []});

  @override
  List<Object> get props => [favorites];
}

class FavoritesBloc extends Bloc<FavoritesEvent, FavoritesState> {
  FavoritesBloc() : super(const FavoritesState()) {
    on<ToggleFavoriteEvent>((event, emit) {
      final currentFavs = List<ProductEntity>.from(state.favorites);
      if (currentFavs.any((p) => p.id == event.product.id)) {
        currentFavs.removeWhere((p) => p.id == event.product.id);
      } else {
        currentFavs.add(event.product);
      }
      emit(FavoritesState(favorites: currentFavs));
    });
  }
}