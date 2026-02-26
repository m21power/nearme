import 'package:dartz/dartz.dart';
import 'package:nearme/core/error/failure.dart';

import '../repository/auth_repository.dart';

class VerifyOtpUsecase {
  final AuthRepository repository;

  VerifyOtpUsecase({required this.repository});

  Future<Either<Failure, void>> call(String username, String otp) {
    return repository.verifyOtp(username, otp);
  }
}
