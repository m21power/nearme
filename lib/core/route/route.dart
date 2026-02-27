import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:nearme/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:nearme/features/home/domain/entities/post_model.dart';
import 'package:nearme/features/home/presentation/pages/MainNavigationPage.dart';
import 'package:nearme/features/home/presentation/pages/post_detail_page.dart';
import 'package:nearme/splash_screen.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../constant/route_constant.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>(
  debugLabel: 'root',
);

final GoRouter router = GoRouter(
  navigatorKey: _rootNavigatorKey,
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      name: RouteConstant.welcomePageRoute,
      builder: (context, state) {
        return BlocBuilder<AuthBloc, AuthState>(
          builder: (context, authState) {
            print("authstate: $authState");
            if (authState is AuthLoginStatusChecked) {
              if (authState.isLoggedIn) {
                return MainNavigationPage();
              } else {
                return SplashScreen();
              }
            } else {
              return SplashScreen();
            }
          },
        );
      },
    ),

    GoRoute(
      path: '/login',
      name: RouteConstant.loginPage,
      builder: (context, state) {
        return LoginPage();
      },
    ),
    GoRoute(
      path: '/main',
      name: RouteConstant.mainNavigation,
      builder: (context, state) {
        return MainNavigationPage();
      },
    ),
    GoRoute(
      path: '/post-detail',
      name: RouteConstant.postDetailPage,
      builder: (context, state) {
        final post = state.extra as PostModel;
        return PostDetailPage(post: post);
      },
    ),
  ],
);
