import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_products_usecase.dart';
import 'product_event.dart';
import 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final GetProductsUseCase getProductsUseCase;

  ProductBloc({required this.getProductsUseCase}) : super(ProductInitial()) {
    on<FetchProductsEvent>(_onFetchProducts);
    on<SearchProductsEvent>(_onSearchProducts);
  }

  Future<void> _onFetchProducts(
      FetchProductsEvent event, Emitter<ProductState> emit) async {
    emit(ProductLoading());

    final failureOrProducts = await getProductsUseCase();

    failureOrProducts.fold(
          (failure) => emit(ProductError(message: failure.message)),
          (products) => emit(ProductLoaded(products: products)),
    );
  }

  Future<void> _onSearchProducts(
      SearchProductsEvent event, Emitter<ProductState> emit) async {
    final currentState = state;
    if (currentState is ProductLoaded) {
      // Eğer halihazırda ürünler yüklendiyse yerel filtreleme yapalım
      final allProducts = currentState.products;
      if (event.query.isEmpty) {
        emit(ProductLoaded(products: allProducts));
        return;
      }

      final filteredList = allProducts.where((product) {
        return product.name.toLowerCase().contains(event.query.toLowerCase());
      }).toList();

      emit(ProductLoaded(products: filteredList));
    }
  }
}