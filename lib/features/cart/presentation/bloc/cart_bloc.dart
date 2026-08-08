import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../../domain/entities/cart_item_entity.dart';
import '../../../products/domain/entities/product_entity.dart';
import 'cart_event.dart';
import 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  static const String _cartStorageKey = 'saved_cart_items';

  CartBloc() : super(const CartState()) {
    on<LoadCartEvent>(_onLoadCart);
    on<AddToCartEvent>(_onAddToCart);
    on<RemoveFromCartEvent>(_onRemoveFromCart);
    on<IncrementQuantityEvent>(_onIncrementQuantity);
    on<DecrementQuantityEvent>(_onDecrementQuantity);
    on<ClearCartEvent>(_onClearCart);

    // Bloc ilk açıldığında kaydedilmiş sepeti yükle
    add(LoadCartEvent());
  }

  // 1. Kaydedilmiş Sepeti Yükleme (Caching'den Okuma)
  Future<void> _onLoadCart(LoadCartEvent event, Emitter<CartState> emit) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? cartJson = prefs.getString(_cartStorageKey);

      if (cartJson != null) {
        final List<dynamic> decodedList = jsonDecode(cartJson);

        final List<CartItemEntity> loadedItems = decodedList.map((itemMap) {
          final productMap = itemMap['product'];

          final product = ProductEntity(
            id: productMap['id'],
            name: productMap['name'],
            price: (productMap['price'] as num).toDouble(),
            imageUrl: productMap['imageUrl'] ?? '',
            description: productMap['description'] ?? '',
            stock: productMap['stock'] ?? 0,
          );

          return CartItemEntity(
            product: product,
            quantity: itemMap['quantity'],
          );
        }).toList();

        emit(CartState(items: loadedItems));
      }
    } catch (e) {
      // Yükleme hatası yönetimi
    }
  }

  // 2. Sepete Ekleme
  void _onAddToCart(AddToCartEvent event, Emitter<CartState> emit) {
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

    emit(CartState(items: currentItems));
    _saveCartToPrefs();
  }

  // 3. Sepetten Çıkarma
  void _onRemoveFromCart(RemoveFromCartEvent event, Emitter<CartState> emit) {
    final currentItems = state.items.where((item) => item.product.id != event.productId).toList();
    emit(CartState(items: currentItems));
    _saveCartToPrefs();
  }

  // 4. Miktar Artırma (+)
  void _onIncrementQuantity(IncrementQuantityEvent event, Emitter<CartState> emit) {
    final currentItems = List<CartItemEntity>.from(state.items);
    final index = currentItems.indexWhere((item) => item.product.id == event.productId);

    if (index >= 0) {
      currentItems[index] = CartItemEntity(
        product: currentItems[index].product,
        quantity: currentItems[index].quantity + 1,
      );
      emit(CartState(items: currentItems));
      _saveCartToPrefs();
    }
  }

  // 5. Miktar Azaltma (-)
  void _onDecrementQuantity(DecrementQuantityEvent event, Emitter<CartState> emit) {
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
      emit(CartState(items: currentItems));
      _saveCartToPrefs();
    }
  }

  // 6. Sepeti Temizleme
  void _onClearCart(ClearCartEvent event, Emitter<CartState> emit) {
    emit(const CartState(items: []));
    _saveCartToPrefs();
  }

  // Yardımcı: SharedPreferences'a Kaydetme (Caching'e Yazma)
  Future<void> _saveCartToPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      final List<Map<String, dynamic>> jsonList = state.items.map((item) => {
        'product': {
          'id': item.product.id,
          'name': item.product.name,
          'price': item.product.price,
          'imageUrl': item.product.imageUrl,
          'description': item.product.description,
          'stock': item.product.stock,
        },
        'quantity': item.quantity,
      }).toList();

      await prefs.setString(_cartStorageKey, jsonEncode(jsonList));
    } catch (e) {
      // Kayıt hatası yönetimi
    }
  }
}