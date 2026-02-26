import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../repository/auth_repository.dart';

class SendOtpUsecase {
  final AuthRepository repository;

  SendOtpUsecase({required this.repository});

  Future<Either<Failure, void>> call(String username) {
    return repository.sendOtp(username);
  }
}
