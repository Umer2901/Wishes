part of 'authentication_cubit.dart';

@immutable
sealed class AuthenticationState extends Equatable {
  const AuthenticationState();

  @override
  List<Object> get props => [];
}

final class AuthenticationInitial extends AuthenticationState {}

final class AuthenticationLoading extends AuthenticationState {}

final class SendedCode extends AuthenticationState {}

final class VerifyCode extends AuthenticationState {}

final class Authenticated extends AuthenticationState {
  final User? user;

  const Authenticated({required this.user});
}

final class RegisterAuthentication extends AuthenticationState {
  final User? user;

  const RegisterAuthentication({required this.user});
}

final class Unauthenticated extends AuthenticationState {}

final class AuthenticationError extends AuthenticationState {
  final String error;

  const AuthenticationError({required this.error});
}
