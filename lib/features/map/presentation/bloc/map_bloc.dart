import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:latlong2/latlong.dart';
import 'package:nearme/features/map/domain/entities/map_user.dart';
import 'package:nearme/features/map/domain/usecases/get_nearby_users_usecase.dart';
import 'package:nearme/features/map/domain/usecases/update_user_location_usecase.dart';

import '../../domain/usecases/listen_to_location_status_usecase.dart';

part 'map_event.dart';
part 'map_state.dart';

class MapBloc extends Bloc<MapEvent, MapState> {
  final ListenToLocationStatusUsecase listenToLocationStatusUsecase;
  final UpdateUserLocationUsecase updateUserLocationUsecase;
  final GetNearbyUsersUsecase getNearbyUsersUsecase;
  StreamSubscription<bool>? _locationStatusSubscription;

  MapBloc({
    required this.listenToLocationStatusUsecase,
    required this.updateUserLocationUsecase,
    required this.getNearbyUsersUsecase,
  }) : super(MapInitial()) {
    on<ListenToLocationStatusEvent>((event, emit) async {
      // Use emit.forEach to safely listen to stream
      await emit.forEach<bool>(
        listenToLocationStatusUsecase(),
        onData: (isEnabled) => MapDataLoadedState(
          isLocationEnabled: isEnabled,
          nearbyUsers: state.nearbyUsers,
          currentLocation: state.currentLocation,
        ),
        onError: (error, stackTrace) {
          print("Error listening to location status: $error");
          print(stackTrace);
          return MapErrorState(
            isLocationEnabled: state.isLocationEnabled,
            message: 'Failed to listen to location status: $error',
            nearbyUsers: state.nearbyUsers,
            currentLocation: state.currentLocation,
          );
        },
      );
    });
    on<UpdateUserLocationEvent>((event, emit) async {
      final result = await updateUserLocationUsecase();
      result.fold(
        (failure) => emit(
          MapErrorState(
            isLocationEnabled: state.isLocationEnabled,
            message: 'Failed to update location:',
            nearbyUsers: state.nearbyUsers,
            currentLocation: state.currentLocation,
          ),
        ),

        (latLng) {
          print("Updated location: $latLng");
          emit(
            MapDataLoadedState(
              isLocationEnabled: state.isLocationEnabled,
              nearbyUsers: state.nearbyUsers,
              currentLocation: latLng,
            ),
          );
        },
      );
    });
    on<GetNearbyUsersEvent>((event, emit) async {
      final result = await getNearbyUsersUsecase();
      result.fold(
        (failure) => emit(
          MapErrorState(
            isLocationEnabled: state.isLocationEnabled,
            message: 'Failed to fetch nearby users: ${failure.message}',
            nearbyUsers: state.nearbyUsers,
            currentLocation: state.currentLocation,
          ),
        ),
        (users) => emit(
          MapDataLoadedState(
            isLocationEnabled: state.isLocationEnabled,
            nearbyUsers: users,
            currentLocation: state.currentLocation,
          ),
        ),
      );
    });
  }
  @override
  Future<void> close() {
    _locationStatusSubscription?.cancel();
    return super.close();
  }
}
