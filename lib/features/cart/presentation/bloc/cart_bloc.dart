import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/cart_item_entity.dart';
import '../../domain/usecases/get_cart_items_usecase.dart';
import '../../domain/usecases/save_cart_usecase.dart';
import 'cart_event.dart';
import 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final GetCartItemsUseCase getCartItemsUseCase;
  final SaveCartUseCase saveCartUseCase;

  CartBloc({
    required this.getCartItemsUseCase,
    required this.saveCartUseCase,
  }) : super(const CartState()) {
    on<LoadCartEvent>(_onLoadCart);
    on<AddToCartEvent>(_onAddToCart);
    on<RemoveFromCartEvent>(_onRemoveFromCart);
    on<IncrementQuantityEvent>(_onIncrementQuantity);
    on<DecrementQuantityEvent>(_onDecrementQuantity);
    on<ClearCartEvent>(_onClearCart);

    add(LoadCartEvent());
  }

  Future<void> _onLoadCart(LoadCartEvent event, Emitter<CartState> emit) async {
    emit(state.copyWith(isLoading: true));

    final result = await getCartItemsUseCase();

    result.fold(
          (failure) => emit(state.copyWith(isLoading: false, errorMessage: failure.message)),
          (items) => emit(state.copyWith(isLoading: false, items: items)),
    );
  }

  Future<void> _onAddToCart(AddToCartEvent event, Emitter<CartState> emit) async {
    final currentItems = List<CartItemEntity>.from(state.items);
    final existingIndex = currentItems.indexWhere((item) => item.product.id == event.product.id);

    if (existingIndex >= 0) {
      currentItems[existingIndex] = CartItemEntity(
        product: currentItems[existingIndex].product,
        quantity: currentItems[existingIndex].quantity + 1,
      );
    } else {
      currentItems.add(CartItemEntity(product: event.product, quantity: 1));
    }

    emit(state.copyWith(items: currentItems));
    await saveCartUseCase(currentItems);
  }

  Future<void> _onRemoveFromCart(RemoveFromCartEvent event, Emitter<CartState> emit) async {
    final currentItems = state.items.where((item) => item.product.id != event.productId).toList();
    emit(state.copyWith(items: currentItems));
    await saveCartUseCase(currentItems);
  }

  Future<void> _onIncrementQuantity(IncrementQuantityEvent event, Emitter<CartState> emit) async {
    final currentItems = List<CartItemEntity>.from(state.items);
    final index = currentItems.indexWhere((item) => item.product.id == event.productId);

    if (index >= 0) {
      currentItems[index] = CartItemEntity(
        product: currentItems[index].product,
        quantity: currentItems[index].quantity + 1,
      );
      emit(state.copyWith(items: currentItems));
      await saveCartUseCase(currentItems);
    }
  }

  Future<void> _onDecrementQuantity(DecrementQuantityEvent event, Emitter<CartState> emit) async {
    final currentItems = List<CartItemEntity>.from(state.items);
    final index = currentItems.indexWhere((item) => item.product.id == event.productId);

    if (index >= 0) {
      if (currentItems[index].quantity > 1) {
        currentItems[index] = CartItemEntity(
          product: currentItems[index].product,
          quantity: currentItems[index].quantity - 1,
        );
      } else {
        currentItems.removeAt(index);
      }
      emit(state.copyWith(items: currentItems));
      await saveCartUseCase(currentItems);
    }
  }

  Future<void> _onClearCart(ClearCartEvent event, Emitter<CartState> emit) async {
    emit(state.copyWith(items: []));
    await saveCartUseCase([]);
  }
}