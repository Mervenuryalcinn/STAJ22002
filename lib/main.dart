import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'app/router/app_router.dart';
// Tam paket yolları ile importlar
import 'package:lideatech_pharmacy_app/features/products/data/datasources/product_remote_datasource.dart';
import 'package:lideatech_pharmacy_app/features/products/data/repositories/product_repository_impl.dart' as prod_repo;
import 'package:lideatech_pharmacy_app/features/products/domain/usecases/get_products_usecase.dart';
import 'package:lideatech_pharmacy_app/features/products/presentation/bloc/product_bloc.dart';
import 'package:lideatech_pharmacy_app/features/products/presentation/bloc/product_event.dart';

import 'package:lideatech_pharmacy_app/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:lideatech_pharmacy_app/features/favorites/presentation/bloc/favorite_bloc.dart';
import 'package:lideatech_pharmacy_app/features/favorites/data/repositories/favorite_repository.dart';

// Sipariş Modülü Importları
import 'package:lideatech_pharmacy_app/features/order/presentation/bloc/order_bloc.dart';
import 'package:lideatech_pharmacy_app/features/order/domain/usecases/get_orders_usecase.dart';
import 'package:lideatech_pharmacy_app/features/order/data/repositories/order_repository_impl.dart';

// Eczane Modülü Importları
import 'package:lideatech_pharmacy_app/features/pharmacy/presentation/bloc/pharmacy_bloc.dart';
import 'package:lideatech_pharmacy_app/features/pharmacy/domain/usecases/get_nearby_pharmacies_usecase.dart';
import 'package:lideatech_pharmacy_app/features/pharmacy/data/repositories/pharmacy_repository_impl.dart';
import 'package:lideatech_pharmacy_app/features/pharmacy/domain/usecases/get_pharmacies_for_cart_usecase.dart';

// Auth Modülü Importları
import 'package:lideatech_pharmacy_app/features/authentication/data/datasources/auth_remote_datasource.dart';
import 'package:lideatech_pharmacy_app/features/authentication/data/repositories/auth_repository_impl.dart';
import 'package:lideatech_pharmacy_app/features/authentication/domain/usecases/login_usecase.dart';
import 'package:lideatech_pharmacy_app/features/authentication/presentation/bloc/auth_bloc.dart';

import 'package:lideatech_pharmacy_app/core/network/dio_client.dart';

// Tema Yönetimi İçin Cubit
class ThemeCubit extends Cubit<bool> {
  ThemeCubit() : super(false); // Başlangıçta aydınlık mod (false)

  void toggleTheme(bool isDark) => emit(isDark);
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // Tema Yönetimi İçin Cubit
        BlocProvider<ThemeCubit>(
          create: (context) => ThemeCubit(),
        ),
        BlocProvider<AuthBloc>(
          create: (context) => AuthBloc(
            loginUseCase: LoginUseCase(
              AuthRepositoryImpl(
                remoteDatasource: AuthRemoteDatasourceImpl(
                  dioClient: DioClient(),
                ),
              ),
            ),
          ),
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
        BlocProvider<CartBloc>(
          create: (context) => CartBloc(),
        ),
        BlocProvider<FavoriteBloc>(
          create: (context) => FavoriteBloc(
            repository: FavoriteRepositoryImpl(),
          ),
        ),
        BlocProvider<OrderBloc>(
          create: (context) => OrderBloc(
            getOrdersUseCase: GetOrdersUseCase(
              OrderRepositoryImpl(dio: DioClient().dio),
            ),
            orderRepository: OrderRepositoryImpl(
              dio: DioClient().dio,
            ),
          ),
        ),
        BlocProvider<PharmacyBloc>(
          create: (context) {
            final pharmacyRepository = PharmacyRepositoryImpl(
              dioClient: DioClient(),
            );

            return PharmacyBloc(
              getNearbyPharmaciesUseCase: GetNearbyPharmaciesUseCase(
                pharmacyRepository,
              ),
              getPharmaciesForCartUseCase: GetPharmaciesForCartUseCase(
                pharmacyRepository,
              ),
              pharmacyRepository: pharmacyRepository,
            );
          },
        ),
      ],
      // Kilitlenmeyi önlemek için tema dinleyicisi doğrudan MaterialApp.router seviyesinde yapılandırıldı
      child: Builder(
        builder: (context) {
          final isDarkMode = context.watch<ThemeCubit>().state;
          return MaterialApp.router(
            title: 'Eczane & E-Ticaret Uygulaması',
            debugShowCheckedModeBanner: false,
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
            themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
            routerConfig: AppRouter.router,
          );
        },
      ),
    );
  }
}