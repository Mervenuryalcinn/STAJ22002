import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Tam paket yolları ile importlar
import 'package:lideatech_pharmacy_app/features/products/data/datasources/product_remote_datasource.dart';
import 'package:lideatech_pharmacy_app/features/products/data/repositories/product_repository_impl.dart' as prod_repo;
import 'package:lideatech_pharmacy_app/features/products/domain/usecases/get_products_usecase.dart';
import 'package:lideatech_pharmacy_app/features/products/presentation/bloc/product_bloc.dart';
import 'package:lideatech_pharmacy_app/features/products/presentation/bloc/product_event.dart';
import 'package:lideatech_pharmacy_app/features/products/presentation/views/product_list_view.dart';

import 'package:lideatech_pharmacy_app/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:lideatech_pharmacy_app/features/favorites/presentation/bloc/favorites_bloc.dart';

// Eczane Modülü Importları
import 'package:lideatech_pharmacy_app/features/pharmacy/presentation/bloc/pharmacy_bloc.dart';
import 'package:lideatech_pharmacy_app/features/pharmacy/domain/usecases/get_nearby_pharmacies_usecase.dart';
import 'package:lideatech_pharmacy_app/features/pharmacy/data/repositories/pharmacy_repository_impl.dart';

// Auth Modülü Importları
import 'package:lideatech_pharmacy_app/features/authentication/data/datasources/auth_remote_datasource.dart';
import 'package:lideatech_pharmacy_app/features/authentication/data/repositories/auth_repository_impl.dart';
import 'package:lideatech_pharmacy_app/features/authentication/domain/usecases/login_usecase.dart';
import 'package:lideatech_pharmacy_app/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:lideatech_pharmacy_app/features/authentication/presentation/views/login_view.dart';

import 'package:lideatech_pharmacy_app/core/network/dio_client.dart';
import 'package:lideatech_pharmacy_app/app/router/route_paths.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) => AuthBloc(
            loginUseCase: LoginUseCase(
              AuthRepositoryImpl(
                remoteDatasource: AuthRemoteDatasourceImpl(
                  dio: DioClient().dio,
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
        BlocProvider<FavoritesBloc>(
          create: (context) => FavoritesBloc(),
        ),
        BlocProvider<PharmacyBloc>(
          create: (context) => PharmacyBloc(
            getNearbyPharmaciesUseCase: GetNearbyPharmaciesUseCase(
              PharmacyRepositoryImpl(),
            ),
          ),
        ),
      ],
      child: MaterialApp(
        title: 'Eczane & E-Ticaret Uygulaması',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
        ),
        home: const LoginView(),
        // Rota tanımları eklendi, böylece /home hatası çözüldü
        routes: {
          RoutePaths.home: (context) => const ProductListView(),
        },
      ),
    );
  }
}