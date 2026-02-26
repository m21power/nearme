part of 'auth_bloc.dart';

sealed class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

final class AuthInitial extends AuthState {}

final class AuthLoading extends AuthState {}

final class AuthOtpSent extends AuthState {
  final String email;

  const AuthOtpSent({required this.email});

  @override
  List<Object> get props => [email];
}

final class AuthOtpVerified extends AuthState {
  final String email;

  const AuthOtpVerified({required this.email});

  @override
  List<Object> get props => [email];
}

final class AuthLoginStatusChecked extends AuthState {
  final bool isLoggedIn;

  const AuthLoginStatusChecked({required this.isLoggedIn});

  @override
  List<Object> get props => [isLoggedIn];
}

final class AuthError extends AuthState {
  final String message;

  const AuthError({required this.message});

  @override
  List<Object> get props => [message];
}
