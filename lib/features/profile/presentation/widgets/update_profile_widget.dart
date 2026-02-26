import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nearme/features/profile/domain/entities/UserInfo.dart';
import 'package:nearme/features/profile/domain/usecases/update_user_info_usecase.dart';
import 'package:nearme/features/profile/presentation/bloc/profile_bloc.dart';

import '../../../../core/constant/user_session.dart';

void showEditProfileDialog(BuildContext context) {
  final theme = Theme.of(context);
  final colors = theme.colorScheme;

  final nameController = TextEditingController(
    text: UserSession.instance.name ?? "",
  );
  final bioController = TextEditingController(
    text: UserSession.instance.bio ?? "",
  );
  final yearController = TextEditingController(
    text: UserSession.instance.year ?? "",
  );
  final deptController = TextEditingController(
    text: UserSession.instance.dept ?? "",
  );

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(25)),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                /// HEADER
                Row(
                  children: [
                    Icon(Icons.edit, color: colors.primary),
                    const SizedBox(width: 10),
                    Text(
                      "Edit Profile",
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 25),

                /// NAME
                _buildInputField(
                  controller: nameController,
                  label: "Full Name",
                  icon: Icons.person,
                ),

                const SizedBox(height: 15),

                /// DEPARTMENT
                _buildInputField(
                  controller: deptController,
                  label: "Department",
                  icon: Icons.school,
                ),

                const SizedBox(height: 15),

                /// YEAR
                _buildInputField(
                  controller: yearController,
                  label: "Year (Class of ...)",
                  icon: Icons.calendar_today,
                  keyboardType: TextInputType.number,
                ),

                const SizedBox(height: 15),

                /// BIO
                _buildInputField(
                  controller: bioController,
                  label: "Bio",
                  icon: Icons.info_outline,
                  maxLines: 3,
                ),

                const SizedBox(height: 30),

                /// ACTION BUTTONS
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size.fromHeight(50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: const Text("Cancel"),
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          if (nameController.text.trim().isEmpty) return;

                          // Save safe references BEFORE anything async
                          final bloc = context.read<ProfileBloc>();
                          final parentContext = context;

                          final confirmed = await _confirmProfileUpdate(
                            parentContext,
                          );
                          if (!confirmed) return;

                          Navigator.pop(parentContext); // close edit dialog

                          bloc.add(
                            UpdateProfileInfoEvent(
                              userinfo: Userinfo(
                                name: nameController.text.trim(),
                                bio: bioController.text.trim(),
                                year: yearController.text.trim(),
                                dept: deptController.text.trim(),
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: const Text(
                          "Update",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}

Widget _buildInputField({
  required TextEditingController controller,
  required String label,
  required IconData icon,
  TextInputType keyboardType = TextInputType.text,
  int maxLines = 1,
}) {
  return TextField(
    controller: controller,
    keyboardType: keyboardType,
    maxLines: maxLines,
    decoration: InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
      filled: true,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(width: 2),
      ),
    ),
  );
}

Future<bool> _confirmProfileUpdate(BuildContext context) async {
  final theme = Theme.of(context);
  final colors = theme.colorScheme;

  final result = await showDialog<bool>(
    context: context,
    builder: (context) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.help_outline, size: 50, color: colors.primary),
              const SizedBox(height: 20),
              Text(
                "Confirm Update",
                // style: theme.textTheme.titleLarge?.copyWith(
                //   fontWeight: FontWeight.bold,
                // ),
              ),
              const SizedBox(height: 12),
              Text(
                "Are you sure you want to update your profile information?",
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: 30),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context, false),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size.fromHeight(48),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: const Text("Cancel"),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context, true),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(48),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: const Text(
                        "Yes, Update",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );

  return result ?? false;
}
