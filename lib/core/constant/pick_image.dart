import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nearme/core/theme/light_theme.dart';

/// Pick image, confirm, and return the File
Future<File?> pickAndConfirmImage(BuildContext context, String title) async {
  final ImagePicker picker = ImagePicker();

  // Pick an image from gallery
  final XFile? pickedFile = await picker.pickImage(
    source: ImageSource.gallery,
    imageQuality: 80, // optional: reduce size
  );

  if (pickedFile == null) return null; // User canceled

  final File imageFile = File(pickedFile.path);

  final bool? confirm = await showDialog<bool>(
    context: context,
    builder: (context) {
      final theme = Theme.of(context); // Use your existing theme

      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 10,
        backgroundColor: theme.colorScheme.surface,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              /// Title with Icon
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.image, color: theme.colorScheme.primary, size: 28),
                  const SizedBox(width: 8),
                  Text(
                    "Confirm Image",
                    style: theme.textTheme.headlineLarge?.copyWith(
                      fontSize: 20,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              /// Image Preview
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: AppLightTheme.borderColor,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Image.file(
                    imageFile,
                    fit: BoxFit.contain, // <-- ensures full image is shown
                    width: double.infinity,
                    height:
                        MediaQuery.of(context).size.height * 0.4, // big preview
                  ),
                ),
              ),

              const SizedBox(height: 16),

              /// Description Text
              Text(
                "Please confirm that you want to use this image as your $title image.",
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyLarge,
              ),

              const SizedBox(height: 24),

              /// Action Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  OutlinedButton(
                    onPressed: () => Navigator.pop(context, false),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: AppLightTheme.borderColor),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                    child: const Text("Cancel", style: TextStyle(fontSize: 16)),
                  ),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context, true),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                    child: const Text(
                      "Confirm",
                      style: TextStyle(fontSize: 16, color: Colors.white),
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

  if (confirm == true) {
    return imageFile;
  }

  return null; // User canceled in dialog
}
