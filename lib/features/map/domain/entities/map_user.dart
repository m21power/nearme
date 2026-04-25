import 'package:latlong2/latlong.dart';

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
