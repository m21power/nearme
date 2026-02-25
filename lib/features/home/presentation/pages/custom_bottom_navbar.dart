import 'package:flutter/material.dart';

class CustomBottomNavBar extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

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
              onTap: onCenterTap,
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
  }

  Widget _navItem(
    BuildContext context, {
    required int index,
    required IconData icon,
    required String label,
  }) {
    final theme = Theme.of(context);
    final isActive = index == currentIndex;

    return GestureDetector(
      onTap: () => onTap(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 26,
            color: isActive
                ? theme.colorScheme.primary
                : theme.colorScheme.onSurface.withOpacity(.6),
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
