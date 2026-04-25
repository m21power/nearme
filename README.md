# NearMe

NearMe is a campus social networking app built with Flutter. It combines social feed features (posts, comments, stories), real-time chat, nearby-user discovery on a map, notifications, and user profile management.

The app uses a Clean Architecture style with feature-first modules, BLoC for state management, `get_it` for dependency injection, Firestore + Realtime Database for backend data, and local notifications for in-app events.

## Core Features

- Email OTP login flow
- Campus feed with create/like/comment/delete post actions
- Story system (create/view/like/delete + viewer tracking)
- Connection system (suggestions, requests, accept/decline, list)
- Real-time chat with unread counts and read receipts
- Nearby users map with live location updates
- In-app notification center (chat and social events)
- Profile editing (bio/department/year/profile image/banner image)

## Tech Stack

- Flutter + Dart (SDK `^3.9.2`)
- BLoC (`flutter_bloc`) + Equatable
- Dependency injection with `get_it`
- Routing via `go_router`
- Firebase Core + Cloud Firestore
- Firebase Realtime Database (presence + status)
- Geolocation via `geolocator`
- Map rendering via `flutter_map` + `latlong2`
- Local notifications via `flutter_local_notifications`
- Local persistence via `shared_preferences`
- Environment config via `flutter_dotenv`
- Media upload with Cloudinary (from app)

## Architecture Overview

The project follows feature-based Clean Architecture:

- `data`: repository implementations and external data access
- `domain`: entities, repository contracts, and use cases
- `presentation`: blocs, pages, widgets

Cross-cutting concerns live under `lib/core`:

- `core/route`: app routing (`go_router`)
- `core/theme`: light/dark theme definitions
- `core/network`: connectivity abstraction
- `core/constant`: app constants/session helpers
- `core/utils`: reusable UI and utility helpers

## `lib` Folder Structure

```text
lib/
	main.dart
	dependency_injection.dart
	firebase_options.dart
	splash_screen.dart
	core/
		constant/
		error/
		network/
		route/
		theme/
		utils/
	features/
		auth/
			data/
			domain/
			presentation/
		home/
			data/
			domain/
			presentation/
		chat/
			data/
			domain/
			presentation/
		map/
			data/
			domain/
			presentation/
		notification/
			data/
			domain/
			presentation/
		profile/
			data/
			domain/
			presentation/
```

## App Flow (High Level)

1. `main.dart` initializes Firebase, local notifications, dotenv, and dependency injection.
2. `AuthBloc` checks login status from local storage.
3. Router (`/`) decides between `MainNavigationPage` and `SplashScreen`.
4. `MainNavigationPage` hosts five primary tabs:
   - Home
   - Map
   - Create Post
   - Chat
   - Profile

## Prerequisites

- Flutter SDK installed and available in PATH
- Dart SDK compatible with Flutter used in this project
- Android Studio and/or Xcode for mobile builds
- Firebase project configured for Android/iOS
- A valid MapTiler key
- Cloudinary credentials (if using profile/banner uploads)

## Setup

### 1) Clone and install dependencies

```bash
git clone <your-repo-url>
cd nearme
flutter pub get
```

### 2) Configure environment variables

Create a `.env` file in the project root:

```env
MAP_KEY=your_maptiler_key
ADMIN_USERID=admin_user_identifier
API_KEY=your_email_provider_api_key
CLOUDINARY_CLOUD_NAME=your_cloudinary_cloud_name
CLOUDINARY_API_KEY=your_cloudinary_api_key
CLOUDINARY_API_SECRET=your_cloudinary_api_secret
```

Notes:

- `.env` is loaded at app startup in `main.dart`.
- `MAP_KEY` is required for map tiles.
- `ADMIN_USERID` is used in some UI logic for admin-specific actions.
- `API_KEY` is used by OTP email helper logic.
- Cloudinary keys are required for image upload in profile module.

### 3) Firebase setup

This repo already contains:

- `lib/firebase_options.dart`
- `android/app/google-services.json`
- `firebase.json`

If you need to regenerate config for another Firebase project:

```bash
dart pub global activate flutterfire_cli
flutterfire configure
```

### 4) Platform permissions

Android permissions are declared in `android/app/src/main/AndroidManifest.xml`, including:

- Camera and storage read
- Internet
- Fine/coarse/background location
- Notifications

iOS `Info.plist` may still need location usage descriptions for full location support. Add them if you plan to run map/location features on iOS.

## Run the App

```bash
flutter run
```

Useful commands:

```bash
flutter analyze
flutter test
```

## Module Details

### Auth

- OTP-based email login
- Login persistence via `SharedPreferences`
- User bootstrap document creation in Firestore (`users`)

### Home (Feed + Story + Connections)

- Post CRUD actions and comments
- Story creation/view/like/delete
- Connection suggestions and request workflows

### Chat

- User chat list stream
- Message stream in chat threads
- Read-state handling and unread counters
- Presence integration via Realtime Database `status`

### Map

- Tracks current location (when enabled)
- Pushes user coordinates to Firestore
- Fetches nearby online users from Firestore + Realtime Database status
- Shows selected user info in bottom sheet

### Notifications

- Firestore-backed notification stream
- Batch mark-as-read
- Local notification initialization and display support

### Profile

- Edit profile fields
- Update avatar and banner images
- Cloudinary image upload pipeline
- View user posts and basic profile stats

## Important Collections / Data Sources

- Firestore collections seen in code:
  - `users`
  - `OtpCollection`
  - `posts`
  - `connections`
  - `chats`
  - `notifications`
- Realtime Database paths:
  - `status`
  - `.info/connected`

## Known Caveats

- Some development code paths currently include debug prints.
- OTP send flow has a helper for external email API, but OTP storage/check logic is also handled in Firestore.
- Cloudinary API secret is read on client side in current implementation. For production-grade security, move signing/upload auth to a trusted backend service.

## Troubleshooting

### App fails at startup

- Ensure `.env` exists and all required keys are present.
- Verify Firebase configuration files are correctly set for your app id.

### Map not loading

- Check `MAP_KEY` value.
- Confirm location service and permissions are enabled on the device.

### Chat online status missing

- Confirm Realtime Database rules and connectivity are correctly configured.

### Image upload failing

- Validate Cloudinary credentials.
- Check network connectivity and request limits.

## Future Improvements (Suggested)

- Move secret-dependent upload/email signing to backend
- Add integration tests for major feature flows
- Improve iOS permission documentation and parity checks
- Add CI checks for format/analyze/test
