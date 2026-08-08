import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/login_usecase.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase loginUseCase;

  AuthBloc({required this.loginUseCase}) : super(AuthInitialState()) {
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
  }
}