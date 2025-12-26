import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import '../models/music_models.dart';

class ApiService {
  // List of API URLs to try (fallback mechanism)
  static const List<String> _apiUrls = [
    'https://saavn.me/api/',
    'https://jiosaavn-api.vercel.app/api/',
    'https://jiosaavn.vercel.app/api/',
  ];
  
  // Calculate exponential backoff delay
  static Duration _getBackoffDelay(int attempt) {
    final delayMs = pow(2, attempt) * 1000;
    return Duration(milliseconds: delayMs.toInt());
  }
  
  // Check if response is valid and successful
  static bool _isValidResponse(http.Response? response) {
    return response != null && response.statusCode == 200;
  }
  
  // Make HTTP request with retry logic and fallback
  static Future<http.Response?> _makeRequest(String endpoint, {int maxRetries = 3}) async {
    // Try each API endpoint
    for (int apiIndex = 0; apiIndex < _apiUrls.length; apiIndex++) {
      final apiUrl = _apiUrls[apiIndex];
      
      // Retry the current endpoint multiple times
      for (int attempt = 0; attempt < maxRetries; attempt++) {
        try {
          final uri = Uri.parse('$apiUrl$endpoint');
          print('Attempting request to: $uri (attempt ${attempt + 1}/$maxRetries)');
          
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
            // Non-200 status codes should also be retried
            if (attempt < maxRetries - 1) {
              await Future.delayed(_getBackoffDelay(attempt));
            }
          }
        } catch (e) {
          print('Request error: $e');
          
          if (attempt < maxRetries - 1) {
            await Future.delayed(_getBackoffDelay(attempt));
          }
        }
      }
      
      // If we exhausted retries for this API, try the next one
      if (apiIndex < _apiUrls.length - 1) {
        print('Switching to next API endpoint: ${_apiUrls[apiIndex + 1]}');
      }
    }
    
    print('All API endpoints failed after $maxRetries retries each');
    return null;
  }

  // Search songs by query
  static Future<List<Song>> searchSongs(String query) async {
    try {
      final response = await _makeRequest('search/songs?query=$query');

      if (_isValidResponse(response)) {
        final data = json.decode(response!.body);
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

      if (_isValidResponse(response)) {
        final data = json.decode(response!.body);
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

      if (_isValidResponse(response)) {
        final data = json.decode(response!.body);
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

      if (_isValidResponse(response)) {
        final data = json.decode(response!.body);
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

      if (_isValidResponse(response)) {
        final data = json.decode(response!.body);
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
