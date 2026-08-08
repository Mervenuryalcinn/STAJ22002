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
    // Arama yapıldığında yükleniyor gösterip doğrudan MySQL'den/API'den filtreli veri çekiyoruz
    emit(ProductLoading());

    // UseCase'e arama parametresini gönderiyoruz (FastAPI & MySQL LIKE sorgusu için)
    final failureOrProducts = await getProductsUseCase(query: event.query);

    failureOrProducts.fold(
          (failure) => emit(ProductError(message: failure.message)),
          (products) => emit(ProductLoaded(products: products)),
    );
  }
}