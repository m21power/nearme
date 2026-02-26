import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:nearme/features/auth/domain/usecases/check_login_status_usecase.dart';
import 'package:nearme/features/auth/domain/usecases/log_out_usecase.dart';
import 'package:nearme/features/auth/domain/usecases/send_otp_usecase.dart';
import 'package:nearme/features/auth/domain/usecases/verify_otp_usecase.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final CheckLoginStatusUsecase checkLoginStatusUsecase;
  final SendOtpUsecase sendOtpUsecase;
  final VerifyOtpUsecase verifyOtpUsecase;
  final LogOutUsecase logOutUsecase;

  AuthBloc({
    required this.checkLoginStatusUsecase,
    required this.sendOtpUsecase,
    required this.verifyOtpUsecase,
    required this.logOutUsecase,
  }) : super(AuthInitial()) {
    on<AuthSendOtpEvent>((event, emit) async {
      emit(AuthLoading());
      final result = await sendOtpUsecase(event.email);
      result.fold(
        (failure) => emit(AuthError(message: failure.message)),
        (_) => emit(AuthOtpSent(email: event.email)),
      );
    });

    on<AuthVerifyOtpEvent>((event, emit) async {
      emit(AuthLoading());
      final result = await verifyOtpUsecase(event.email, event.otp);
      result.fold(
        (failure) => emit(AuthError(message: failure.message)),
        (_) => emit(AuthOtpVerified(email: event.email)),
      );
    });

    on<AuthCheckLoginStatusEvent>((event, emit) async {
      emit(AuthLoading());
      final result = await checkLoginStatusUsecase();
      result.fold(
        (failure) => emit(AuthError(message: failure.message)),
        (_) => emit(AuthLoginStatusChecked(isLoggedIn: true)),
      );
    });
    on<AuthLogoutEvent>((event, emit) async {
      await logOutUsecase();
      emit(AuthLoginStatusChecked(isLoggedIn: false));
    });
  }
}
