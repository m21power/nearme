import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:nearme/core/constant/shared_preference_constant.dart';
import 'package:nearme/core/constant/user_session.dart';
import 'package:nearme/core/error/failure.dart';
import 'package:nearme/core/network/network_info_impl.dart';
import 'package:nearme/features/profile/domain/entities/UserInfo.dart';
import 'package:nearme/features/profile/domain/repository/profile_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:io';
import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;

class ProfileRepoImpl implements ProfileRepository {
  final FirebaseFirestore firestore;
  final SharedPreferences sharedPreferences;
  final NetworkInfo networkInfo;
  ProfileRepoImpl({
    required this.firestore,
    required this.sharedPreferences,
    required this.networkInfo,
  });
  @override
  Future<Either<Failure, String>> updateBannerPhoto(String imagePath) async {
    if (await networkInfo.isConnected) {
      try {
        final imageUrl = await uploadImageToCloudinary(File(imagePath));
        if (imageUrl == null) {
          return Left(ServerFailure(message: "Failed to upload image"));
        }
        print("*****************************************************");
        print("Image uploaded to Cloudinary: $imageUrl");
        print("*****************************************************");
        // Update Firestore with new banner URL
        final user = sharedPreferences.getString(
          SharedPreferenceConstant.userKey,
        )!;
        final userId = jsonDecode(user)["userId"];
        await firestore.collection("users").doc(userId).update({
          "bannerImage": imageUrl,
        });
        UserSession.instance.bannerImage = imageUrl;
        UserSession.instance.save();
        return Right(imageUrl);
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      return Left(NetworkFailure(message: "No internet connection"));
    }
  }

  @override
  Future<Either<Failure, String>> updateProfilePicture(String imagePath) async {
    if (await networkInfo.isConnected) {
      try {
        final imageUrl = await uploadImageToCloudinary(File(imagePath));
        if (imageUrl == null) {
          return Left(ServerFailure(message: "Failed to upload image"));
        }
        print("*****************************************************");
        print("Image uploaded to Cloudinary: $imageUrl");
        print("*****************************************************");
        // Update Firestore with new profile picture URL
        final user = sharedPreferences.getString(
          SharedPreferenceConstant.userKey,
        )!;
        final userId = jsonDecode(user)["userId"];
        await firestore.collection("users").doc(userId).update({
          "profileImage": imageUrl,
        });
        UserSession.instance.profileImage = imageUrl;
        UserSession.instance.save();
        return Right(imageUrl);
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      return Left(NetworkFailure(message: "No internet connection"));
    }
  }

  @override
  Future<Either<Failure, void>> updateUserInfo(Userinfo userinfo) async {
    if (await networkInfo.isConnected) {
      try {
        final user = sharedPreferences.getString(
          SharedPreferenceConstant.userKey,
        )!;
        final userId = jsonDecode(user)["userId"];
        await firestore.collection("users").doc(userId).update({
          "name": userinfo.name,
          "bio": userinfo.bio,
          "dept": userinfo.dept,
          "year": userinfo.year,
        });
        UserSession.instance.name = userinfo.name;
        UserSession.instance.bio = userinfo.bio;
        UserSession.instance.dept = userinfo.dept;
        UserSession.instance.year = userinfo.year;
        UserSession.instance.save();
        return const Right(null);
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      return Left(NetworkFailure(message: "No internet connection"));
    }
  }
}

/// Upload an image to Cloudinary (signed) and return public URL
Future<String?> uploadImageToCloudinary(File imageFile) async {
  final cloudName = dotenv.env['CLOUDINARY_CLOUD_NAME']!;
  final apiKey = dotenv.env['CLOUDINARY_API_KEY']!;
  final apiSecret = dotenv.env['CLOUDINARY_API_SECRET']!;

  try {
    // Create timestamp for signature
    final timestamp = (DateTime.now().millisecondsSinceEpoch ~/ 1000)
        .toString();

    // Build signature string
    final signatureString = "timestamp=$timestamp$apiSecret";

    // SHA1 hash
    final signature = sha1.convert(utf8.encode(signatureString)).toString();

    final uri = Uri.parse(
      "https://api.cloudinary.com/v1_1/$cloudName/image/upload",
    );

    final request = http.MultipartRequest("POST", uri)
      ..fields['api_key'] = apiKey
      ..fields['timestamp'] = timestamp
      ..fields['signature'] = signature
      ..files.add(await http.MultipartFile.fromPath('file', imageFile.path));

    final response = await request.send();
    final resBody = await response.stream.bytesToString();
    if (response.statusCode == 200) {
      final data = jsonDecode(resBody);
      return data['secure_url']; // public HTTPS URL
    } else {
      print("Cloudinary upload failed: ${response.statusCode}");
      print(resBody);
      return null;
    }
  } catch (e) {
    print("Error uploading to Cloudinary: $e");
    return null;
  }
}
