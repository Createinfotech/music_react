# Deployment Guide

This guide covers deploying the Flutter MusicHub app to various platforms.

## Table of Contents

1. [Android Deployment](#android-deployment)
2. [Web Deployment](#web-deployment)
3. [CI/CD Setup](#cicd-setup)
4. [Environment Configuration](#environment-configuration)

---

## Android Deployment

### Option 1: Development APK (Quick Testing)

For quick testing on devices:

```bash
# Build debug APK
flutter build apk --debug

# Install on connected device
flutter install
```

APK location: `build/app/outputs/flutter-apk/app-debug.apk`

### Option 2: Release APK (Production)

For distribution outside Google Play:

```bash
# Build release APK
flutter build apk --release

# Optional: Build split APKs by ABI (smaller size)
flutter build apk --split-per-abi --release
```

APK locations:
- `build/app/outputs/flutter-apk/app-release.apk`
- `build/app/outputs/flutter-apk/app-armeabi-v7a-release.apk`
- `build/app/outputs/flutter-apk/app-arm64-v8a-release.apk`
- `build/app/outputs/flutter-apk/app-x86_64-release.apk`

### Option 3: App Bundle (Google Play Store)

For official Google Play Store distribution:

#### 1. Create a Keystore (First Time Only)

```bash
keytool -genkey -v -keystore ~/upload-keystore.jks \
  -storetype JKS -keyalg RSA -keysize 2048 -validity 10000 \
  -alias upload
```

#### 2. Configure Signing

Create `android/key.properties`:

```properties
storePassword=<your-store-password>
keyPassword=<your-key-password>
keyAlias=upload
storeFile=<path-to-your-keystore>/upload-keystore.jks
```

#### 3. Update `android/app/build.gradle`

Add before `android` block:

```gradle
def keystoreProperties = new Properties()
def keystorePropertiesFile = rootProject.file('key.properties')
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(new FileInputStream(keystorePropertiesFile))
}

android {
    // ... existing config

    signingConfigs {
        release {
            keyAlias keystoreProperties['keyAlias']
            keyPassword keystoreProperties['keyPassword']
            storeFile keystoreProperties['storeFile'] ? file(keystoreProperties['storeFile']) : null
            storePassword keystoreProperties['storePassword']
        }
    }
    buildTypes {
        release {
            signingConfig signingConfigs.release
        }
    }
}
```

#### 4. Build App Bundle

```bash
flutter build appbundle --release
```

Bundle location: `build/app/outputs/bundle/release/app-release.aab`

#### 5. Upload to Google Play Console

1. Go to [Google Play Console](https://play.google.com/console)
2. Create a new app or select existing
3. Navigate to Release > Production
4. Upload the `.aab` file
5. Complete the store listing
6. Submit for review

### Android App Requirements

- Minimum SDK: API 21 (Android 5.0)
- Target SDK: API 34 (Android 14)
- Permissions:
  - Internet (required)
  - Storage (for downloads)

---

## Web Deployment

### Build for Production

```bash
# Build optimized web version
flutter build web --release

# With custom base href (for subdirectory deployment)
flutter build web --release --base-href /musichub/
```

Output directory: `build/web/`

### Deployment Options

#### Option 1: Firebase Hosting

1. Install Firebase CLI:
```bash
npm install -g firebase-tools
```

2. Initialize Firebase:
```bash
cd build/web
firebase init hosting
```

3. Deploy:
```bash
firebase deploy --only hosting
```

#### Option 2: Netlify

1. Install Netlify CLI:
```bash
npm install -g netlify-cli
```

2. Deploy:
```bash
cd build/web
netlify deploy --prod
```

Or use drag-and-drop at [netlify.com/drop](https://app.netlify.com/drop)

#### Option 3: Vercel

1. Install Vercel CLI:
```bash
npm install -g vercel
```

2. Deploy:
```bash
cd build/web
vercel --prod
```

#### Option 4: GitHub Pages

1. Build with correct base href:
```bash
flutter build web --release --base-href /music_react/
```

2. Copy build to docs folder or gh-pages branch:
```bash
cp -r build/web/* docs/
git add docs/
git commit -m "Deploy to GitHub Pages"
git push
```

3. Enable GitHub Pages in repository settings

#### Option 5: Traditional Web Server (Apache/Nginx)

1. Build the app:
```bash
flutter build web --release
```

2. Copy files to web server:
```bash
scp -r build/web/* user@server:/var/www/html/musichub/
```

3. Configure server:

**Nginx** (`/etc/nginx/sites-available/musichub`):
```nginx
server {
    listen 80;
    server_name musichub.example.com;
    root /var/www/html/musichub;
    index index.html;

    location / {
        try_files $uri $uri/ /index.html;
    }

    # Enable gzip compression
    gzip on;
    gzip_types text/plain text/css application/json application/javascript text/xml application/xml application/xml+rss text/javascript;
}
```

**Apache** (`.htaccess`):
```apache
<IfModule mod_rewrite.c>
    RewriteEngine On
    RewriteBase /
    RewriteCond %{REQUEST_FILENAME} !-f
    RewriteCond %{REQUEST_FILENAME} !-d
    RewriteRule ^.*$ /index.html [L]
</IfModule>

# Enable compression
<IfModule mod_deflate.c>
    AddOutputFilterByType DEFLATE text/html text/plain text/css application/json application/javascript text/javascript
</IfModule>
```

### Web Performance Optimization

1. **Enable CanvasKit** (better performance):
```bash
flutter build web --release --web-renderer canvaskit
```

2. **Enable HTML renderer** (smaller size):
```bash
flutter build web --release --web-renderer html
```

3. **Auto renderer** (recommended):
```bash
flutter build web --release --web-renderer auto
```

---

## CI/CD Setup

### GitHub Actions

Create `.github/workflows/deploy.yml`:

```yaml
name: Deploy Flutter App

on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]

jobs:
  build-android:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      
      - uses: actions/setup-java@v3
        with:
          distribution: 'zulu'
          java-version: '17'
      
      - uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.24.0'
          channel: 'stable'
      
      - name: Install dependencies
        run: flutter pub get
        working-directory: flutter_app
      
      - name: Build APK
        run: flutter build apk --release
        working-directory: flutter_app
      
      - name: Upload APK
        uses: actions/upload-artifact@v3
        with:
          name: app-release.apk
          path: flutter_app/build/app/outputs/flutter-apk/app-release.apk

  build-web:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      
      - uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.24.0'
          channel: 'stable'
      
      - name: Install dependencies
        run: flutter pub get
        working-directory: flutter_app
      
      - name: Build Web
        run: flutter build web --release
        working-directory: flutter_app
      
      - name: Deploy to GitHub Pages
        uses: peaceiris/actions-gh-pages@v3
        if: github.ref == 'refs/heads/main'
        with:
          github_token: ${{ secrets.GITHUB_TOKEN }}
          publish_dir: flutter_app/build/web
```

---

## Environment Configuration

### API Configuration

For production, use environment-specific API URLs:

1. Create environment files:

`lib/config/env.dart`:
```dart
class Environment {
  static const String apiUrl = String.fromEnvironment(
    'API_URL',
    defaultValue: 'https://jiosaavn-api-privatecvc.vercel.app/',
  );
}
```

2. Build with custom API:
```bash
flutter build web --release --dart-define=API_URL=https://your-api.com/
```

### Version Management

Update version in `pubspec.yaml`:

```yaml
version: 1.0.0+1  # version+buildNumber
```

Then rebuild:
```bash
flutter clean
flutter pub get
flutter build apk --release
```

---

## Post-Deployment Checklist

### Android
- [ ] Test APK on multiple devices
- [ ] Verify all features work offline (if applicable)
- [ ] Check app permissions
- [ ] Test on different Android versions
- [ ] Verify app size is acceptable
- [ ] Test deep linking (if implemented)

### Web
- [ ] Test on multiple browsers (Chrome, Firefox, Safari)
- [ ] Verify responsive design
- [ ] Check loading performance
- [ ] Test PWA installation
- [ ] Verify all assets load correctly
- [ ] Check console for errors

### General
- [ ] Update README with deployment URL
- [ ] Document any configuration changes
- [ ] Tag release in Git
- [ ] Update changelog
- [ ] Monitor error reports

---

## Monitoring and Analytics

Consider adding:

1. **Firebase Analytics**
2. **Sentry** for error tracking
3. **Google Analytics** for web
4. **Crashlytics** for Android

---

## Troubleshooting

### Build Fails

```bash
flutter clean
flutter pub get
flutter build apk --release -v
```

### Web CORS Issues

Configure your API to allow CORS, or use a proxy.

### Android Signing Issues

Verify keystore path and credentials in `key.properties`.

---

## Additional Resources

- [Flutter Deployment Documentation](https://flutter.dev/docs/deployment)
- [Android App Bundle Guide](https://developer.android.com/guide/app-bundle)
- [Firebase Hosting Docs](https://firebase.google.com/docs/hosting)
- [Google Play Console](https://play.google.com/console)

---

**Last Updated**: December 26, 2025
