import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/router/route_paths.dart';
import '../../../../core/network/dio_client.dart';
import '../../../authentication/presentation/bloc/auth_bloc.dart';
import '../../../authentication/presentation/bloc/auth_state.dart';
import '../../../products/domain/entities/product_entity.dart';
import '../../../products/presentation/views/product_detail_view.dart';
import '../../data/datasources/favorite_remote_datasource.dart';
import '../../data/repositories/favorite_repository_impl.dart';
import '../bloc/favorite_bloc.dart';
import '../bloc/favorite_event.dart';
import '../bloc/favorite_state.dart';
import '../../../products/presentation/bloc/product_bloc.dart';
import '../../../products/presentation/bloc/product_state.dart';
import '../../domain/entities/favorite_entity.dart';
import 'package:lideatech_pharmacy_app/l10n/app_localizations.dart';

class FavoritesView extends StatelessWidget {
  const FavoritesView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, authState) {
        final bool isLoggedIn = authState is AuthSuccessState;

        if (!isLoggedIn) {
          return Scaffold(
            appBar: AppBar(
              title: Text(l10n.favorites),
            ),
            body: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.favorite_border, size: 80, color: Colors.grey),
                    const SizedBox(height: 16),
                    Text(
                      l10n.loginToViewFavorites,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 16, color: Colors.black54),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () {
                          context.push(RoutePaths.login);
                        },
                        child: Text(
                          l10n.login,
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        // Giriş yapmış kullanıcıdan gerçek ID'yi alıyoruz
        final String userId = authState.userId;
        print("🎯 FAVORİLER İÇİN KULLANILAN USER ID: $userId");

        // BlocProvider'ı burada tanımlayarak doğru userId'nin repoya gitmesini sağlıyoruz
        return BlocProvider(
          create: (context) => FavoriteBloc(
            repository: FavoriteRepositoryImpl(
              remoteDataSource: FavoriteRemoteDataSourceImpl(
                dioClient: DioClient(),
              ),
              currentUserId: userId,
            ),
          ),
          child: Scaffold(
            appBar: AppBar(
              title: Text(l10n.favorites),
            ),
            body: BlocBuilder<FavoriteBloc, FavoriteState>(
              builder: (context, favState) {
                if (favState is FavoriteLoadingState) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (favState is FavoritesLoadedState) {
                  if (favState.favorites.isEmpty) {
                    return Center(
                      child: Text(
                        l10n.noFavoritesYet,
                        style: const TextStyle(color: Colors.grey, fontSize: 16),
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: favState.favorites.length,
                    padding: const EdgeInsets.all(12),
                    itemBuilder: (context, index) {
                      final item = favState.favorites[index];
                      final bool isPharmacy = item.type == 'pharmacy';

                      return Card(
                        margin: const EdgeInsets.only(bottom: 10),
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          leading: CircleAvatar(
                            backgroundColor: isPharmacy ? Colors.green.shade50 : Colors.blue.shade50,
                            child: Icon(
                              isPharmacy ? Icons.local_pharmacy : Icons.medication,
                              color: isPharmacy ? Colors.green : Colors.blue,
                            ),
                          ),
                          title: Text(
                            item.title,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 4.0),
                            child: Text(
                              isPharmacy ? l10n.favoritePharmacy : l10n.favoriteProduct,
                              style: TextStyle(
                                color: isPharmacy ? Colors.green.shade700 : Colors.blue.shade700,
                                fontWeight: FontWeight.w500,
                                fontSize: 13,
                              ),
                            ),
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              final favoriteItem = FavoriteEntity(
                                id: item.id,
                                title: item.title,
                                type: item.type,
                              );

                              context.read<FavoriteBloc>().add(
                                ToggleFavoriteEvent(favorite: favoriteItem),
                              );
                            },
                          ),
                          onTap: () {
                            if (isPharmacy) {
                              // Eczane detay
                            } else {
                              // 1. Ürün listesini ProductBloc'un state'inden alıyoruz
                              final productState = BlocProvider.of<ProductBloc>(context).state;

                              // 2. Eğer ürünler yüklüyse, favorideki ID ile eşleşen ürünü buluyoruz
                              ProductEntity? foundProduct;
                              if (productState is ProductLoaded) {
                                foundProduct = productState.products.firstWhere(
                                      (p) => p.id.toString() == item.id.toString(),
                                  orElse: () => ProductEntity(
                                    id: item.id,
                                    name: item.title,
                                    description: 'Detaylar yüklenemedi.',
                                    imageUrl: '',
                                    price: 0.0,
                                    stock: 0,
                                  ),
                                );
                              } else {
                                foundProduct = ProductEntity(
                                  id: item.id,
                                  name: item.title,
                                  description: 'Detayları görmek için ana sayfaya dönün.',
                                  imageUrl: '',
                                  price: 0.0,
                                  stock: 0,
                                );
                              }

                              // 3. Bulunan veya oluşturulan ürün ile detay sayfasına geçiyoruz
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ProductDetailView(product: foundProduct!),
                                ),
                              );
                            }
                          },
                        ),
                      );
                    },
                  );
                }
                if (favState is FavoriteErrorState) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Text(
                        'Hata:\n${favState.message}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.red,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        );
      },
    );
  }
}