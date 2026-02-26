part of 'auth_bloc.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class AuthSendOtpEvent extends AuthEvent {
  final String email;

  const AuthSendOtpEvent({required this.email});

  @override
  List<Object> get props => [email];
}

class AuthVerifyOtpEvent extends AuthEvent {
  final String email;
  final String otp;

  const AuthVerifyOtpEvent({required this.email, required this.otp});

  @override
  List<Object> get props => [email, otp];
}

class AuthCheckLoginStatusEvent extends AuthEvent {
  const AuthCheckLoginStatusEvent();

  @override
  List<Object> get props => [];
}

class AuthLogoutEvent extends AuthEvent {
  const AuthLogoutEvent();

  @override
  List<Object> get props => [];
}
