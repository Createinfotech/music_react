# Flutter Setup Guide

This guide will help you set up and run the Flutter version of MusicHub.

## Prerequisites

Before you begin, ensure you have the following installed:

1. **Flutter SDK** (version 3.0.0 or higher)
   - Download from: https://flutter.dev/docs/get-started/install
   - Follow the installation guide for your operating system

2. **Git**
   - For version control

3. **IDE** (choose one):
   - Android Studio (recommended for Android development)
   - Visual Studio Code with Flutter extension
   - IntelliJ IDEA

4. **Platform-specific requirements**:
   - For Android: Android Studio with Android SDK
   - For Web: Chrome browser

## Step-by-Step Setup

### 1. Verify Flutter Installation

```bash
flutter doctor
```

This command checks your environment and displays a report. Make sure Flutter is properly installed.

### 2. Clone the Repository

```bash
git clone https://github.com/Createinfotech/music_react.git
cd music_react/flutter_app
```

### 3. Install Dependencies

```bash
flutter pub get
```

This will download all the required packages specified in `pubspec.yaml`.

### 4. Configure API (Optional)

The app uses a default JioSaavn API endpoint. If you want to use your own:

1. Open `lib/services/api_service.dart`
2. Modify the `_defaultApiUrl` constant:

```dart
static const String _defaultApiUrl = 'YOUR_API_URL_HERE';
```

### 5. Run the App

#### For Android:

1. Start an Android emulator or connect a physical device
2. Run:
```bash
flutter run
```

#### For Web:

```bash
flutter run -d chrome
```

#### For specific device:

```bash
# List available devices
flutter devices

# Run on specific device
flutter run -d <device-id>
```

## Building for Production

### Android APK

For a release APK:

```bash
flutter build apk --release
```

The APK will be located at: `build/app/outputs/flutter-apk/app-release.apk`

### Android App Bundle (for Google Play Store)

```bash
flutter build appbundle --release
```

### Web

```bash
flutter build web --release
```

The web build will be in the `build/web/` directory. You can deploy this to any static hosting service.

## Troubleshooting

### Issue: "Flutter SDK not found"

**Solution**: Add Flutter to your PATH:

```bash
# On macOS/Linux
export PATH="$PATH:[PATH_TO_FLUTTER_GIT_DIRECTORY]/flutter/bin"

# On Windows
# Add to System Environment Variables
```

### Issue: Android build fails with "license not accepted"

**Solution**: Accept Android licenses:

```bash
flutter doctor --android-licenses
```

### Issue: "Waiting for another flutter command to release the startup lock"

**Solution**: Delete the lock file:

```bash
# On macOS/Linux
rm [PATH_TO_FLUTTER_GIT_DIRECTORY]/flutter/bin/cache/lockfile

# On Windows
del [PATH_TO_FLUTTER_GIT_DIRECTORY]\flutter\bin\cache\lockfile
```

### Issue: Audio not playing

**Solution**:
1. Check internet connection
2. Verify the API endpoint is accessible
3. On Android, ensure proper permissions are granted
4. Check device volume

### Issue: CORS error on web

**Solution**:
- The API must support CORS for web deployment
- For development, you can use Chrome with disabled security (not recommended for production):
  ```bash
  flutter run -d chrome --web-browser-flag "--disable-web-security"
  ```

## Testing

Run tests (when available):

```bash
flutter test
```

## Code Quality

### Format code:

```bash
flutter format lib/
```

### Analyze code:

```bash
flutter analyze
```

## Hot Reload and Hot Restart

While the app is running:
- Press `r` for hot reload (preserves state)
- Press `R` for hot restart (resets state)
- Press `q` to quit

## Additional Resources

- [Flutter Documentation](https://flutter.dev/docs)
- [Dart Language Tour](https://dart.dev/guides/language/language-tour)
- [Flutter Cookbook](https://flutter.dev/docs/cookbook)
- [Flutter Community](https://flutter.dev/community)

## Platform-Specific Notes

### Android

- Minimum SDK: API 21 (Android 5.0 Lollipop)
- Target SDK: API 34
- Permissions required: Internet, Storage (for downloads)

### Web

- Requires modern browser with ES6 support
- Audio playback requires HTTPS in production
- CORS must be enabled on API server

### iOS (Future Support)

iOS support requires:
- macOS with Xcode installed
- Apple Developer account (for physical device testing and App Store)
- CocoaPods dependency manager

To enable iOS:
1. Navigate to ios directory
2. Run `pod install`
3. Open `ios/Runner.xcworkspace` in Xcode
4. Configure signing & capabilities

## Next Steps

1. Explore the app features
2. Customize the UI/theme in `lib/main.dart`
3. Add more features or modify existing ones
4. Test on different devices and screen sizes
5. Deploy to production

## Getting Help

If you encounter issues:

1. Check the [Flutter documentation](https://flutter.dev/docs)
2. Search [Stack Overflow](https://stackoverflow.com/questions/tagged/flutter)
3. Open an issue on the GitHub repository
4. Join [Flutter Discord](https://discord.gg/flutter)

## Performance Tips

1. Use `const` constructors when possible
2. Implement proper list view builders for long lists
3. Cache network images
4. Use `flutter build --release` for production builds
5. Profile your app using Flutter DevTools

Happy coding! 🎵
