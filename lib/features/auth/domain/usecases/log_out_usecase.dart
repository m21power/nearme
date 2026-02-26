import 'package:nearme/features/auth/domain/repository/auth_repository.dart';

class LogOutUsecase {
  final AuthRepository authRepository;
  LogOutUsecase({required this.authRepository});
  Future<void> call() {
    return authRepository.logout();
  }
}
