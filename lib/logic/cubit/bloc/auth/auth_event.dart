part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {}

final class AuthSignInRequested extends AuthEvent {
  final String email;
  final String password;
  AuthSignInRequested({required this.email, required this.password});
}

final class AuthLoggedIn extends AuthEvent {
  final User user;
  AuthLoggedIn({required this.user});
}

final class AuthSignUped extends AuthEvent {}

final class AuthLoggedOut extends AuthEvent {}
