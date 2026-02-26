import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';

abstract class AuthRepository {
  Future<Either<Failure, void>> checkLoginStatus();
  Future<Either<Failure, void>> sendOtp(String phoneNumber);
  Future<Either<Failure, void>> verifyOtp(String phoneNumber, String otp);
  Future<void> logout();
}
