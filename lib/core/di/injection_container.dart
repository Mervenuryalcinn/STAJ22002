import 'package:get_it/get_it.dart';
// Gerekli importlar projene göre eklenecektir
// Örn: import '../../features/authentication/domain/usecases/login_usecase.dart';
// Örn: import '../../features/authentication/presentation/bloc/auth_bloc.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  // --- BLOC'LAR ---
  // sl.registerFactory(() => AuthBloc(loginUseCase: sl()));

  // --- USE CASE'LER ---
  // sl.registerLazySingleton(() => LoginUseCase(sl()));

  // --- REPOSITORY'LER ---
  // sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(sl()));

  // --- DATA SOURCES ---
  // sl.registerLazySingleton<AuthRemoteDataSource>(() => AuthRemoteDataSourceImpl(sl()));

  // --- EXTERNAL (Dio, SharedPreferences vb.) ---
  // sl.registerLazySingleton(() => DioClient().dio);
}