import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nearme/features/notification/presentation/bloc/notification_bloc.dart';

import '../../../chat/presentation/bloc/chat_bloc.dart';

class CustomBottomNavBar extends StatefulWidget {
  final int currentIndex;
  final Function(int) onTap;
  final VoidCallback onCenterTap;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.onCenterTap,
  });

  @override
  State<CustomBottomNavBar> createState() => _CustomBottomNavBarState();
}

class _CustomBottomNavBarState extends State<CustomBottomNavBar> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    bool hasUnseenNotifications = false;
    return BlocConsumer<NotificationBloc, NotificationState>(
      listener: (context, notiState) {
        if (notiState is NotificationLoaded) {
          setState(() {
            hasUnseenNotifications = notiState.notifications.any(
              (noti) => (!noti.isRead && noti.type == "chat_message"),
            );
          });
        }
      },
      builder: (context, notiState) {
        return Container(
          clipBehavior: Clip.none,
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: scheme.surface,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(28),
              topRight: Radius.circular(28),
            ),
            boxShadow: [
              BoxShadow(
                color: scheme.primary.withOpacity(0.08),
                blurRadius: 10,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _navItem(
                    context,
                    index: 0,
                    icon: Icons.home_outlined,
                    label: "Home",
                  ),
                  _navItem(
                    context,
                    index: 1,
                    icon: Icons.map_outlined,
                    label: "Map",
                  ),
                  const SizedBox(width: 60),
                  _navItem(
                    context,
                    index: 3,
                    icon: Icons.chat_bubble_outline,
                    label: "Chat",
                    badgeColor: hasUnseenNotifications ? scheme.primary : null,
                  ),
                  _navItem(
                    context,
                    index: 4,
                    icon: Icons.person_outline,
                    label: "Profile",
                  ),
                ],
              ),

              // Center floating button
              Positioned(
                top: -22,
                child: InkWell(
                  onTap: widget.onCenterTap,
                  child: Container(
                    height: 62,
                    width: 62,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: scheme.primary,
                      boxShadow: [
                        BoxShadow(
                          color: scheme.primary.withOpacity(0.35),
                          blurRadius: 14,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: const Icon(Icons.add, color: Colors.white, size: 32),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _navItem(
    BuildContext context, {
    required int index,
    required IconData icon,
    required String label,
    Color? badgeColor, // 👈 optional
  }) {
    final theme = Theme.of(context);
    final isActive = index == widget.currentIndex;

    return GestureDetector(
      onTap: () => widget.onTap(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Icon(
                icon,
                size: 26,
                color: isActive
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onSurface.withOpacity(.6),
              ),

              // 🔴 Notification dot
              if (badgeColor != null)
                Positioned(
                  right: -2,
                  top: -2,
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: badgeColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          ),

          const SizedBox(height: 4),

          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: isActive
                  ? theme.colorScheme.primary
                  : theme.textTheme.bodyMedium?.color,
            ),
          ),
        ],
      ),
    );
  }
}
