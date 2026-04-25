import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:nearme/core/constant/user_session.dart';
import 'package:nearme/features/map/presentation/bloc/map_bloc.dart';

import '../../domain/entities/map_user.dart';

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
    return BlocBuilder<MapBloc, MapState>(
      builder: (context, mapState) {
        if (mapState.isLocationEnabled) {
          context.read<MapBloc>().add(UpdateUserLocationEvent());
        }
        print("**********************************************************");
        print("Location Enabled: ${mapState.isLocationEnabled}");
        print(mapState);
        print("**********************************************************");
        return Scaffold(
          body: Stack(
            children: [
              _buildMap(mapState),

              if (selectedUser != null) _buildUserCard(selectedUser!),

              if (!mapState.isLocationEnabled)
                Positioned(
                  top: 40,
                  left: 16,
                  right: 16,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 14,
                    ),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFFF6B6B), Color(0xFFFF3B3B)],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.15),
                          blurRadius: 12,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        /// Location Icon
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.location_on,
                            color: Colors.white,
                            size: 22,
                          ),
                        ),

                        const SizedBox(width: 12),

                        /// Text
                        Expanded(
                          child: Text(
                            "Enable location to discover people near you 📍",
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                        ),

                        const SizedBox(width: 12),

                        /// Enable Button
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.redAccent,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 10,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          onPressed: () async {
                            await Geolocator.openLocationSettings();
                          },
                          child: const Row(
                            children: [
                              Icon(Icons.my_location, size: 16),
                              SizedBox(width: 6),
                              Text(
                                "Enable",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMap(MapState mapState) {
    return FlutterMap(
      mapController: _mapController,
      options: MapOptions(
        initialCenter: mapState.currentLocation,
        initialZoom: 17,
        onTap: (_, __) => setState(() => selectedUser = null),
      ),
      children: [
        TileLayer(
          urlTemplate:
              "https://api.maptiler.com/maps/streets/{z}/{x}/{y}.png?key=${dotenv.env['MAP_KEY']}",
          userAgentPackageName: 'com.example.nearme',
        ),
        MarkerLayer(
          markers: [
            /// USER LOCATION MARKER
            Marker(
              point: mapState.currentLocation,
              width: 80,
              height: 80,
              child: Container(
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
                  radius: 30,
                  backgroundColor: Theme.of(context).colorScheme.surface,
                  backgroundImage:
                      (UserSession.instance.profileImage != null &&
                          UserSession.instance.profileImage!.isNotEmpty)
                      ? NetworkImage(UserSession.instance.profileImage!)
                      : null,
                  child:
                      (UserSession.instance.profileImage != null &&
                          UserSession.instance.profileImage!.isNotEmpty)
                      ? null
                      : Icon(Icons.person, color: Colors.white, size: 28),
                ),
              ),
            ),
          ],
        ),

        /// REAL MARKERS
        MarkerLayer(
          markers: mapState.nearbyUsers.map((user) {
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
