abstract class AuthEvent {}

class LoginRequestedEvent extends AuthEvent {
  final String email;
  final String password;

  LoginRequestedEvent({required this.email, required this.password});
}