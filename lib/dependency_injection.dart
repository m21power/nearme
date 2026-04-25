import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:get_it/get_it.dart' as get_it;
import 'package:nearme/features/auth/data/auth_repo_impl.dart';
import 'package:nearme/features/auth/domain/repository/auth_repository.dart';
import 'package:nearme/features/auth/domain/usecases/check_login_status_usecase.dart';
import 'package:nearme/features/auth/domain/usecases/log_out_usecase.dart';
import 'package:nearme/features/auth/domain/usecases/send_otp_usecase.dart';
import 'package:nearme/features/auth/domain/usecases/verify_otp_usecase.dart';
import 'package:nearme/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:nearme/features/chat/data/repository/chat_repo_impl.dart';
import 'package:nearme/features/chat/domain/repository/chat_repository.dart';
import 'package:nearme/features/chat/domain/usecases/get_chat_message_usecase.dart';
import 'package:nearme/features/chat/domain/usecases/get_user_chats_usecase.dart';
import 'package:nearme/features/chat/domain/usecases/mark_as_read_usecase.dart';
import 'package:nearme/features/chat/domain/usecases/send_message_usecase.dart';
import 'package:nearme/features/chat/presentation/bloc/chat_bloc.dart';
import 'package:nearme/features/home/data/connection_repo_impl.dart';
import 'package:nearme/features/home/data/home_repo_impl.dart';
import 'package:nearme/features/home/data/story_repo_impl.dart';
import 'package:nearme/features/home/domain/repository/connection_repository.dart';
import 'package:nearme/features/home/domain/repository/home_repository.dart';
import 'package:nearme/features/home/domain/usecases/Post/comment_on_post_usecase.dart';
import 'package:nearme/features/home/domain/usecases/Post/create_post_usecase.dart';
import 'package:nearme/features/home/domain/usecases/Post/delete_comment_usecase.dart';
import 'package:nearme/features/home/domain/usecases/Post/delete_post_usecase.dart';
import 'package:nearme/features/home/domain/usecases/Post/fetch_comment_usecase.dart';
import 'package:nearme/features/home/domain/usecases/Post/fetch_my_post_usecase.dart';
import 'package:nearme/features/home/domain/usecases/Post/fetch_post_usecase.dart';
import 'package:nearme/features/home/domain/usecases/Post/like_post_usecase.dart';
import 'package:nearme/features/home/domain/usecases/Story/create_story_usecase.dart';
import 'package:nearme/features/home/domain/usecases/Story/delete_story_usecase.dart';
import 'package:nearme/features/home/domain/usecases/Story/fetch_story_usecase.dart';
import 'package:nearme/features/home/domain/usecases/Story/fetch_viewer_usecase.dart';
import 'package:nearme/features/home/domain/usecases/Story/like_story_usecase.dart';
import 'package:nearme/features/home/domain/usecases/Story/view_story_usecase.dart';
import 'package:nearme/features/home/domain/usecases/connection/get_connection_request_usecase.dart';
import 'package:nearme/features/home/domain/usecases/connection/get_connection_usecase.dart';
import 'package:nearme/features/home/domain/usecases/connection/get_suggestion_user_usecase.dart';
import 'package:nearme/features/home/domain/usecases/connection/read_connection_request_usecase.dart';
import 'package:nearme/features/home/domain/usecases/connection/respond_to_connection_request_usecase.dart';
import 'package:nearme/features/home/domain/usecases/connection/send_connection_request_usecase.dart';
import 'package:nearme/features/home/presentation/ConnectionBlock/connection_bloc.dart';
import 'package:nearme/features/home/presentation/PostBlock/home_bloc.dart';
import 'package:nearme/features/home/presentation/StoryBlock/story_bloc.dart';
import 'package:nearme/features/map/data/map_repo_impl.dart';
import 'package:nearme/features/map/domain/repository/map_repository.dart';
import 'package:nearme/features/map/domain/usecases/get_nearby_users_usecase.dart';
import 'package:nearme/features/map/domain/usecases/listen_to_location_status_usecase.dart';
import 'package:nearme/features/map/domain/usecases/update_user_location_usecase.dart';
import 'package:nearme/features/map/presentation/bloc/map_bloc.dart';
import 'package:nearme/features/notification/data/notification_repo_impl.dart';
import 'package:nearme/features/notification/domain/repository/notification_repository.dart';
import 'package:nearme/features/notification/domain/usecases/listen_notification_usecase.dart';
import 'package:nearme/features/notification/domain/usecases/mark_noti_as_read_usecase.dart';
import 'package:nearme/features/notification/presentation/bloc/notification_bloc.dart';
import 'package:nearme/features/profile/data/profile_repo_impl.dart';
import 'package:nearme/features/profile/domain/repository/profile_repository.dart';
import 'package:nearme/features/profile/domain/usecases/fetch_user_post_usecase.dart';
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
  sl.registerLazySingleton<FirebaseDatabase>(() => FirebaseDatabase.instance);

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
  sl.registerLazySingleton<FetchUserPostUsecase>(
    () => FetchUserPostUsecase(profileRepository: sl<ProfileRepository>()),
  );
  // bloc

  sl.registerFactory(
    () => ProfileBloc(
      updateProfileImageUsecase: sl<UpdateProfileImageUsecase>(),
      updateBannerImageUsecase: sl<UpdateBannerImageUsecase>(),
      updateUserInfoUsecase: sl<UpdateUserInfoUsecase>(),
      fetchUserPostUsecase: sl<FetchUserPostUsecase>(),
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
  sl.registerLazySingleton<FetchMyPostUsecase>(
    () => FetchMyPostUsecase(sl<HomeRepository>()),
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
      fetchMyPostUsecase: sl<FetchMyPostUsecase>(),
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

  // Connections

  // repository
  sl.registerLazySingleton<ConnectionRepository>(
    () => ConnectionRepoImpl(
      sharedPreferences: sl<SharedPreferences>(),
      firestore: sl<FirebaseFirestore>(),
      networkInfo: sl<NetworkInfo>(),
    ),
  );

  // usecase
  sl.registerLazySingleton<GetSuggestionUserUsecase>(
    () => GetSuggestionUserUsecase(
      connectionRepository: sl<ConnectionRepository>(),
    ),
  );
  sl.registerLazySingleton<SendConnectionRequestUsecase>(
    () => SendConnectionRequestUsecase(
      connectionRepository: sl<ConnectionRepository>(),
    ),
  );
  sl.registerLazySingleton<StreamConnectionRequestUsecase>(
    () => StreamConnectionRequestUsecase(
      connectionRepository: sl<ConnectionRepository>(),
    ),
  );
  sl.registerLazySingleton<ReadConnectionRequestUsecase>(
    () => ReadConnectionRequestUsecase(
      connectionRepository: sl<ConnectionRepository>(),
    ),
  );
  sl.registerLazySingleton<RespondToConnectionRequestUsecase>(
    () => RespondToConnectionRequestUsecase(
      connectionRepository: sl<ConnectionRepository>(),
    ),
  );
  sl.registerLazySingleton<GetConnectionUsecase>(
    () =>
        GetConnectionUsecase(connectionRepository: sl<ConnectionRepository>()),
  );
  // Bloc
  sl.registerFactory(
    () => ConnectionBloc(
      getSuggestionUserUsecase: sl<GetSuggestionUserUsecase>(),
      sendConnectionRequestUsecase: sl<SendConnectionRequestUsecase>(),
      streamConnectionRequestUsecase: sl<StreamConnectionRequestUsecase>(),
      readConnectionRequestUsecase: sl<ReadConnectionRequestUsecase>(),
      respondToConnectionRequestUsecase:
          sl<RespondToConnectionRequestUsecase>(),
      getConnectionUsecase: sl<GetConnectionUsecase>(),
    ),
  );

  // Chat
  // repository
  sl.registerLazySingleton<ChatRepository>(
    () => ChatRepoImpl(
      sharedPreferences: sl<SharedPreferences>(),
      firestore: sl<FirebaseFirestore>(),
      networkInfo: sl<NetworkInfo>(),
      firebaseDatabase: sl<FirebaseDatabase>(),
    ),
  );

  // usecase
  sl.registerLazySingleton<GetUserChatsUsecase>(
    () => GetUserChatsUsecase(chatRepository: sl<ChatRepository>()),
  );
  sl.registerLazySingleton<SendMessageUsecase>(
    () => SendMessageUsecase(chatRepository: sl<ChatRepository>()),
  );
  sl.registerLazySingleton<GetChatMessageUsecase>(
    () => GetChatMessageUsecase(chatRepository: sl<ChatRepository>()),
  );
  sl.registerLazySingleton<MarkAsReadUsecase>(
    () => MarkAsReadUsecase(repository: sl<ChatRepository>()),
  );

  // Bloc
  sl.registerFactory(
    () => ChatBloc(
      getUserChatsUsecase: sl<GetUserChatsUsecase>(),
      sendMessageUsecase: sl<SendMessageUsecase>(),
      getChatMessagesUsecase: sl<GetChatMessageUsecase>(),
      markAsReadUsecase: sl<MarkAsReadUsecase>(),
    ),
  );

  // Map
  // repository
  sl.registerLazySingleton<MapRepository>(
    () => MapRepoImpl(
      firestore: sl<FirebaseFirestore>(),
      networkInfo: sl<NetworkInfo>(),
      firebaseDatabase: sl<FirebaseDatabase>(),
    ),
  );
  // usecase
  sl.registerLazySingleton<ListenToLocationStatusUsecase>(
    () => ListenToLocationStatusUsecase(mapRepository: sl<MapRepository>()),
  );
  sl.registerLazySingleton<UpdateUserLocationUsecase>(
    () => UpdateUserLocationUsecase(mapRepository: sl<MapRepository>()),
  );
  sl.registerLazySingleton<GetNearbyUsersUsecase>(
    () => GetNearbyUsersUsecase(mapRepository: sl<MapRepository>()),
  );
  // Bloc
  sl.registerFactory(
    () => MapBloc(
      listenToLocationStatusUsecase: sl<ListenToLocationStatusUsecase>(),
      updateUserLocationUsecase: sl<UpdateUserLocationUsecase>(),
      getNearbyUsersUsecase: sl<GetNearbyUsersUsecase>(),
    ),
  );

  // NOTIFICATION
  // repository
  sl.registerLazySingleton<NotificationRepository>(
    () => NotificationRepoImpl(firestore: sl<FirebaseFirestore>()),
  );
  // usecase
  sl.registerLazySingleton<MarkNotiAsReadUsecase>(
    () => MarkNotiAsReadUsecase(repository: sl<NotificationRepository>()),
  );
  sl.registerLazySingleton<ListenNotificationUsecase>(
    () => ListenNotificationUsecase(repository: sl<NotificationRepository>()),
  );

  // Bloc
  sl.registerFactory(
    () => NotificationBloc(
      listenNotificationUsecase: sl(),
      markNotiAsReadUsecase: sl(),
    ),
  );
}
