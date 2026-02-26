import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../auth/presentation/bloc/auth_bloc.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              /// HEADER IMAGE + BACK BUTTON
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    height: 220,
                    width: double.infinity,
                    color: colors.surface,
                    // child: const Icon(Icons.image, size: 80),
                    child: Image.asset("assets/image.jpg", fit: BoxFit.cover),
                  ),

                  /// LOG OUT BUTTON
                  Positioned(
                    top: 12,
                    right: 12,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent, // Button color
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            12,
                          ), // Rounded corners
                        ),
                        padding: const EdgeInsets.all(12),
                        elevation: 5, // Shadow
                      ),
                      child: Icon(Icons.logout, color: Colors.white, size: 24),
                      onPressed: () {
                        // Show confirmation dialog
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            title: Row(
                              children: const [
                                Icon(Icons.logout),
                                SizedBox(width: 10),
                                Text("Log Out"),
                              ],
                            ),
                            content: const Text(
                              "Are you sure you want to log out?",
                              style: TextStyle(fontSize: 16),
                            ),
                            actionsPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            actions: [
                              TextButton(
                                style: TextButton.styleFrom(
                                  foregroundColor: Colors.grey[700],
                                ),
                                onPressed: () => Navigator.pop(context),
                                child: const Text(
                                  "Cancel",
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  // backgroundColor: Colors.redAccent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 12,
                                  ),
                                ),
                                onPressed: () {
                                  // Perform log out action here
                                  context.read<AuthBloc>().add(
                                    AuthLogoutEvent(),
                                  );
                                  Navigator.pop(context);
                                },
                                child: const Text(
                                  "Log Out",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),

                  /// PROFILE AVATAR
                  Positioned(
                    bottom: -50,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: theme.scaffoldBackgroundColor,
                        ),
                        child: CircleAvatar(
                          radius: 50,
                          backgroundColor: colors.surface,
                          // child: Icon(
                          //   Icons.person,
                          //   size: 50,
                          //   color: colors.primary,
                          // ),
                          backgroundImage: const AssetImage("assets/image.jpg"),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 60),

              /// NAME
              Text(
                "Alex Johnson",
                style: theme.textTheme.headlineLarge?.copyWith(fontSize: 24),
              ),

              const SizedBox(height: 6),

              /// SUBTITLE
              Text(
                "Computer Science • Class of '25",
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colors.primary,
                ),
              ),

              const SizedBox(height: 16),

              /// BIO
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Text(
                  "☕ Coffee enthusiast. coding late night.\n"
                  "Looking for study buddies for Algorithms 101! 📚",
                  style: theme.textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
              ),

              const SizedBox(height: 20),

              /// EDIT BUTTON
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.edit),
                  label: const Text("Edit Profile"),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(50),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              /// STATS
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: const [
                    _StatItem(number: "42", label: "POSTS"),
                    _StatItem(number: "158", label: "CONNECTIONS"),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              Divider(color: colors.surface, thickness: 2),

              const SizedBox(height: 10),

              /// GRID ICON
              Icon(Icons.grid_view, color: colors.primary),

              const SizedBox(height: 10),

              /// IMAGE GRID
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.all(8),
                itemCount: 18,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 6,
                  mainAxisSpacing: 6,
                ),
                itemBuilder: (context, index) {
                  return Container(
                    color: colors.surface,
                    // child: const Icon(Icons.image),
                    child: Image.asset("assets/image.jpg", fit: BoxFit.cover),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String number;
  final String label;

  const _StatItem({required this.number, required this.label});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Text(
          number,
          style: theme.textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(label, style: theme.textTheme.bodyMedium),
      ],
    );
  }
}
