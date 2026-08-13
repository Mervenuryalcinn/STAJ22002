import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_products_usecase.dart';
import 'product_event.dart';
import 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final GetProductsUseCase getProductsUseCase;
  int _currentPage = 1;
  final int _limit = 10;
  String _currentQuery = '';

  ProductBloc({required this.getProductsUseCase}) : super(ProductInitial()) {
    on<FetchProductsEvent>(_onFetchProducts);
    on<SearchProductsEvent>(_onSearchProducts);
  }

  Future<void> _onFetchProducts(
      FetchProductsEvent event, Emitter<ProductState> emit) async {
    // Eğer zaten son sınıra ulaşıldıysa yeni istek atma
    if (state is ProductLoaded && (state as ProductLoaded).hasReachedMax) return;

    try {
      if (state is ProductInitial) {
        emit(ProductLoading());
        _currentPage = 1;
        _currentQuery = '';
        final result = await getProductsUseCase(page: _currentPage, limit: _limit);
        result.fold(
              (failure) => emit(ProductError(message: failure.message)),
              (products) => emit(ProductLoaded(products: products, hasReachedMax: products.length < _limit)),
        );
        return;
      }

      // Sayfalama için sonraki sayfa isteği
      if (state is ProductLoaded) {
        final currentState = state as ProductLoaded;
        _currentPage++;

        final result = await getProductsUseCase(page: _currentPage, limit: _limit, query: _currentQuery.isEmpty ? null : _currentQuery);

        result.fold(
              (failure) => emit(ProductError(message: failure.message)),
              (newProducts) {
            if (newProducts.isEmpty) {
              emit(currentState.copyWith(hasReachedMax: true));
            } else {
              emit(ProductLoaded(
                products: [...currentState.products, ...newProducts],
                hasReachedMax: newProducts.length < _limit,
              ));
            }
          },
        );
      }
    } catch (e) {
      emit(ProductError(message: e.toString()));
    }
  }

  Future<void> _onSearchProducts(
      SearchProductsEvent event, Emitter<ProductState> emit) async {
    emit(ProductLoading());
    _currentPage = 1;
    _currentQuery = event.query;

    final result = await getProductsUseCase(page: _currentPage, limit: _limit, query: _currentQuery.isEmpty ? null : _currentQuery);

    result.fold(
          (failure) => emit(ProductError(message: failure.message)),
          (products) => emit(ProductLoaded(products: products, hasReachedMax: products.length < _limit)),
    );
  }
}