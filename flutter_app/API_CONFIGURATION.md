# API Configuration Guide

## Issue: API Connection Errors

If you're seeing errors like:
```
Error searching songs: ClientException: Failed to fetch, uri=https://jiosaavn-api-privatecvc.vercel.app/...
```

This means the default API endpoint is not accessible or is down.

## Solution

The app now includes **automatic fallback** to multiple API endpoints and **retry logic** to handle connection issues.

### Default API Endpoints (in order of priority):

1. `https://saavn.me/api/`
2. `https://jiosaavn-api.vercel.app/api/`
3. `https://jiosaavn.vercel.app/api/`

The app will automatically try each endpoint if the previous one fails.

## Setting Up Your Own API

To use your own JioSaavn API instance:

### 1. Deploy Your Own API

Fork and deploy the [JioSaavn API](https://github.com/sumitkolhe/jiosaavn-api):

1. Fork the repository
2. Deploy to Vercel, Railway, or any other hosting service
3. Get your deployment URL

### 2. Update the API Configuration

Edit `lib/services/api_service.dart` and update the `_apiUrls` list:

```dart
static const List<String> _apiUrls = [
  'https://your-api-url.vercel.app/api/',  // Your custom endpoint
  'https://saavn.me/api/',
  'https://jiosaavn-api.vercel.app/api/',
];
```

### 3. Rebuild the App

```bash
flutter clean
flutter pub get
flutter run
```

## Features of the New API Service

- **Automatic Retry**: Retries failed requests up to 3 times
- **Multiple Endpoints**: Falls back to alternative APIs if one fails
- **Timeout Protection**: 10-second timeout prevents hanging requests
- **Better Logging**: Detailed logs to help debug connection issues

## For Web Platform (CORS Issues)

If you're running the Flutter web app and still experiencing CORS issues:

### Option 1: Use a CORS-enabled API
Ensure your API endpoint has CORS enabled for web requests.

### Option 2: Use a CORS Proxy
You can use a CORS proxy for development:
```dart
static const List<String> _apiUrls = [
  'https://cors-anywhere.herokuapp.com/https://your-api.com/',
];
```

**Note**: CORS proxies should only be used for development, not production.

## Troubleshooting

### Still seeing errors?

1. Check that at least one API endpoint in the list is accessible
2. Verify your internet connection
3. Check the console logs for detailed error messages
4. Try accessing the API URL directly in your browser

### Testing API Endpoints

Test if an endpoint is working by visiting:
```
https://your-api-url.com/search/songs?query=latest
```

You should see a JSON response with song data.

## Need Help?

If you continue to experience issues:
1. Check the [JioSaavn API repository](https://github.com/sumitkolhe/jiosaavn-api) for updates
2. Ensure you're using a properly deployed and accessible API endpoint
3. Review the Flutter console logs for specific error details
