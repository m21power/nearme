import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nearme/core/utils/loading_overlay.dart';
import 'package:nearme/features/chat/domain/entities/chat_model.dart';
import 'package:nearme/features/chat/presentation/bloc/chat_bloc.dart';
import 'package:nearme/features/home/presentation/PostBlock/home_bloc.dart';
import 'package:nearme/features/home/presentation/pages/post_detail_page.dart';
import 'package:nearme/features/profile/presentation/bloc/profile_bloc.dart';

import '../../../../core/constant/user_session.dart';
import '../../../chat/presentation/pages/message_page.dart';

class UserProfilePage extends StatefulWidget {
  final String userId;
  const UserProfilePage({super.key, required this.userId});

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    context.read<ProfileBloc>().add(FetchUserPostsEvent(userId: widget.userId));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return RefreshIndicator(
      onRefresh: () async {
        context.read<ProfileBloc>().add(
          FetchUserPostsEvent(userId: widget.userId),
        );
      },
      child: BlocConsumer<ProfileBloc, ProfileState>(
        listener: (context, profileState) {
          print("Profile State in UI: $profileState");
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
          if (profileState is UserPostsFetchedState) {
            return Scaffold(
              appBar: AppBar(
                title: Text(
                  "${profileState.userInfo.userModel.name}'s Profile",
                ),
                leading: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.arrow_back),
                ),
              ),
              body: Stack(
                children: [
                  SafeArea(
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
                                child:
                                    profileState
                                                .userInfo
                                                .userModel
                                                .profileImage !=
                                            null &&
                                        profileState
                                            .userInfo
                                            .userModel
                                            .profileImage!
                                            .isNotEmpty
                                    ? Image.network(
                                        profileState
                                            .userInfo
                                            .userModel
                                            .profileImage!,
                                        fit: BoxFit.cover,
                                      )
                                    : Icon(
                                        Icons.image,
                                        size: 50,
                                        color: colors.primary,
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
                                      foregroundImage:
                                          profileState
                                                      .userInfo
                                                      .userModel
                                                      .profileImage !=
                                                  null &&
                                              profileState
                                                  .userInfo
                                                  .userModel
                                                  .profileImage!
                                                  .isNotEmpty
                                          ? NetworkImage(
                                              profileState
                                                  .userInfo
                                                  .userModel
                                                  .profileImage!,
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
                            ],
                          ),

                          const SizedBox(height: 60),

                          /// NAME
                          Text(
                            profileState.userInfo.userModel.name == null ||
                                    profileState
                                        .userInfo
                                        .userModel
                                        .name!
                                        .isEmpty
                                ? "Unnamed User"
                                : profileState.userInfo.userModel.name!,
                            style: theme.textTheme.headlineLarge?.copyWith(
                              fontSize: 24,
                            ),
                          ),

                          const SizedBox(height: 6),

                          /// SUBTITLE
                          Text(
                            "${profileState.userInfo.userModel.dept == null || profileState.userInfo.userModel.dept!.isEmpty ? "---" : profileState.userInfo.userModel.dept} • Class of ${profileState.userInfo.userModel.year == null || profileState.userInfo.userModel.year!.isEmpty ? "---" : profileState.userInfo.userModel.year}",
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: colors.primary,
                            ),
                          ),

                          const SizedBox(height: 16),

                          /// BIO
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 30),
                            child: Text(
                              profileState.userInfo.userModel.bio == null ||
                                      profileState
                                          .userInfo
                                          .userModel
                                          .bio!
                                          .isEmpty
                                  ? "This user hasn't written a bio yet."
                                  : profileState.userInfo.userModel.bio!,
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
                                if (profileState.userInfo.isConnected) {
                                  final secondUserId =
                                      profileState.userInfo.userModel.userId;
                                  List<String> chatIds = [
                                    UserSession.instance.userId!,
                                    secondUserId,
                                  ];
                                  final chatId = chatIds.join("_");

                                  context.read<ChatBloc>().add(
                                    LoadChatMessagesEvent(chatId: chatId),
                                  );
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => MessagePage(
                                        chatId: chatId,
                                        user: User(
                                          userId: secondUserId,
                                          name: profileState
                                              .userInfo
                                              .userModel
                                              .name,
                                          profilePicUrl: profileState
                                              .userInfo
                                              .userModel
                                              .profileImage,
                                        ),
                                      ),
                                    ),
                                  );
                                } else {
                                  // Send connection request
                                  // context.read<ProfileBloc>().add(
                                  //   SendConnectionRequestEvent(
                                  //     targetUserId: profileState
                                  //         .userInfo
                                  //         .userModel
                                  //         .userId,
                                  //   ),
                                  // );
                                }
                              },
                              label: profileState.userInfo.isConnected
                                  ? Text("Message")
                                  : Text("Connect"),
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
                                      profileState.userInfo.userPosts.length
                                          .toString() ??
                                      "0",
                                  label: "POSTS",
                                ),
                                _StatItem(
                                  number:
                                      profileState
                                          .userInfo
                                          .userModel
                                          .connectionCount
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
                          Icon(Icons.grid_view, color: colors.primary),

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
                                itemCount:
                                    profileState.userInfo.userPosts.length,
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
                                          postId: profileState
                                              .userInfo
                                              .userPosts[index]
                                              .postId,
                                        ),
                                      );
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (_) => PostDetailPage(
                                            post: profileState
                                                .userInfo
                                                .userPosts[index],
                                          ),
                                        ),
                                      );
                                    },
                                    child: Container(
                                      color: colors.surface,
                                      child:
                                          profileState
                                                      .userInfo
                                                      .userPosts[index]
                                                      .imageUrl ==
                                                  null ||
                                              profileState
                                                  .userInfo
                                                  .userPosts[index]
                                                  .imageUrl!
                                                  .isEmpty
                                          ? Center(
                                              child: Text(
                                                profileState
                                                        .userInfo
                                                        .userPosts[index]
                                                        .caption ??
                                                    "No caption",
                                                style:
                                                    theme.textTheme.bodyMedium,
                                                textAlign: TextAlign.center,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            )
                                          : Image.network(
                                              profileState
                                                  .userInfo
                                                  .userPosts[index]
                                                  .imageUrl!,

                                              fit: BoxFit.cover,
                                            ),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),

                  if (profileState is FetchingUserPostsState)
                    const LoadingOverlay(),
                ],
              ),
            );
          } else {
            return Scaffold(
              appBar: AppBar(
                // title: Text("${widget.userModel.name}'s Profile"),
                leading: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.arrow_back),
                ),
              ),
              body: const Center(child: CircularProgressIndicator()),
            );
          }
        },
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
