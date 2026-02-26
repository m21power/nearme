import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:nearme/features/auth/presentation/bloc/auth_bloc.dart';

import '../../../../core/constant/route_constant.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool otpSent = false;

  final TextEditingController usernameController = TextEditingController();
  final List<TextEditingController> otpControllers = List.generate(
    6,
    (_) => TextEditingController(),
  );
  bool isLoading = false;
  final List<FocusNode> otpFocusNodes = List.generate(6, (_) => FocusNode());
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, authState) {
          print("authstate: $authState");
          if (authState is AuthLoading) {
            setState(() => isLoading = true);
          } else {
            setState(() => isLoading = false);
          }
          if (authState is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: Colors.red,
                content: Text(
                  authState.message,
                  style: TextStyle(color: Colors.white),
                ),
              ),
            );
          }
          if (authState is AuthOtpVerified) {
            // context.read<AuthBloc>().add(AuthCheckLoginStatusEvent());
            context.goNamed(RouteConstant.mainNavigation);
          }
        },
        builder: (context, authState) {
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 40),

                  /// Top Icon
                  Container(
                    height: 70,
                    width: 70,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.school,
                      color: theme.colorScheme.primary,
                      size: 32,
                    ),
                  ),

                  const SizedBox(height: 24),

                  /// Title
                  Text(
                    "Near Me In Campus",
                    style: theme.textTheme.headlineLarge,
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 12),

                  /// Subtitle
                  Text(
                    "Join your campus community. Log in\nsecurely via Telegram.",
                    style: theme.textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 40),

                  /// Username Label
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Email", style: theme.textTheme.bodyLarge),
                  ),

                  const SizedBox(height: 8),

                  /// Username Field
                  TextField(
                    controller: usernameController,
                    decoration: InputDecoration(hintText: "Enter your email"),
                  ),

                  const SizedBox(height: 24),

                  /// OTP Section
                  if (otpSent) ...[
                    Text(
                      "Enter the code sent to your email",
                      style: theme.textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(
                        6,
                        (index) => _OtpBox(
                          controller: otpControllers[index],
                          focusNode: otpFocusNodes[index],
                          nextFocus: index < 5
                              ? otpFocusNodes[index + 1]
                              : null,
                        ),
                      ),
                    ),
                  ],

                  const Spacer(),

                  /// Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        final email = usernameController.text.trim();

                        if (!otpSent) {
                          if (!isValidEmail(email)) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  "Please enter a valid email",
                                  style: TextStyle(color: Colors.white),
                                ),
                                backgroundColor: Colors.red,
                              ),
                            );
                            return;
                          }
                          context.read<AuthBloc>().add(
                            AuthSendOtpEvent(email: email),
                          );
                          setState(() => otpSent = true);
                        } else {
                          String otp = otpControllers.map((c) => c.text).join();
                          context.read<AuthBloc>().add(
                            AuthVerifyOtpEvent(email: email, otp: otp),
                          );
                        }
                      },
                      child: isLoading
                          ? const SizedBox(
                              height: 16,
                              width: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : Text(otpSent ? "Confirm" : "Send OTP"),
                    ),
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  bool isValidEmail(String email) {
    final regex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return regex.hasMatch(email);
  }
}

class _OtpBox extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final FocusNode? nextFocus;

  const _OtpBox({
    required this.controller,
    required this.focusNode,
    this.nextFocus,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      width: 48,
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 1,
        style: theme.textTheme.bodyLarge,
        decoration: const InputDecoration(
          counterText: "",
          contentPadding: EdgeInsets.symmetric(vertical: 14),
        ),
        onChanged: (value) {
          if (value.isNotEmpty && nextFocus != null) {
            FocusScope.of(context).requestFocus(nextFocus);
          }
        },
      ),
    );
  }
}
