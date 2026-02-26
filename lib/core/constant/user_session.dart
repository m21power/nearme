// import 'dart:convert';
// import 'package:shared_preferences/shared_preferences.dart';

// class UserSession {
//   // Singleton pattern
//   static final UserSession instance = UserSession._internal();
//   UserSession._internal();

//   // User fields
//   String? userId;
//   String? phoneNumber;
//   String? fullName;
//   String? username;
//   String? password;
//   String? gender;

//   // Load from SharedPreferences
//   Future<void> load() async {
//     final prefs = await SharedPreferences.getInstance();
//     final jsonString = prefs.getString(SharedPreferenceConstant.userKey);
//     if (jsonString != null) {
//       final Map<String, dynamic> data = jsonDecode(jsonString);
//       userId = data['userId'];
//       phoneNumber = data['phoneNumber'];
//       fullName = data['fullName'];
//       username = data['username'];
//       password = data['password'];
//       gender = data['gender'];
//     }
//   }

//   // Save to SharedPreferences
//   Future<void> save() async {
//     final prefs = await SharedPreferences.getInstance();
//     final data = {
//       'userId': userId,
//       'phoneNumber': phoneNumber,
//       'fullName': fullName,
//       'username': username,
//       'password': password,
//       'gender': gender,
//     };
//     await prefs.setString(SharedPreferenceConstant.userKey, jsonEncode(data));
//   }

//   // Clear session
//   Future<void> clear() async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.remove(SharedPreferenceConstant.userKey);
//     userId = null;
//     phoneNumber = null;
//     fullName = null;
//     username = null;
//     password = null;
//     gender = null;
//   }
// }
