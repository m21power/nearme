part of 'map_bloc.dart';

sealed class MapEvent extends Equatable {
  const MapEvent();

  @override
  List<Object> get props => [];
}

class ListenToLocationStatusEvent extends MapEvent {}

class UpdateUserLocationEvent extends MapEvent {}

class GetNearbyUsersEvent extends MapEvent {}
