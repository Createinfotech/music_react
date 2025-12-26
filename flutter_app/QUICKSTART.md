# Quick Start Guide for Flutter MusicHub

Get up and running in 5 minutes!

## Prerequisites Check

Before starting, verify you have:
- [ ] Flutter SDK installed (`flutter --version`)
- [ ] A code editor (VS Code or Android Studio)
- [ ] For Android: Android emulator or device
- [ ] For Web: Chrome browser

## 5-Minute Setup

### Step 1: Get the Code (1 min)

```bash
git clone https://github.com/Createinfotech/music_react.git
cd music_react/flutter_app
```

### Step 2: Install Dependencies (2 min)

```bash
flutter pub get
```

Wait for packages to download. This includes:
- Audio player
- HTTP client
- State management
- UI utilities

### Step 3: Run the App (2 min)

#### Option A: Android

```bash
# Make sure device/emulator is running
flutter devices

# Run the app
flutter run
```

#### Option B: Web

```bash
flutter run -d chrome
```

That's it! The app should now be running. 🎉

## First Use

1. **Browse**: Scroll through latest songs, albums, and artists on the home page
2. **Search**: Tap the search icon to find specific music
3. **Play**: Tap any song card to start playing
4. **Theme**: Toggle between light and dark mode

## Common First-Run Issues

### "No devices found"

**Android**:
```bash
# List available devices
adb devices

# If empty, start an emulator from Android Studio
# Or connect a physical device with USB debugging enabled
```

**Web**:
```bash
# Make sure Chrome is installed
flutter run -d chrome
```

### "Build failed"

```bash
# Clean and rebuild
flutter clean
flutter pub get
flutter run
```

### "Audio not playing"

- Check internet connection (app streams music online)
- Verify device volume is up
- On Android: Grant necessary permissions when prompted

## Next Steps

Once running successfully:

1. **Explore Features**:
   - Browse different sections (Songs, Albums, Artists, Trending)
   - Use the search functionality
   - Try the music player controls
   - Switch between light/dark theme

2. **Customize** (Optional):
   - Change theme colors in `lib/main.dart`
   - Modify API endpoint in `lib/services/api_service.dart`
   - Adjust UI layouts in screen files

3. **Build for Production**:
   ```bash
   # Android APK
   flutter build apk --release
   
   # Web
   flutter build web --release
   ```

## Useful Commands

```bash
# Hot reload (while app is running)
r

# Hot restart
R

# Quit
q

# Run with verbose logging
flutter run -v

# Check for issues
flutter doctor

# Format code
flutter format lib/

# Analyze code
flutter analyze
```

## Development Tips

1. **Hot Reload**: Save files to see changes instantly without restarting
2. **DevTools**: Press `Shift + ?` while running to see all commands
3. **Logs**: Watch the console for any errors or warnings
4. **UI Inspector**: Use Flutter DevTools to inspect widget tree

## Getting Help

If you get stuck:

1. Check the full [README](README.md)
2. Read the [SETUP_GUIDE](SETUP_GUIDE.md)
3. Review [Flutter documentation](https://flutter.dev/docs)
4. Open an issue on GitHub

## Troubleshooting Quick Fixes

```bash
# Reset everything
flutter clean
rm -rf build/
flutter pub get
flutter run

# Update Flutter
flutter upgrade

# Accept Android licenses
flutter doctor --android-licenses
```

## What's Next?

After getting the app running:

- 📱 Try building an APK and installing on your phone
- 🌐 Build for web and deploy to a hosting service
- 🎨 Customize the UI to match your preferences
- 🔧 Add new features or modify existing ones
- 📚 Explore the [COMPARISON](COMPARISON.md) with the React version

Happy coding! 🎵✨
