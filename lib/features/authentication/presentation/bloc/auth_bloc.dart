import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/login_usecase.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase loginUseCase;

  AuthBloc({required this.loginUseCase}) : super(AuthInitialState()) {
    on<LoginRequestedEvent>((event, emit) async {
      emit(AuthLoadingState());
      final result = await loginUseCase(event.email, event.password);

      result.fold(
            (failure) => emit(AuthErrorState(failure.message)),
            (user) => emit(AuthSuccessState()),
      );
    });
  }
}