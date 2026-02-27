import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nearme/core/constant/user_session.dart';
import 'package:nearme/core/utils/loading_overlay.dart';
import 'package:nearme/features/home/presentation/PostBlock/home_bloc.dart';
import 'package:nearme/features/home/presentation/pages/post_detail_page.dart';
import 'package:nearme/features/profile/presentation/bloc/profile_bloc.dart';

import '../../../../core/constant/pick_image.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../widgets/update_profile_widget.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return RefreshIndicator(
      onRefresh: () async {
        // context.read<ProfileBloc>().add(FetchProfileInfoEvent());
        context.read<HomeBloc>().add(FetchMyPostsEvent());
      },
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: BlocConsumer<ProfileBloc, ProfileState>(
              listener: (context, profileState) {
                print("profileState: $profileState");
                if (profileState is ProfileInfoUpdatingState) {
                  setState(() {
                    isLoading = true;
                  });
                } else {
                  setState(() {
                    isLoading = false;
                  });
                }
                if (profileState is ProfileError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(profileState.message),
                      backgroundColor: Colors.redAccent,
                    ),
                  );
                } else if (profileState is ProfileUpdated) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Profile updated successfully!"),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              },
              builder: (context, profileState) {
                return Column(
                  children: [
                    /// HEADER IMAGE + BACK BUTTON
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        GestureDetector(
                          onTap: () async {
                            final picked = await pickAndConfirmImage(
                              context,
                              "banner",
                            );
                            final path = picked?.path ?? "";
                            if (path.isEmpty) return;
                            context.read<ProfileBloc>().add(
                              UpdateBannerPhotoEvent(path),
                            );
                          },
                          child: Container(
                            height: 220,
                            width: double.infinity,
                            color: colors.surface,
                            child:
                                UserSession.instance.bannerImage != null &&
                                    UserSession.instance.bannerImage!.isNotEmpty
                                ? Image.network(
                                    UserSession.instance.bannerImage!,
                                    fit: BoxFit.cover,
                                  )
                                : Icon(
                                    Icons.image,
                                    size: 50,
                                    color: colors.primary,
                                  ),
                          ),
                        ),

                        /// LOG OUT BUTTON
                        Positioned(
                          top: 12,
                          right: 12,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  Colors.transparent, // Button color
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  12,
                                ), // Rounded corners
                              ),
                              padding: const EdgeInsets.all(12),
                              elevation: 5, // Shadow
                            ),
                            child: Icon(
                              Icons.logout,
                              color: Colors.white,
                              size: 24,
                            ),
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
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
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
                              child: GestureDetector(
                                onTap: () async {
                                  final picked = await pickAndConfirmImage(
                                    context,
                                    "profile",
                                  );
                                  final path = picked?.path ?? "";
                                  if (path.isEmpty) return;
                                  context.read<ProfileBloc>().add(
                                    UpdateProfilePictureEvent(path),
                                  );
                                },
                                child: CircleAvatar(
                                  radius: 50,
                                  backgroundColor: colors.surface,
                                  foregroundImage:
                                      UserSession.instance.profileImage !=
                                              null &&
                                          UserSession
                                              .instance
                                              .profileImage!
                                              .isNotEmpty
                                      ? NetworkImage(
                                          UserSession.instance.profileImage!,
                                        )
                                      : null,
                                  child: Icon(
                                    Icons.person,
                                    size: 50,
                                    color: colors.primary,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        if (profileState is ProfileUploadingState)
                          const LoadingOverlay(),
                      ],
                    ),

                    const SizedBox(height: 60),

                    /// NAME
                    Text(
                      UserSession.instance.name == null ||
                              UserSession.instance.name!.isEmpty
                          ? "Unnamed User"
                          : UserSession.instance.name!,
                      style: theme.textTheme.headlineLarge?.copyWith(
                        fontSize: 24,
                      ),
                    ),

                    const SizedBox(height: 6),

                    /// SUBTITLE
                    Text(
                      "${UserSession.instance.dept == null || UserSession.instance.dept!.isEmpty ? "---" : UserSession.instance.dept} • Class of ${UserSession.instance.year == null || UserSession.instance.year!.isEmpty ? "---" : UserSession.instance.year}",
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colors.primary,
                      ),
                    ),

                    const SizedBox(height: 16),

                    /// BIO
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Text(
                        UserSession.instance.bio == null ||
                                UserSession.instance.bio!.isEmpty
                            ? "This user hasn't written a bio yet."
                            : UserSession.instance.bio!,
                        style: theme.textTheme.bodyMedium,
                        textAlign: TextAlign.center,
                      ),
                    ),

                    const SizedBox(height: 20),

                    /// EDIT BUTTON
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: ElevatedButton.icon(
                        onPressed: () {
                          showEditProfileDialog(context);
                        },
                        icon: const Icon(Icons.edit),
                        label: isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              )
                            : const Text("Edit Profile"),
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
                        children: [
                          _StatItem(
                            number:
                                UserSession.instance.postCount?.toString() ??
                                "0",
                            label: "POSTS",
                          ),
                          _StatItem(
                            number:
                                UserSession.instance.connectionCount
                                    ?.toString() ??
                                "0",
                            label: "CONNECTIONS",
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 30),

                    Divider(color: colors.surface, thickness: 2),

                    const SizedBox(height: 10),

                    /// GRID ICON
                    GestureDetector(
                      onTap: () {
                        context.read<HomeBloc>().add(FetchMyPostsEvent());
                      },
                      child: Icon(Icons.grid_view, color: colors.primary),
                    ),

                    const SizedBox(height: 10),

                    /// IMAGE GRID
                    BlocBuilder<HomeBloc, HomeState>(
                      builder: (context, homeState) {
                        print("homeState in profile: $homeState");
                        print("myPosts: ${homeState.myPosts}");
                        return GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: const EdgeInsets.all(8),
                          itemCount: homeState.myPosts.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                crossAxisSpacing: 6,
                                mainAxisSpacing: 6,
                              ),
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                context.read<HomeBloc>().add(
                                  FetchCommentsEvent(
                                    postId: homeState.myPosts[index].postId,
                                  ),
                                );
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => PostDetailPage(
                                      post: homeState.myPosts[index],
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                color: colors.surface,
                                child:
                                    homeState.myPosts[index].imageUrl == null ||
                                        homeState
                                            .myPosts[index]
                                            .imageUrl!
                                            .isEmpty
                                    ? Center(
                                        child: Text(
                                          homeState.myPosts[index].caption ??
                                              "No caption",
                                          style: theme.textTheme.bodyMedium,
                                          textAlign: TextAlign.center,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      )
                                    : Image.network(
                                        homeState.myPosts[index].imageUrl!,
                                        fit: BoxFit.cover,
                                      ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ],
                );
              },
            ),
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
