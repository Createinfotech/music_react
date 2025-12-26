import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/music_models.dart';

class ApiService {
  // Default API URL - can be configured via environment variable
  static const String _defaultApiUrl = 'https://jiosaavn-api-privatecvc.vercel.app/';
  
  // Get API URL from environment or use default
  static String get apiUrl {
    // In production, you'd use environment variables
    // For now, using the default
    return _defaultApiUrl;
  }

  // Search songs by query
  static Future<List<Song>> searchSongs(String query) async {
    try {
      final response = await http.get(
        Uri.parse('${apiUrl}search/songs?query=$query'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final results = data['data']['results'] as List<dynamic>;
        return results.map((e) => Song.fromJson(e)).toList();
      } else {
        throw Exception('Failed to load songs');
      }
    } catch (e) {
      print('Error searching songs: $e');
      return [];
    }
  }

  // Get song by ID
  static Future<Song?> getSongById(String id) async {
    try {
      final response = await http.get(
        Uri.parse('${apiUrl}songs/$id'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final songData = data['data'][0];
        return Song.fromJson(songData);
      } else {
        throw Exception('Failed to load song');
      }
    } catch (e) {
      print('Error getting song: $e');
      return null;
    }
  }

  // Get song suggestions
  static Future<List<Song>> getSongSuggestions(String id) async {
    try {
      final response = await http.get(
        Uri.parse('${apiUrl}songs/$id/suggestions'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final results = data['data'] as List<dynamic>;
        return results.map((e) => Song.fromJson(e)).toList();
      } else {
        throw Exception('Failed to load suggestions');
      }
    } catch (e) {
      print('Error getting suggestions: $e');
      return [];
    }
  }

  // Search albums by query
  static Future<List<Album>> searchAlbums(String query) async {
    try {
      final response = await http.get(
        Uri.parse('${apiUrl}search/albums?query=$query'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final results = data['data']['results'] as List<dynamic>;
        return results.map((e) => Album.fromJson(e)).toList();
      } else {
        throw Exception('Failed to load albums');
      }
    } catch (e) {
      print('Error searching albums: $e');
      return [];
    }
  }

  // Get album by ID
  static Future<Album?> getAlbumById(String id) async {
    try {
      final response = await http.get(
        Uri.parse('${apiUrl}albums?id=$id'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return Album.fromJson(data['data']);
      } else {
        throw Exception('Failed to load album');
      }
    } catch (e) {
      print('Error getting album: $e');
      return null;
    }
  }
}
