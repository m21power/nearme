import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:nearme/core/route/route.dart';
import 'package:nearme/core/theme/dark_theme.dart';
import 'package:nearme/core/theme/light_theme.dart';
import 'package:nearme/dependency_injection.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:nearme/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:nearme/splash_screen.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
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
