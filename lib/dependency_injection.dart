import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart' as get_it;
import 'package:nearme/features/auth/data/auth_repo_impl.dart';
import 'package:nearme/features/auth/domain/repository/auth_repository.dart';
import 'package:nearme/features/auth/domain/usecases/check_login_status_usecase.dart';
import 'package:nearme/features/auth/domain/usecases/log_out_usecase.dart';
import 'package:nearme/features/auth/domain/usecases/send_otp_usecase.dart';
import 'package:nearme/features/auth/domain/usecases/verify_otp_usecase.dart';
import 'package:nearme/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:nearme/features/home/data/home_repo_impl.dart';
import 'package:nearme/features/home/data/story_repo_impl.dart';
import 'package:nearme/features/home/domain/repository/home_repository.dart';
import 'package:nearme/features/home/domain/usecases/Post/comment_on_post_usecase.dart';
import 'package:nearme/features/home/domain/usecases/Post/create_post_usecase.dart';
import 'package:nearme/features/home/domain/usecases/Post/delete_comment_usecase.dart';
import 'package:nearme/features/home/domain/usecases/Post/delete_post_usecase.dart';
import 'package:nearme/features/home/domain/usecases/Post/fetch_comment_usecase.dart';
import 'package:nearme/features/home/domain/usecases/Post/fetch_post_usecase.dart';
import 'package:nearme/features/home/domain/usecases/Post/like_post_usecase.dart';
import 'package:nearme/features/home/domain/usecases/Story/create_story_usecase.dart';
import 'package:nearme/features/home/domain/usecases/Story/delete_story_usecase.dart';
import 'package:nearme/features/home/domain/usecases/Story/fetch_story_usecase.dart';
import 'package:nearme/features/home/domain/usecases/Story/fetch_viewer_usecase.dart';
import 'package:nearme/features/home/domain/usecases/Story/like_story_usecase.dart';
import 'package:nearme/features/home/domain/usecases/Story/view_story_usecase.dart';
import 'package:nearme/features/home/presentation/PostBlock/home_bloc.dart';
import 'package:nearme/features/home/presentation/StoryBlock/story_bloc.dart';
import 'package:nearme/features/profile/data/profile_repo_impl.dart';
import 'package:nearme/features/profile/domain/repository/profile_repository.dart';
import 'package:nearme/features/profile/domain/usecases/update_banner_image_usecase.dart';
import 'package:nearme/features/profile/domain/usecases/update_profile_image_usecase.dart';
import 'package:nearme/features/profile/domain/usecases/update_user_info_usecase.dart';
import 'package:nearme/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'core/network/network_info_impl.dart';
import 'features/home/domain/repository/story_repository.dart';

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

  // Profile
  //repository
  sl.registerLazySingleton<ProfileRepository>(
    () => ProfileRepoImpl(
      firestore: sl<FirebaseFirestore>(),
      sharedPreferences: sl<SharedPreferences>(),
      networkInfo: sl<NetworkInfo>(),
    ),
  );
  // usecase
  sl.registerLazySingleton<UpdateProfileImageUsecase>(
    () => UpdateProfileImageUsecase(profileRepository: sl<ProfileRepository>()),
  );
  sl.registerLazySingleton<UpdateBannerImageUsecase>(
    () => UpdateBannerImageUsecase(repository: sl<ProfileRepository>()),
  );
  sl.registerLazySingleton<UpdateUserInfoUsecase>(
    () => UpdateUserInfoUsecase(profileRepository: sl<ProfileRepository>()),
  );
  // bloc

  sl.registerFactory(
    () => ProfileBloc(
      updateProfileImageUsecase: sl<UpdateProfileImageUsecase>(),
      updateBannerImageUsecase: sl<UpdateBannerImageUsecase>(),
      updateUserInfoUsecase: sl<UpdateUserInfoUsecase>(),
    ),
  );

  // Home

  // repository
  sl.registerLazySingleton<HomeRepository>(
    () => HomeRepoImpl(
      firestore: sl<FirebaseFirestore>(),
      sharedPreferences: sl<SharedPreferences>(),
      networkInfo: sl<NetworkInfo>(),
    ),
  );
  // usecase
  sl.registerLazySingleton<CreatePostUsecase>(
    () => CreatePostUsecase(homeRepository: sl<HomeRepository>()),
  );
  sl.registerLazySingleton<FetchPostUsecase>(
    () => FetchPostUsecase(homeRepository: sl<HomeRepository>()),
  );
  sl.registerLazySingleton<LikePostUsecase>(
    () => LikePostUsecase(homeRepository: sl<HomeRepository>()),
  );
  sl.registerLazySingleton<CommentOnPostUsecase>(
    () => CommentOnPostUsecase(homeRepository: sl<HomeRepository>()),
  );
  sl.registerLazySingleton<FetchCommentUsecase>(
    () => FetchCommentUsecase(homeRepository: sl<HomeRepository>()),
  );
  sl.registerLazySingleton<DeleteCommentUsecase>(
    () => DeleteCommentUsecase(homeRepository: sl<HomeRepository>()),
  );
  sl.registerLazySingleton<DeletePostUsecase>(
    () => DeletePostUsecase(homeRepository: sl<HomeRepository>()),
  );
  // bloc
  sl.registerFactory(
    () => HomeBloc(
      createPostUsecase: sl<CreatePostUsecase>(),
      fetchPostUsecase: sl<FetchPostUsecase>(),
      likePostUsecase: sl<LikePostUsecase>(),
      commentOnPostUsecase: sl<CommentOnPostUsecase>(),
      fetchCommentsUsecase: sl<FetchCommentUsecase>(),
      deleteCommentUsecase: sl<DeleteCommentUsecase>(),
      deletePostUsecase: sl<DeletePostUsecase>(),
    ),
  );

  // Story
  // repository
  sl.registerLazySingleton<StoryRepository>(
    () => StoryRepoImpl(
      firestore: sl<FirebaseFirestore>(),
      sharedPreferences: sl<SharedPreferences>(),
      networkInfo: sl<NetworkInfo>(),
    ),
  );

  // usecases
  sl.registerLazySingleton<ViewStoryUsecase>(
    () => ViewStoryUsecase(storyRepository: sl<StoryRepository>()),
  );
  sl.registerLazySingleton<DeleteStoryUsecase>(
    () => DeleteStoryUsecase(storyRepository: sl<StoryRepository>()),
  );
  sl.registerLazySingleton<CreateStoryUsecase>(
    () => CreateStoryUsecase(storyRepository: sl<StoryRepository>()),
  );
  sl.registerLazySingleton<FetchStoryUsecase>(
    () => FetchStoryUsecase(storyRepository: sl<StoryRepository>()),
  );
  sl.registerLazySingleton<FetchViewerUseCase>(
    () => FetchViewerUseCase(sl<StoryRepository>()),
  );
  sl.registerLazySingleton<LikeStoryUsecase>(
    () => LikeStoryUsecase(storyRepository: sl<StoryRepository>()),
  );
  // Bloc
  sl.registerFactory<StoryBloc>(
    () => StoryBloc(
      viewStoryUsecase: sl<ViewStoryUsecase>(),
      deleteStoryUsecase: sl<DeleteStoryUsecase>(),
      createStoryUsecase: sl<CreateStoryUsecase>(),
      fetchStoryUsecase: sl<FetchStoryUsecase>(),
      fetchViewerUsecase: sl<FetchViewerUseCase>(),
      likeStoryUsecase: sl<LikeStoryUsecase>(),
    ),
  );
}
