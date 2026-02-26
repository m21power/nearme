import 'dart:convert';
import 'package:latlong2/latlong.dart';
import 'package:nearme/core/constant/shared_preference_constant.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserSession {
  // Singleton pattern
  static final UserSession instance = UserSession._internal();
  UserSession._internal();

  // User fields
  String? userId;
  String? name;
  String? dept;
  String? year;
  String? bio;
  String? profileImage;
  String? bannerImage;
  LatLng? location;
  int? postCount;
  int? connectionCount;
  bool hasActiveStory = false;
  DateTime? createdAt;
  DateTime? lastActive;

  // Load from SharedPreferences
  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(SharedPreferenceConstant.userKey);
    if (jsonString != null) {
      final Map<String, dynamic> data = jsonDecode(jsonString);
      userId = data['userId'];
      name = data['name'];
      dept = data['dept'];
      year = data['year'];
      bio = data['bio'];
      profileImage = data['profileImage'];
      bannerImage = data['bannerImage'];
      if (data['location'] != null) {
        location = LatLng(data['location']['lat'], data['location']['lng']);
      }
      postCount = data['postCount'];
      connectionCount = data['connectionCount'];
      hasActiveStory = data['hasActiveStory'] ?? false;
      createdAt = data['createdAt'] != null
          ? DateTime.parse(data['createdAt'])
          : null;
      lastActive = data['lastActive'] != null
          ? DateTime.parse(data['lastActive'])
          : null;
    }
  }

  // Save to SharedPreferences
  Future<void> save() async {
    final prefs = await SharedPreferences.getInstance();
    final data = {
      'userId': userId,
      'name': name,
      'dept': dept,
      'year': year,
      'bio': bio,
      'profileImage': profileImage,
      'bannerImage': bannerImage,
      'location': location != null
          ? {'lat': location!.latitude, 'lng': location!.longitude}
          : null,
      'postCount': postCount,
      'connectionCount': connectionCount,
      'hasActiveStory': hasActiveStory,
      'createdAt': createdAt?.toIso8601String(),
      'lastActive': lastActive?.toIso8601String(),
    };
    await prefs.setString(SharedPreferenceConstant.userKey, jsonEncode(data));
  }

  // Clear session
  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(SharedPreferenceConstant.userKey);
    userId = null;
    name = null;
    dept = null;
    year = null;
    bio = null;
    profileImage = null;
    bannerImage = null;
    location = null;
    postCount = null;
    connectionCount = null;
    hasActiveStory = false;
    createdAt = null;
    lastActive = null;
  }
}
