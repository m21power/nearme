import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:nearme/core/route/route.dart';
import 'package:nearme/core/theme/dark_theme.dart';
import 'package:nearme/core/theme/light_theme.dart';
import 'package:nearme/dependency_injection.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:nearme/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:nearme/features/chat/presentation/bloc/chat_bloc.dart';
import 'package:nearme/features/home/presentation/ConnectionBlock/connection_bloc.dart';
import 'package:nearme/features/home/presentation/PostBlock/home_bloc.dart';
import 'package:nearme/features/home/presentation/StoryBlock/story_bloc.dart';
import 'package:nearme/features/map/presentation/bloc/map_bloc.dart';
import 'package:nearme/features/notification/data/notification_service.dart';
import 'package:nearme/features/notification/presentation/bloc/notification_bloc.dart';
import 'package:nearme/features/profile/presentation/bloc/profile_bloc.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseDatabase.instance.setPersistenceEnabled(true);
  await NotificationService.init();

  await dotenv.load(fileName: ".env");

  await init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => sl<AuthBloc>()..add(AuthCheckLoginStatusEvent()),
        ),
        BlocProvider(create: (_) => sl<ProfileBloc>()),
        BlocProvider(
          create: (_) => sl<HomeBloc>()
            ..add(FetchPostsEvent())
            ..add(FetchMyPostsEvent()),
        ),
        BlocProvider(create: (_) => sl<StoryBloc>()..add(FetchStoriesEvent())),
        BlocProvider(
          create: (_) => sl<ConnectionBloc>()
            ..add(LoadConnectionSuggestionsEvent())
            ..add(LoadConnectionRequestsEvent())
            ..add(LoadConnectionsEvent()),
        ),

        BlocProvider(create: (_) => sl<ChatBloc>()..add(LoadUserChatsEvent())),
        BlocProvider(
          create: (_) => sl<MapBloc>()
            ..add(ListenToLocationStatusEvent())
            ..add(GetNearbyUsersEvent()),
        ),
        BlocProvider(
          create: (context) =>
              sl<NotificationBloc>()..add(LoadNotificationsEvent()),
        ),
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        theme: AppLightTheme.theme,
        darkTheme: AppDarkTheme.theme,
        themeMode: ThemeMode.system,
        routerConfig: router,
        // home: SplashScreen(),
      ),
    );
  }
}
