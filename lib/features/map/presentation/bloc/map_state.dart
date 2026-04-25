part of 'map_bloc.dart';

sealed class MapState extends Equatable {
  final bool isLocationEnabled;
  final List<MapUser> nearbyUsers;
  final LatLng currentLocation;
  const MapState({
    required this.isLocationEnabled,
    required this.nearbyUsers,
    required this.currentLocation,
  });

  @override
  List<Object> get props => [isLocationEnabled, nearbyUsers, currentLocation];
}

final class MapInitial extends MapState {
  MapInitial()
    : super(
        isLocationEnabled: false,
        nearbyUsers: [],
        currentLocation: LatLng(9.0422, 38.7578),
      );
}

class MapDataLoadedState extends MapState {
  MapDataLoadedState({
    required bool isLocationEnabled,
    required List<MapUser> nearbyUsers,
    required LatLng currentLocation,
  }) : super(
         isLocationEnabled: isLocationEnabled,
         nearbyUsers: nearbyUsers,
         currentLocation: currentLocation,
       );
}

class MapErrorState extends MapState {
  final String message;
  MapErrorState({
    required this.message,
    required bool isLocationEnabled,
    required List<MapUser> nearbyUsers,
    required LatLng currentLocation,
  }) : super(
         isLocationEnabled: isLocationEnabled,
         nearbyUsers: nearbyUsers,
         currentLocation: currentLocation,
       );
}
