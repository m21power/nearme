import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart' as get_it;
import 'package:nearme/features/auth/data/auth_repo_impl.dart';
import 'package:nearme/features/auth/domain/repository/auth_repository.dart';
import 'package:nearme/features/auth/domain/usecases/check_login_status_usecase.dart';
import 'package:nearme/features/auth/domain/usecases/log_out_usecase.dart';
import 'package:nearme/features/auth/domain/usecases/send_otp_usecase.dart';
import 'package:nearme/features/auth/domain/usecases/verify_otp_usecase.dart';
import 'package:nearme/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'core/network/network_info_impl.dart';

final sl = get_it.GetIt.instance;

Future<void> init() async {
  //auth
  //repository
  sl.registerLazySingleton<FirebaseFirestore>(() => FirebaseFirestore.instance);
  var sharedPreferencesInstance = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => sharedPreferencesInstance);
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl());
  sl.registerLazySingleton<http.Client>(() => http.Client());

  // repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepoImpl(
      sharedPreferences: sl<SharedPreferences>(),
      firestore: sl<FirebaseFirestore>(),
      networkInfo: sl<NetworkInfo>(),
    ),
  );
  // //usecases
  sl.registerLazySingleton<CheckLoginStatusUsecase>(
    () => CheckLoginStatusUsecase(authRepository: sl<AuthRepository>()),
  );
  sl.registerLazySingleton<SendOtpUsecase>(
    () => SendOtpUsecase(repository: sl<AuthRepository>()),
  );
  sl.registerLazySingleton<VerifyOtpUsecase>(
    () => VerifyOtpUsecase(repository: sl<AuthRepository>()),
  );
  sl.registerLazySingleton<LogOutUsecase>(
    () => LogOutUsecase(authRepository: sl<AuthRepository>()),
  );
  //bloc
  sl.registerFactory(
    () => AuthBloc(
      checkLoginStatusUsecase: sl<CheckLoginStatusUsecase>(),
      sendOtpUsecase: sl<SendOtpUsecase>(),
      verifyOtpUsecase: sl<VerifyOtpUsecase>(),
      logOutUsecase: sl<LogOutUsecase>(),
    ),
  );
}
