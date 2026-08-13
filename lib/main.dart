import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'app/router/app_router.dart';
import 'package:lideatech_pharmacy_app/core/theme/theme_cubit.dart';

// Paket importları...
import 'package:lideatech_pharmacy_app/features/products/data/datasources/product_remote_datasource.dart';
import 'package:lideatech_pharmacy_app/features/products/data/repositories/product_repository_impl.dart' as prod_repo;
import 'package:lideatech_pharmacy_app/features/products/domain/usecases/get_products_usecase.dart';
import 'package:lideatech_pharmacy_app/features/products/presentation/bloc/product_bloc.dart';
import 'package:lideatech_pharmacy_app/features/products/presentation/bloc/product_event.dart';

// Cart (Sepet) Katmanı Importları
import 'package:lideatech_pharmacy_app/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:lideatech_pharmacy_app/features/cart/data/datasources/cart_remote_datasource.dart';
import 'package:lideatech_pharmacy_app/features/cart/data/repositories/cart_repository_impl.dart';
import 'package:lideatech_pharmacy_app/features/cart/domain/usecases/get_cart_items_usecase.dart';
import 'package:lideatech_pharmacy_app/features/cart/domain/usecases/save_cart_usecase.dart';



import 'package:lideatech_pharmacy_app/features/favorites/presentation/bloc/favorite_bloc.dart';
import 'package:lideatech_pharmacy_app/features/favorites/data/repositories/favorite_repository_impl.dart';
import 'package:lideatech_pharmacy_app/features/favorites/data/datasources/favorite_remote_datasource.dart';
import 'package:lideatech_pharmacy_app/features/authentication/presentation/bloc/auth_state.dart';

import 'package:lideatech_pharmacy_app/features/order/presentation/bloc/order_bloc.dart';
import 'package:lideatech_pharmacy_app/features/order/domain/usecases/get_orders_usecase.dart';
import 'package:lideatech_pharmacy_app/features/order/data/repositories/order_repository_impl.dart';
import 'package:lideatech_pharmacy_app/features/order/data/datasources/order_remote_datasource.dart';

import 'package:lideatech_pharmacy_app/features/pharmacy/presentation/bloc/pharmacy_bloc.dart';
import 'package:lideatech_pharmacy_app/features/pharmacy/domain/usecases/get_nearby_pharmacies_usecase.dart';
import 'package:lideatech_pharmacy_app/features/pharmacy/data/repositories/pharmacy_repository_impl.dart';
import 'package:lideatech_pharmacy_app/features/pharmacy/domain/usecases/get_pharmacies_for_cart_usecase.dart';

import 'package:lideatech_pharmacy_app/features/authentication/data/datasources/auth_remote_datasource.dart';
import 'package:lideatech_pharmacy_app/features/authentication/data/repositories/auth_repository_impl.dart';
import 'package:lideatech_pharmacy_app/features/authentication/domain/usecases/login_usecase.dart';
import 'package:lideatech_pharmacy_app/features/authentication/domain/usecases/register_usecase.dart';
import 'package:lideatech_pharmacy_app/features/authentication/presentation/bloc/auth_bloc.dart';

import 'package:lideatech_pharmacy_app/core/network/dio_client.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:lideatech_pharmacy_app/l10n/app_localizations.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  // Herhangi bir sayfadan (örn. LanguageBottomSheet içinden) dili tetiklemek için statik metot
  static void setLocale(BuildContext context, Locale newLocale) {
    _MyAppState? state = context.findAncestorStateOfType<_MyAppState>();
    state?.setLocale(newLocale);
  }

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale? _locale; // Başlangıçta cihazın yerel dilini kullanır

  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ThemeCubit>(
      create: (context) => ThemeCubit(),
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeMode) {
          return MaterialApp.router(
            title: 'Eczane & E-Ticaret Uygulaması',
            debugShowCheckedModeBanner: false,

            // Dil Ayarları Bağlantısı:
            locale: _locale,
            localizationsDelegates:[
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('en', ''), // İngilizce
              Locale('tr', ''), // Türkçe
            ],

            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue, brightness: Brightness.light),
              useMaterial3: true,
              brightness: Brightness.light,
            ),
            darkTheme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue, brightness: Brightness.dark),
              useMaterial3: true,
              brightness: Brightness.dark,
            ),
            themeMode: themeMode,
            routerConfig: AppRouter.router,
            builder: (context, routerChild) {
              return MultiBlocProvider(
                providers: [
                  BlocProvider<AuthBloc>(
                    create: (context) {
                      final authRepository = AuthRepositoryImpl(
                        remoteDatasource: AuthRemoteDatasourceImpl(
                          dioClient: DioClient(),
                        ),
                      );
                      return AuthBloc(
                        loginUseCase: LoginUseCase(authRepository),
                        registerUseCase: RegisterUseCase(authRepository),
                      );
                    },
                  ),
                  BlocProvider<ProductBloc>(
                    create: (context) => ProductBloc(
                      getProductsUseCase: GetProductsUseCase(
                        prod_repo.ProductRepositoryImpl(
                          remoteDataSource: ProductRemoteDatasourceImpl(
                            dioClient: DioClient(),
                          ),
                        ),
                      ),
                    )..add(FetchProductsEvent()),
                  ),
                  // İlgili use case'lerin importlarını main.dart'ın en üstüne eklemeyi unutma:
// import 'package:lideatech_pharmacy_app/features/cart/domain/usecases/get_cart_items_usecase.dart';
// import 'package:lideatech_pharmacy_app/features/cart/domain/usecases/save_cart_usecase.dart';

                  BlocProvider<CartBloc>(
                    create: (context) {
                      final authState = context.read<AuthBloc>().state;
                      final String userId = authState is AuthSuccessState ? authState.userId : "1";

                      // 1. Önce repository'yi oluşturuyoruz
                      final cartRepository = CartRepositoryImpl(
                        remoteDataSource: CartRemoteDataSourceImpl(
                          dioClient: DioClient(),
                        ),
                        userId: userId,
                      );

                      // 2. Ardından use case'leri ve Bloc'u başlatıyoruz
                      return CartBloc(
                        getCartItemsUseCase: GetCartItemsUseCase(cartRepository),
                        saveCartUseCase: SaveCartUseCase(cartRepository),
                      );
                    },
                  ),
                  BlocProvider<FavoriteBloc>(
                    create: (context) {
                      final authState = context.read<AuthBloc>().state;
                      final String userId = authState is AuthSuccessState ? authState.userId : "";

                      print("🎯 FAVORİLER İÇİN GELEN USER ID: $userId"); // Burayı ekle ve konsola bak!

                      return FavoriteBloc(
                        repository: FavoriteRepositoryImpl(
                          remoteDataSource: FavoriteRemoteDataSourceImpl(
                            dioClient: DioClient(),
                          ),
                          currentUserId: userId,
                        ),
                      );
                    },
                  ),
                  BlocProvider<OrderBloc>(
                    create: (context) {
                      final orderRepository = OrderRepositoryImpl(
                        remoteDataSource: OrderRemoteDataSourceImpl(
                          dio: DioClient().dio,
                        ),
                      );
                      return OrderBloc(
                        orderRepository: orderRepository,
                        getOrdersUseCase: GetOrdersUseCase(orderRepository),
                      );
                    },
                  ),
                  BlocProvider<PharmacyBloc>(
                    create: (context) {
                      final pharmacyRepository = PharmacyRepositoryImpl(
                        dioClient: DioClient(),
                      );
                      return PharmacyBloc(
                        getNearbyPharmaciesUseCase: GetNearbyPharmaciesUseCase(pharmacyRepository),
                        getPharmaciesForCartUseCase: GetPharmaciesForCartUseCase(pharmacyRepository),
                        pharmacyRepository: pharmacyRepository,
                      );
                    },
                  ),
                ],
                child: routerChild!,
              );
            },
          );
        },
      ),
    );
  }
}