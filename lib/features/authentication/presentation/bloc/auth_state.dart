abstract class AuthState {}

class AuthInitialState extends AuthState {}
class AuthLoadingState extends AuthState {}

// Kullanıcı bilgilerini saklayacak şekilde güncellendi
class AuthSuccessState extends AuthState {
  final String userId;
  final String tckn;
  final String email;
  final String name;

  AuthSuccessState({
    required this.userId,
    required this.tckn,
    required this.email,
    required this.name,
  });
}

class AuthErrorState extends AuthState {
  final String message;
  AuthErrorState(this.message);
}