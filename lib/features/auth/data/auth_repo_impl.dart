import 'dart:math';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:nearme/core/error/failure.dart';
import 'package:nearme/core/network/network_info_impl.dart';
import 'package:nearme/features/auth/domain/repository/auth_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepoImpl implements AuthRepository {
  final SharedPreferences sharedPreferences;
  final FirebaseFirestore firestore;
  final NetworkInfo networkInfo;
  AuthRepoImpl({
    required this.sharedPreferences,
    required this.firestore,
    required this.networkInfo,
  });
  @override
  Future<Either<Failure, void>> checkLoginStatus() async {
    try {
      final isLoggedIn = sharedPreferences.getBool('isLoggedIn') ?? false;
      if (isLoggedIn) {
        return Right(null);
      } else {
        return Left(AuthFailure(message: 'User not logged in'));
      }
    } catch (e) {
      return Left(AuthFailure(message: 'Error checking login status: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> sendOtp(String email) async {
    if (!await networkInfo.isConnected) {
      return Left(NetworkFailure(message: 'No internet connection'));
    }
    try {
      await Future.delayed(
        const Duration(seconds: 3),
      ); // Simulate network delay
      String otp = _generateOtp();

      firestore.collection('OtpCollection').doc(email).set({
        'otp': "123456",
        'timestamp': FieldValue.serverTimestamp(),
      });
      // var result = await sendOtpFunc(email, otp);
      // if (result.isLeft()) {
      //   return Left(AuthFailure(message: 'Failed to send OTP'));
      // }
      return Right(null);
    } catch (e) {
      return Left(AuthFailure(message: 'Error sending OTP: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> verifyOtp(String email, String otp) async {
    if (!await networkInfo.isConnected) {
      return Left(NetworkFailure(message: 'No internet connection'));
    }
    try {
      final doc = await firestore.collection('OtpCollection').doc(email).get();
      if (!doc.exists) {
        return Left(AuthFailure(message: 'OTP not found for this email'));
      }
      final data = doc.data();
      if (data == null || data['otp'] != otp) {
        return Left(AuthFailure(message: 'Invalid OTP'));
      }
      final timestamp = data['timestamp'] as Timestamp?;
      if (timestamp == null ||
          DateTime.now().difference(timestamp.toDate()).inMinutes > 15) {
        return Left(AuthFailure(message: 'OTP expired'));
      }
      await sharedPreferences.setBool('isLoggedIn', true);
      return Right(null);
    } catch (e) {
      return Left(AuthFailure(message: 'Error verifying OTP: $e'));
    }
  }

  @override
  Future<void> logout() async {
    await sharedPreferences.clear();
    return Future.value();
  }
}

String _generateOtp() {
  final random = Random();
  return (100000 + random.nextInt(900000)).toString();
}

Future<Either<Failure, void>> sendOtpFunc(String email, String otp) async {
  final url = Uri.parse('https://api.brevo.com/v3/smtp/email');
  final API_KEY = dotenv.env['API_KEY'];
  if (API_KEY == null) {
    return Left(
      AuthFailure(message: 'API key not found in environment variables'),
    );
  }
  if (email.isEmpty || otp.isEmpty) {
    return Left(AuthFailure(message: 'Email or OTP cannot be empty'));
  }
  final headers = {'api-key': API_KEY, 'Content-Type': 'application/json'};

  final body = jsonEncode({
    'sender': {'name': 'NearMe App', 'email': 'nearbyme21@gmail.com'},
    'to': [
      {'email': email},
    ],
    'subject': 'Your NearMe OTP Code',
    'htmlContent':
        '''
  <div style="font-family: Arial, sans-serif; background-color: #f4f4f4; padding: 20px;">
    <div style="max-width: 600px; margin: auto; background-color: #ffffff; padding: 30px; border-radius: 10px; box-shadow: 0 0 10px rgba(0,0,0,0.1);">
      <h2 style="color: #333333; text-align: center;">NearbyMe Verification</h2>
      <p style="color: #555555; font-size: 16px; text-align: center;">
        Hi <strong>$email</strong>,<br>
        Use the OTP below to verify your account. This code is valid for <strong>15 minutes</strong>.
      </p>
      <div style="text-align: center; margin: 30px 0;">
        <span style="
          display: inline-block;
          padding: 15px 25px;
          font-size: 24px;
          font-weight: bold;
          color: #ffffff;
          background-color: #4CAF50;
          border-radius: 8px;
          letter-spacing: 2px;
        ">$otp</span>
      </div>
      <p style="color: #777777; font-size: 14px; text-align: center;">
        If you did not request this code, please ignore this email.
      </p>
      <hr style="border: none; border-top: 1px solid #eeeeee; margin: 20px 0;">
      <p style="color: #999999; font-size: 12px; text-align: center;">
        NearbyMe App • your trusted local guide
      </p>
    </div>
  </div>
  ''',
  });

  final response = await http.post(url, headers: headers, body: body);

  if (response.statusCode == 201 || response.statusCode == 200) {
    return Right(null);
  } else {
    return Left(AuthFailure(message: 'Failed to send OTP: ${response.body}'));
  }
}
