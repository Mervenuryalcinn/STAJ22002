abstract class AuthEvent {}

class LoginRequestedEvent extends AuthEvent {
  final String email;
  final String password;

  LoginRequestedEvent({required this.email, required this.password});
}
class LogoutRequestedEvent extends AuthEvent {}

class RegisterRequestedEvent extends AuthEvent {
  final int tckn;
  final String name;
  final String email;
  final String password;

  RegisterRequestedEvent({
    required this.tckn,
    required this.name,
    required this.email,
    required this.password,
  });
}