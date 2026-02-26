import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final MapController _mapController = MapController();

  MapUser? selectedUser;

  /// 4 KILO CENTER
  final LatLng fourKilo = const LatLng(9.0422, 38.7578);

  final List<MapUser> users = [
    MapUser(
      id: "1",
      name: "Jessica Reynolds",
      avatar: "assets/image.jpg",
      isConnected: false,
      major: "Computer Science",
      year: "Junior",
      locationInfo: const LatLng(9.0430, 38.7585),
    ),
    MapUser(
      id: "2",
      name: "Sarah",
      avatar: "assets/image.jpg",
      isConnected: true,
      major: "Mathematics",
      year: "Sophomore",
      locationInfo: const LatLng(9.0415, 38.7565),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _buildMap(),

          if (selectedUser != null) _buildUserCard(selectedUser!),
        ],
      ),
    );
  }

  Widget _buildMap() {
    return FlutterMap(
      mapController: _mapController,
      options: MapOptions(
        initialCenter: fourKilo,
        initialZoom: 17,
        onTap: (_, __) => setState(() => selectedUser = null),
      ),
      children: [
        TileLayer(
          urlTemplate:
              "https://api.maptiler.com/maps/streets/{z}/{x}/{y}.png?key=${dotenv.env['MAP_KEY']}",
          userAgentPackageName: 'com.example.nearme',
        ),

        /// REAL MARKERS
        MarkerLayer(
          markers: users.map((user) {
            final isSelected = selectedUser?.id == user.id;

            return Marker(
              point: user.locationInfo,
              width: 90,
              height: 100,
              child: GestureDetector(
                onTap: () {
                  setState(() => selectedUser = user);

                  _mapController.move(user.locationInfo, 18);
                },
                child: Column(
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Theme.of(context).colorScheme.primary,
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 12,
                            color: Theme.of(
                              context,
                            ).colorScheme.primary.withOpacity(0.4),
                          ),
                        ],
                      ),
                      child: CircleAvatar(
                        radius: isSelected ? 30 : 26,
                        backgroundColor: Theme.of(context).colorScheme.surface,
                        child: ClipOval(
                          child: Image.asset(
                            user.avatar,
                            fit: BoxFit.cover,
                            width: 52,
                            height: 52,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 6),

                    if (isSelected)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          user.name,
                          style: Theme.of(context).textTheme.bodySmall,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildUserCard(MapUser user) {
    final theme = Theme.of(context);

    return DraggableScrollableSheet(
      initialChildSize: 0.38,
      minChildSize: 0.20,
      maxChildSize: 0.85,
      builder: (context, controller) {
        return Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(26)),
            boxShadow: [
              BoxShadow(blurRadius: 20, color: Colors.black.withOpacity(0.15)),
            ],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: SingleChildScrollView(
            controller: controller,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Handle bar
                Center(
                  child: Container(
                    height: 6,
                    width: 50,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.onSurface.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                /// USER HEADER
                Row(
                  children: [
                    CircleAvatar(
                      radius: 32,
                      backgroundImage: AssetImage(user.avatar),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                user.name,
                                style: theme.textTheme.headlineSmall,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(width: 4),
                            ],
                          ),
                          Text(
                            "${user.major} • ${user.year}",
                            style: theme.textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () => setState(() => selectedUser = null),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),

                const SizedBox(height: 30),

                /// BUTTON
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (user.isConnected) {
                        // Navigate to chat
                      } else {
                        // Send request
                      }
                    },
                    child: Text(user.isConnected ? "Message" : "Connect"),
                  ),
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }
}

class MapUser {
  final String id;
  final String name;
  final String avatar;
  final bool isConnected;
  final String major;
  final String year;
  final LatLng locationInfo;

  MapUser({
    required this.id,
    required this.name,
    required this.avatar,
    required this.isConnected,
    required this.major,
    required this.year,
    required this.locationInfo,
  });
}
