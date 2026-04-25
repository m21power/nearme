import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:latlong2/latlong.dart';
import 'package:nearme/core/constant/user_session.dart';
import 'package:nearme/core/error/failure.dart';
import 'package:nearme/features/map/domain/entities/map_user.dart';
import 'package:nearme/features/map/domain/repository/map_repository.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';

import '../../../core/network/network_info_impl.dart';

class MapRepoImpl implements MapRepository {
  final FirebaseFirestore firestore;
  final NetworkInfo networkInfo;
  final FirebaseDatabase firebaseDatabase;

  MapRepoImpl({
    required this.firestore,
    required this.networkInfo,
    required this.firebaseDatabase,
  });
  StreamSubscription<Position>? _locationSubscription;

  @override
  Future<Either<Failure, List<MapUser>>> getNearbyUsers() async {
    if (!await networkInfo.isConnected) {
      return Left(NetworkFailure(message: 'No internet connection'));
    }

    try {
      final currentUserId = UserSession.instance.userId!;
      List<MapUser> nearbyUsers = [];

      //Fetch online status
      Map<dynamic, bool> userOnlineStatus = {};
      final statusSnap = await firebaseDatabase.ref('status').get();
      if (statusSnap.exists) {
        final statusData = Map<String, dynamic>.from(statusSnap.value as Map);
        statusData.forEach((key, value) {
          userOnlineStatus[key] = value['state'] == 'online';
        });
      }

      //Filter online users except current user
      final onlineUserIds = userOnlineStatus.entries
          .where((e) => e.value && e.key != currentUserId)
          .map((e) => e.key)
          .toList();

      if (onlineUserIds.isEmpty) return Right([]);

      //Fetch user documents in parallel
      final userDocs = await Future.wait(
        onlineUserIds.map(
          (userId) => firestore.collection('users').doc(userId).get(),
        ),
      );

      //Build nearby users
      for (final doc in userDocs) {
        if (!doc.exists) continue;
        final data = doc.data()!;
        final location = data['location'];
        if (location == null ||
            location['lat'] == null ||
            location['lng'] == null)
          continue;

        // Check if connected
        final connectionList = [currentUserId, doc.id]..sort();
        final connectionId = connectionList.join("_");
        final connectionDoc = await firestore
            .collection("connections")
            .doc(connectionId)
            .get();
        final isConnected = connectionDoc.exists;

        nearbyUsers.add(
          MapUser(
            id: doc.id,
            name: data['name'] ?? 'Unknown',
            major: data['dept'] ?? '---',
            avatar: data['profileImage'] ?? '',
            year: data['year'] ?? '---',
            locationInfo: LatLng(location['lat'], location['lng']),
            isConnected: isConnected,
          ),
        );
      }

      return Right(nearbyUsers);
    } catch (e) {
      return Left(ServerFailure(message: 'Error fetching nearby users: $e'));
    }
  }

  @override
  Stream<bool> listenToLocationStatus({
    Duration pollInterval = const Duration(seconds: 5),
  }) async* {
    bool lastStatus = false;

    while (true) {
      final isEnabled = await Geolocator.isLocationServiceEnabled();
      if (isEnabled != lastStatus) {
        lastStatus = isEnabled;
        yield isEnabled;
      }
      await Future.delayed(pollInterval);
    }
  }

  Future<Either<Failure, LatLng>> updateUserLocation(
    double latitude,
    double longitude,
  ) async {
    if (!await networkInfo.isConnected) {
      return Left(NetworkFailure(message: 'No internet connection'));
    }

    try {
      final userId = UserSession.instance.userId;
      final userDoc = firestore.collection('users').doc(userId);

      await userDoc.set({
        'location': {'lat': latitude, 'lng': longitude},
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      return Right(LatLng(latitude, longitude));
    } catch (e) {
      return Left(ServerFailure(message: 'Error updating location: $e'));
    }
  }

  @override
  Future<Either<Failure, LatLng>> startAutoLocationUpdates() async {
    // 1️⃣ Check if location service is enabled
    final isLocationEnabled = await Geolocator.isLocationServiceEnabled();
    if (!isLocationEnabled) {
      return Left(ServerFailure(message: 'Location services are off'));
    }

    // 2️⃣ Check permissions
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        return Left(ServerFailure(message: 'Location permission denied'));
      }
    }

    // 3️⃣ Cancel any existing subscription
    await _locationSubscription?.cancel();

    // 4️⃣ Start listening to position updates
    _locationSubscription =
        Geolocator.getPositionStream(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.high,
            distanceFilter: 10,
            timeLimit: Duration(minutes: 1),
          ),
        ).listen((position) async {
          if (position != null) {
            final result = await updateUserLocation(
              position.latitude,
              position.longitude,
            );

            result.fold(
              (failure) => print("Error updating location: ${failure.message}"),
              (latLng) => print("Location updated: $latLng"),
            );
          }
        });

    // 5️⃣ Return current position immediately if needed
    final currentPosition = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    return Right(LatLng(currentPosition.latitude, currentPosition.longitude));
  }

  Future<void> stopAutoLocationUpdates() async {
    await _locationSubscription?.cancel();
    _locationSubscription = null;
  }
}
