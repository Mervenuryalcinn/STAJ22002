import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/authentication/presentation/views/login_view.dart';
import 'route_names.dart';
import 'route_paths.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: RoutePaths.splash,
    // Auth Guard (Yönlendirme Mantığı)
    redirect: (context, state) {
      final bool isAuthenticated = false; // Şimdilik false (giriş yapılmadı varsayalım)
      final bool isLoggingIn = state.matchedLocation == RoutePaths.login;
      final bool isSplash = state.matchedLocation == RoutePaths.splash;

      // Eğer splash sayfasındaysa dokunma
      if (isSplash) return null;

      // Giriş yapmadıysa ve login sayfasında değilse, login'e at
      if (!isAuthenticated && !isLoggingIn) {
        return RoutePaths.login;
      }

      return null;
    },
    routes: [
      GoRoute(
        path: RoutePaths.splash,
        name: RouteNames.splash,
        builder: (context, state) => const Scaffold(
          body: Center(child: Text('Splash Ekranı (Yükleniyor...)')),
        ),
      ),
      GoRoute(
        path: RoutePaths.login,
        name: RouteNames.login,
        builder: (context, state) => const LoginView(),
      ),
      GoRoute(
        path: RoutePaths.home,
        name: RouteNames.home,
        builder: (context, state) => const Scaffold(
          body: Center(child: Text('Ana Sayfa (Korumalı Alan)')),
        ),
      ),
    ],
    errorBuilder: (context, state) => const Scaffold(
      body: Center(child: Text('404 - Sayfa Bulunamadı')),
    ),
  );
}