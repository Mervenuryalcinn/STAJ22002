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
import '../../../../../../core/widgets/top_notification.dart';
import 'package:lideatech_pharmacy_app/l10n/app_localizations.dart';

class ProductDetailView extends StatelessWidget {
  const ProductDetailView({super.key, required this.product});

  final ProductEntity product;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(product.name),
        actions: [
          // Sağ üst köşeye Oturum Kontrollü Favori Butonu
          BlocBuilder<FavoriteBloc, FavoriteState>(
            builder: (context, state) {
              bool isFavorite = false;

              if (state is FavoritesLoadedState) {
                isFavorite = state.favorites.any(
                      (fav) => fav.id.toString().trim() == product.id.toString().trim(),
                );
              }

              return IconButton(
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: Colors.red,
                ),
                onPressed: () {
                  // Oturum kontrolü
                  final authState = context.read<AuthBloc>().state;
                  final bool isLoggedIn = authState is AuthSuccessState;

                  if (!isLoggedIn) {
                    // context.go yerine context.push kullanarak geri dönülebilmesini sağlıyoruz
                    context.push(RoutePaths.login);
                    TopNotification.show(
                      context,
                      'Favorilere eklemek için giriş yapmalısınız', // l10n'de tanımlı değilse doğrudan metin
                      isError: true,
                    );
                    return;
                  }

                  final favoriteItem = FavoriteEntity(
                    id: product.id.toString(),
                    title: product.name,
                    type: 'product',
                  );

                  // 1. Bloğa eventi gönderiyoruz
                  context.read<FavoriteBloc>().add(
                    ToggleFavoriteEvent(favorite: favoriteItem),
                  );

                  // 2. Bildirimi gösteriyoruz
                  TopNotification.show(
                    context,
                    isFavorite
                        ? '${product.name} ${l10n.removedFromFavorites}'
                        : '${product.name} ${l10n.addedToFavorites}',
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
            Text(
              l10n.productDescription,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
                label: Text('${product.name} ${l10n.pharmacyQueryButton}'),
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
                    // Sepette de aynı mantık istenirse burası da context.push yapılabilir
                    context.push(RoutePaths.login);
                    TopNotification.show(
                      context,
                      l10n.loginRequiredForCart,
                      isError: true,
                    );
                  } else {
                    context.read<CartBloc>().add(
                      AddToCartEvent(product: product),
                    );

                    TopNotification.show(
                      context,
                      '${product.name} ${l10n.addedToCart}',
                    );
                  }
                },
                icon: const Icon(Icons.shopping_cart),
                label: Text(l10n.addToCart),
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