import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/music_models.dart';

class ApiService {
  // List of API URLs to try (fallback mechanism)
  static const List<String> _apiUrls = [
    'https://saavn.me/api/',
    'https://jiosaavn-api.vercel.app/api/',
    'https://jiosaavn.vercel.app/api/',
  ];
  
  static int _currentApiIndex = 0;
  
  // Get current API URL
  static String get apiUrl {
    return _apiUrls[_currentApiIndex];
  }
  
  // Try next API URL
  static void _switchToNextApi() {
    _currentApiIndex = (_currentApiIndex + 1) % _apiUrls.length;
    print('Switching to API: ${_apiUrls[_currentApiIndex]}');
  }
  
  // Make HTTP request with retry logic and fallback
  static Future<http.Response?> _makeRequest(String endpoint, {int maxRetries = 3}) async {
    int attempts = 0;
    int apiAttempts = 0;
    
    while (attempts < maxRetries && apiAttempts < _apiUrls.length) {
      try {
        final uri = Uri.parse('$apiUrl$endpoint');
        print('Attempting request to: $uri');
        
        final response = await http.get(
          uri,
          headers: {
            'Accept': 'application/json',
          },
        ).timeout(
          const Duration(seconds: 10),
          onTimeout: () {
            throw Exception('Request timeout');
          },
        );
        
        if (response.statusCode == 200) {
          print('Request successful');
          return response;
        } else {
          print('Request failed with status: ${response.statusCode}');
        }
      } catch (e) {
        print('Request error: $e');
        attempts++;
        
        if (attempts >= maxRetries) {
          // Try next API endpoint
          _switchToNextApi();
          apiAttempts++;
          attempts = 0; // Reset attempts for new API
        } else {
          // Wait before retrying with same API
          await Future.delayed(Duration(seconds: attempts));
        }
      }
    }
    
    return null;
  }

  // Search songs by query
  static Future<List<Song>> searchSongs(String query) async {
    try {
      final response = await _makeRequest('search/songs?query=$query');

      if (response != null && response.statusCode == 200) {
        final data = json.decode(response.body);
        final results = data['data']['results'] as List<dynamic>;
        return results.map((e) => Song.fromJson(e)).toList();
      } else {
        print('Failed to load songs - no valid response');
        return [];
      }
    } catch (e) {
      print('Error searching songs: $e');
      return [];
    }
  }

  // Get song by ID
  static Future<Song?> getSongById(String id) async {
    try {
      final response = await _makeRequest('songs/$id');

      if (response != null && response.statusCode == 200) {
        final data = json.decode(response.body);
        final songData = data['data'][0];
        return Song.fromJson(songData);
      } else {
        print('Failed to load song - no valid response');
        return null;
      }
    } catch (e) {
      print('Error getting song: $e');
      return null;
    }
  }

  // Get song suggestions
  static Future<List<Song>> getSongSuggestions(String id) async {
    try {
      final response = await _makeRequest('songs/$id/suggestions');

      if (response != null && response.statusCode == 200) {
        final data = json.decode(response.body);
        final results = data['data'] as List<dynamic>;
        return results.map((e) => Song.fromJson(e)).toList();
      } else {
        print('Failed to load suggestions - no valid response');
        return [];
      }
    } catch (e) {
      print('Error getting suggestions: $e');
      return [];
    }
  }

  // Search albums by query
  static Future<List<Album>> searchAlbums(String query) async {
    try {
      final response = await _makeRequest('search/albums?query=$query');

      if (response != null && response.statusCode == 200) {
        final data = json.decode(response.body);
        final results = data['data']['results'] as List<dynamic>;
        return results.map((e) => Album.fromJson(e)).toList();
      } else {
        print('Failed to load albums - no valid response');
        return [];
      }
    } catch (e) {
      print('Error searching albums: $e');
      return [];
    }
  }

  // Get album by ID
  static Future<Album?> getAlbumById(String id) async {
    try {
      final response = await _makeRequest('albums?id=$id');

      if (response != null && response.statusCode == 200) {
        final data = json.decode(response.body);
        return Album.fromJson(data['data']);
      } else {
        print('Failed to load album - no valid response');
        return null;
      }
    } catch (e) {
      print('Error getting album: $e');
      return null;
    }
  }
}
