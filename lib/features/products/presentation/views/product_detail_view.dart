import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../domain/entities/product_entity.dart';
import '../../../cart/presentation/bloc/cart_bloc.dart';
import '../../../cart/presentation/bloc/cart_event.dart';
import '../../../authentication/presentation/bloc/auth_bloc.dart';
import '../../../authentication/presentation/bloc/auth_state.dart';
import '../../../favorites/domain/entities/favorite_entity.dart';
import '../../../favorites/presentation/bloc/favorite_bloc.dart';
import '../../../favorites/presentation/bloc/favorite_event.dart';
import '../../../favorites/presentation/bloc/favorite_state.dart';
import '../../../../app/router/route_paths.dart';

class ProductDetailView extends StatelessWidget {
  final ProductEntity product;

  const ProductDetailView({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(product.name),
        actions: [
          // Sağ üst köşeye Durum Kontrollü Favori Butonu Eklendi
          BlocBuilder<FavoriteBloc, FavoriteState>(
            builder: (context, state) {
              bool isFavorite = false;

              // Eğer favoriler yüklendiyse, bu ürün favoriler listesinde var mı kontrol et
              if (state is FavoritesLoadedState) {
                isFavorite = state.favorites.any((fav) => fav.id == product.id.toString());
              }

              return IconButton(
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: Colors.red,
                ),
                onPressed: () {
                  final favoriteItem = FavoriteEntity(
                    id: product.id.toString(),
                    title: product.name,
                    type: 'product',
                  );

                  context.read<FavoriteBloc>().add(
                    ToggleFavoriteEvent(favorite: favoriteItem),
                  );

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        isFavorite
                            ? '${product.name} favorilerden çıkarıldı!'
                            : '${product.name} favorilere eklendi!',
                      ),
                      duration: const Duration(seconds: 1),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(
                child: Icon(Icons.medical_services, size: 80, color: Colors.blue),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              product.name,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              '${product.price} ₺',
              style: const TextStyle(fontSize: 20, color: Colors.green, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),
            const Text(
              'Ürün Açıklaması',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              product.description,
              style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
            ),
            const Spacer(),

            // Eczanelerde Bul Butonu
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  context.push('/product-pharmacies/${product.id}', extra: product.name);
                },
                icon: const Icon(Icons.local_pharmacy, color: Colors.blue),
                label: Text('${product.name} Hangi Eczanelerde Var?'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  side: const BorderSide(color: Colors.blue),
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Sepete Ekle Butonu
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  final authState = context.read<AuthBloc>().state;
                  final bool isLoggedin = authState is AuthSuccessState;

                  if (!isLoggedin) {
                    context.go(RoutePaths.login);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Sepete ürün eklemek için lütfen önce giriş yapın!'),
                      ),
                    );
                  } else {
                    context.read<CartBloc>().add(
                      AddToCartEvent(product: product),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('${product.name} sepete eklendi!')),
                    );
                  }
                },
                icon: const Icon(Icons.shopping_cart),
                label: const Text('Sepete Ekle'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}