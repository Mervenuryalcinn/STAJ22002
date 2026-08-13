import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/authentication/presentation/views/login_view.dart';
import '../../features/authentication/presentation/views/register_view.dart';

import '../../features/cart/presentation/views/cart_view.dart';
import '../../features/pharmacy/presentation/views/pharmacy_list_view.dart';
import '../../features/products/presentation/views/product_list_view.dart';
import '../../features/pharmacy/presentation/views/pharmacy_dashboard_view.dart';
import '../../features/pharmacy/presentation/views/pharmacy_login_view.dart';
import '../../features/pharmacy/presentation/views/pharmacy_register_view.dart';

import '../../features/products/presentation/views/product_detail_view.dart';
import '../../features/products/domain/entities/product_entity.dart';

import '../../features/cart/presentation/views/checkout_view.dart';
import '../../features/products/presentation/views/product_pharmacies_view.dart';

import '../../features/order/presentation/views/orders_view.dart';
import '../../features/order/presentation/views/order_detail_view.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../features/order/presentation/bloc/order_bloc.dart';
import '../../features/authentication/presentation/bloc/auth_bloc.dart';
import '../../features/authentication/presentation/bloc/auth_state.dart';

import '../../features/profile/presentation/views/profile_view.dart';
import '../../features/favorites/presentation/views/favorites_view.dart';
import 'route_names.dart';
import 'route_paths.dart';
import 'package:lideatech_pharmacy_app/l10n/app_localizations.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: RoutePaths.home,

    // DÖKÜMAN KRİTERİ: Giriş yapılmadan korumalı sayfalara erişimi engelleme (AuthBloc tabanlı yönlendirme)
    redirect: (context, state) {
      final authState = context.read<AuthBloc>().state;
      final isLoggedIn = authState is AuthSuccessState;

      // Korunması gereken rotalar
      final protectedPaths = [
        RoutePaths.cart,
        RoutePaths.checkout,
        RoutePaths.profile,
        '/orders',
      ];

      final isGoingToProtectedPage = protectedPaths.any((path) => state.matchedLocation.startsWith(path));

      // Eğer kullanıcı giriş yapmamışsa ve korumalı bir sayfaya girmek istiyorsa Login'e yönlendir
      if (!isLoggedIn && isGoingToProtectedPage) {
        return RoutePaths.login;
      }

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
        path: RoutePaths.register,
        builder: (context, state) => const RegisterView(),
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
      GoRoute(
        path: '/pharmacy-login',
        builder: (context, state) => const PharmacyLoginView(),
      ),
      GoRoute(
        path: '/pharmacy-panel',
        builder: (context, state) {
          final int pharmacyId = int.tryParse(state.uri.queryParameters['id'] ?? '1') ?? 1;
          return PharmacyDashboardView(pharmacyId: pharmacyId);
        },
      ),
      GoRoute(
        path: RoutePaths.pharmacyRegister,
        builder: (context, state) => const PharmacyRegisterView(),
      ),

      GoRoute(
        path: RoutePaths.checkout,
        name: RouteNames.checkout,
        builder: (context, state) {
          final extraData = state.extra as Map<String, String>?;
          final district = extraData?['district'] ?? 'İskenderun';
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
          return BlocProvider.value(
            value: context.read<OrderBloc>(),
            child: OrderDetailView(orderId: orderId),
          );
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

    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text(AppLocalizations.of(context)?.notFound ?? "404 - Sayfa Bulunamadı"),
      ),
    ),
  );
}