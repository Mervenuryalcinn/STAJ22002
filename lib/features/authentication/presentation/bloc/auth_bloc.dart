import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/register_usecase.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase loginUseCase;
  final RegisterUseCase registerUseCase;

  AuthBloc({
    required this.loginUseCase,
    required this.registerUseCase,
  }) : super(AuthInitialState()) {

    // 1. GİRİŞ YAPMA (LOGIN) İŞLEMİ
    on<LoginRequestedEvent>((event, emit) async {
      emit(AuthLoadingState());

      final result = await loginUseCase(
        event.email,
        event.password,
      );

      result.fold(
            (failure) {
          emit(
            AuthErrorState(
              failure.message,
            ),
          );
        },
            (user) {
          print("========================================");
          print("🔐 LOGIN BAŞARILI");
          print("👤 USER ID : ${user.id}");
          print("🪪 TCKN    : ${user.tckn}");
          print("📧 EMAIL   : ${user.email}");
          print("👤 NAME    : ${user.name}");
          print("========================================");

          emit(
            AuthSuccessState(
              userId: user.id,
              tckn: user.tckn,
              email: user.email,
              name: user.name,
            ),
          );
        },
      );
    });

    // 2. KAYIT OLMA (REGISTER) İŞLEMİ
    on<RegisterRequestedEvent>((event, emit) async {
      emit(AuthLoadingState());

      final result = await registerUseCase(
        event.tckn,
        event.name,
        event.email,
        event.password,
      );

      result.fold(
            (failure) {
          emit(
            AuthErrorState(
              failure.message,
            ),
          );
        },
            (user) {
          print("========================================");
          print("📝 KAYIT VE GİRİŞ BAŞARILI");
          print("👤 USER ID : ${user.id}");
          print("🪪 TCKN    : ${user.tckn}");
          print("📧 EMAIL   : ${user.email}");
          print("👤 NAME    : ${user.name}");
          print("========================================");

          emit(
            AuthSuccessState(
              userId: user.id,
              tckn: user.tckn,
              email: user.email,
              name: user.name,
            ),
          );
        },
      );
    });

    // 3. ÇIKIŞ YAPMA İŞLEMİ
    on<LogoutRequestedEvent>((event, emit) async {
      print("🚪 ÇIKIŞ YAPILIYOR...");
      emit(AuthInitialState());
    });
  }
}