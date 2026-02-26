import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nearme/core/constant/route_constant.dart';
import 'package:nearme/features/auth/data/auth_repo_impl.dart';
import 'package:nearme/features/auth/presentation/pages/login_page.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF8E6BE8), // Purple
              Color(0xFF4A6CF7), // Blue
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const Spacer(),

              // Center Content
              Column(
                children: [
                  // Icon Card
                  Container(
                    height: 110,
                    width: 110,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: const Icon(
                      Icons.school,
                      size: 50,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Title
                  const Text(
                    "Near Me In\nCampus",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.w600,
                      height: 1.3,
                    ),
                  ),
                ],
              ),

              const Spacer(),

              // Bottom Tagline
              Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(bottom: 24),
                    child: Text(
                      "Connect with students around you",
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      context.goNamed(RouteConstant.loginPage);
                      // await sendOtpFunc("mesaylema21@gmail.com", "123456");
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.blueAccent,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Text("Get Started"),
                  ),
                  SizedBox(height: 40),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
