import 'package:dartz/dartz.dart';
import 'package:nearme/core/error/failure.dart';
import 'package:nearme/features/auth/domain/repository/auth_repository.dart';

class CheckLoginStatusUsecase {
  final AuthRepository authRepository;

  CheckLoginStatusUsecase({required this.authRepository});

  Future<Either<Failure, void>> call() {
    return authRepository.checkLoginStatus();
  }
}
