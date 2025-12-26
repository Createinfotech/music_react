# MusicHub Flutter

A cross-platform music streaming application built with Flutter, supporting both Android and Web platforms. This is a Flutter recreation of the original Next.js React MusicHub application.

## Features

- 🎵 **Browse Music**: Discover latest songs, albums, and artists
- 🔍 **Search**: Search for your favorite songs, albums, and artists
- 🎧 **Music Player**: Full-featured audio player with:
  - Play/Pause controls
  - Seek functionality
  - Loop mode
  - Download capability (coming soon)
  - Share functionality
- 📱 **Responsive Design**: Works seamlessly on mobile and web
- 🌓 **Theme Support**: Light and Dark mode
- 💿 **Album View**: Browse album details and tracks
- 🎼 **Recommendations**: Get song suggestions based on current track

## Supported Platforms

- ✅ Android (API 21+)
- ✅ Web
- 🔄 iOS (requires additional setup)

## Prerequisites

- Flutter SDK (3.0.0 or higher)
- Dart SDK (3.0.0 or higher)
- Android Studio / VS Code with Flutter extensions
- For Android: Android SDK and emulator/device
- For Web: Chrome or any modern browser

## Installation

### 1. Clone the repository

```bash
git clone https://github.com/Createinfotech/music_react.git
cd music_react/flutter_app
```

### 2. Install dependencies

```bash
flutter pub get
```

### 3. Configure API

The app uses the JioSaavn API with automatic fallback to multiple endpoints. The app is pre-configured with several public API endpoints and includes retry logic for better reliability.

**If you experience API connection errors**, see [API_CONFIGURATION.md](./API_CONFIGURATION.md) for detailed setup instructions.

To use your own API endpoint, edit `lib/services/api_service.dart` and update the `_apiUrls` list with your deployment URL from [JioSaavn API](https://github.com/sumitkolhe/jiosaavn-api).

## Running the App

### Android

Connect an Android device or start an emulator, then run:

```bash
flutter run
```

### Web

To run on web:

```bash
flutter run -d chrome
```

Or to build for production:

```bash
flutter build web
```

The built files will be in `build/web/` directory.

## Building for Production

### Android APK

```bash
flutter build apk --release
```

The APK will be available at: `build/app/outputs/flutter-apk/app-release.apk`

### Android App Bundle (for Google Play)

```bash
flutter build appbundle --release
```

### Web

```bash
flutter build web --release
```

Deploy the `build/web/` directory to your web server.

## Project Structure

```
flutter_app/
├── lib/
│   ├── main.dart                 # App entry point
│   ├── models/                   # Data models
│   │   └── music_models.dart     # Song, Album, Artist models
│   ├── providers/                # State management
│   │   ├── music_provider.dart   # Music playback state
│   │   └── theme_provider.dart   # Theme state
│   ├── screens/                  # App screens
│   │   ├── home_screen.dart      # Home page
│   │   ├── player_screen.dart    # Music player
│   │   ├── search_screen.dart    # Search page
│   │   └── album_screen.dart     # Album details
│   ├── services/                 # API services
│   │   └── api_service.dart      # API client
│   └── widgets/                  # Reusable widgets
│       ├── song_card.dart
│       ├── album_card.dart
│       ├── artist_card.dart
│       └── app_header.dart
├── android/                      # Android platform code
├── web/                          # Web platform code
├── assets/                       # Images, icons
└── pubspec.yaml                  # Dependencies
```

## Dependencies

Key packages used:

- **provider**: State management
- **just_audio**: Audio playback
- **http/dio**: API requests
- **cached_network_image**: Image caching
- **shared_preferences**: Local storage
- **share_plus**: Share functionality
- **url_launcher**: Open URLs

See `pubspec.yaml` for the complete list.

## Features Comparison with React Version

| Feature | React (Next.js) | Flutter |
|---------|----------------|---------|
| Home Page | ✅ | ✅ |
| Search | ✅ | ✅ |
| Album View | ✅ | ✅ |
| Music Player | ✅ | ✅ |
| Theme Toggle | ✅ | ✅ |
| Mobile Responsive | ✅ | ✅ |
| Web Support | ✅ | ✅ |
| Android App | ❌ | ✅ |
| iOS App | ❌ | ✅ |
| Download Songs | ✅ | 🔄 |
| Share Songs | ✅ | ✅ |

## API Integration

The app integrates with the JioSaavn API (unofficial). Available endpoints:

- Search songs: `/search/songs?query={query}`
- Search albums: `/search/albums?query={query}`
- Get song by ID: `/songs/{id}`
- Get album by ID: `/albums?id={id}`
- Get song suggestions: `/songs/{id}/suggestions`

## Troubleshooting

### API Connection Errors

If you see errors like `ClientException: Failed to fetch`:

1. The app automatically tries multiple API endpoints
2. Check [API_CONFIGURATION.md](./API_CONFIGURATION.md) for detailed troubleshooting
3. Verify at least one API endpoint is accessible
4. Consider deploying your own API instance

### Android Build Issues

If you encounter build issues:

1. Clean the project: `flutter clean`
2. Get dependencies: `flutter pub get`
3. Rebuild: `flutter build apk`

### Audio Playback Issues

If audio doesn't play:

1. Check internet connection
2. Verify API URL is accessible
3. Check device volume settings

### Web Issues

For CORS issues on web:

1. Use a CORS-enabled API endpoint
2. Configure your web server to allow CORS
3. For development, use Chrome with `--disable-web-security` flag (not recommended for production)

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgments

- Original React version by [r2hu1](https://github.com/r2hu1)
- JioSaavn API by [sumitkolhe](https://github.com/sumitkolhe/jiosaavn-api)
- Flutter framework by Google

## Support

For issues and questions, please open an issue on GitHub.
