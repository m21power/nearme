import 'package:flutter/material.dart';
import 'package:nearme/features/chat/presentation/pages/chat_page.dart';
import 'package:nearme/features/home/presentation/pages/create_post.dart';
import 'package:nearme/features/home/presentation/pages/home_page.dart';
import 'package:nearme/features/map/presentation/pages/map_page.dart';
import 'package:nearme/features/profile/presentation/pages/profile_page.dart';

import 'custom_bottom_navbar.dart';

class MainNavigationPage extends StatefulWidget {
  const MainNavigationPage({super.key});

  @override
  State<MainNavigationPage> createState() => _MainNavigationPageState();
}

class _MainNavigationPageState extends State<MainNavigationPage> {
  int currentIndex = 0;

  final List<Widget> _screens = const [
    HomePage(),
    MapPage(),
    CreatePostPage(),
    MessagesPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: _screens[currentIndex],
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: currentIndex,
        onTap: (i) {
          setState(() => currentIndex = i);
        },
        onCenterTap: () {
          setState(() => currentIndex = 2);
        },
      ),
    );
  }
}

class DummyPage extends StatelessWidget {
  final String title;

  const DummyPage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(title: Text(title)),
      body: Center(child: Text(title, style: theme.textTheme.headlineLarge)),
    );
  }
}
