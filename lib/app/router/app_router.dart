import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/authentication/presentation/views/login_view.dart';
import '../../features/cart/presentation/views/cart_view.dart';
import '../../features/pharmacy/presentation/views/pharmacy_list_view.dart';
import '../../features/products/presentation/views/product_list_view.dart';
import '../../features/products/presentation/views/product_detail_view.dart';
import '../../features/products/domain/entities/product_entity.dart';
import '../../features/cart/presentation/views/checkout_view.dart';
import '../../features/products/presentation/views/product_pharmacies_view.dart';
import '../../features/order/presentation/views/orders_view.dart';
import '../../features/order/presentation/views/order_detail_view.dart';
import '../../features/profile/presentation/views/profile_view.dart';
import '../../features/favorites/presentation/views/favorites_view.dart';
import 'route_names.dart';
import 'route_paths.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: RoutePaths.home,

    // İleride buraya auth kontrolü (User Guard) ekleyebilirsin
    redirect: (context, state) {
      return null;
    },

    routes: [
      GoRoute(
        path: RoutePaths.home,
        name: RouteNames.home,
        builder: (context, state) => const ProductListView(),
      ),

      GoRoute(
        path: RoutePaths.login,
        name: RouteNames.login,
        builder: (context, state) => LoginView(),
      ),

      GoRoute(
        path: RoutePaths.cart,
        name: RouteNames.cart,
        builder: (context, state) => const CartView(),
      ),

      GoRoute(
        path: RoutePaths.pharmacies,
        name: RouteNames.pharmacies,
        builder: (context, state) => const PharmacyListView(),
      ),

      // DÜZELTME BURADA: CheckoutView parametreleri extra üzerinden dinamik alınıyor
      GoRoute(
        path: RoutePaths.checkout,
        name: RouteNames.checkout,
        builder: (context, state) {
          // Eğer dışarıdan Map olarak city/district gönderildiyse alınır,
          // gönderilmediyse konum servisinden / varsayılan değere atanır
          final extraData = state.extra as Map<String, String>?;
          final district = extraData?['district'] ?? 'Kırıkhan';
          final city = extraData?['city'] ?? 'Hatay';

          return CheckoutView(
            currentDistrict: district,
            currentCity: city,
          );
        },
      ),

      GoRoute(
        path: '/product-pharmacies/:productId',
        builder: (context, state) {
          final productId = state.pathParameters['productId']!;
          final productName = state.extra as String? ?? 'İlaç';
          return ProductPharmaciesView(productId: productId, productName: productName);
        },
      ),
      GoRoute(
        path: '/orders',
        builder: (context, state) => const OrdersView(),
      ),

      GoRoute(
        path: '/orders/:id',
        builder: (context, state) {
          final orderId = state.pathParameters['id']!;
          return OrderDetailView(orderId: orderId);
        },
      ),
      GoRoute(
        path: '/product-detail',
        builder: (context, state) {
          final product = state.extra as ProductEntity;
          return ProductDetailView(product: product);
        },
      ),
      GoRoute(
        path: RoutePaths.profile,
        builder: (context, state) => const ProfileView(),
      ),
      GoRoute(
        path: '/favorites',
        builder: (context, state) => const FavoritesView(),
      ),
    ],

    errorBuilder: (context, state) => const Scaffold(
      body: Center(
        child: Text("404 - Sayfa Bulunamadı"),
      ),
    ),
  );
}