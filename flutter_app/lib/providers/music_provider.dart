import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/music_models.dart';
import '../services/api_service.dart';

class MusicProvider extends ChangeNotifier {
  final AudioPlayer _audioPlayer = AudioPlayer();
  
  Song? _currentSong;
  List<Song> _suggestions = [];
  bool _isPlaying = false;
  bool _isLooping = false;
  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;
  double _downloadProgress = 0.0;

  // Getters
  AudioPlayer get audioPlayer => _audioPlayer;
  Song? get currentSong => _currentSong;
  List<Song> get suggestions => _suggestions;
  bool get isPlaying => _isPlaying;
  bool get isLooping => _isLooping;
  Duration get position => _position;
  Duration get duration => _duration;
  double get downloadProgress => _downloadProgress;
  Song? get nextSong => _suggestions.isNotEmpty ? _suggestions.first : null;

  MusicProvider() {
    _init();
  }

  void _init() {
    // Listen to player state
    _audioPlayer.playerStateStream.listen((state) {
      _isPlaying = state.playing;
      notifyListeners();
    });

    // Listen to position changes
    _audioPlayer.positionStream.listen((position) {
      _position = position;
      notifyListeners();
    });

    // Listen to duration changes
    _audioPlayer.durationStream.listen((duration) {
      _duration = duration ?? Duration.zero;
      notifyListeners();
    });

    // Listen for song completion
    _audioPlayer.processingStateStream.listen((state) {
      if (state == ProcessingState.completed && !_isLooping && nextSong != null) {
        playSong(nextSong!);
      }
    });

    // Load last played song
    _loadLastPlayed();
  }

  Future<void> _loadLastPlayed() async {
    final prefs = await SharedPreferences.getInstance();
    final lastPlayedId = prefs.getString('last-played');
    if (lastPlayedId != null) {
      final song = await ApiService.getSongById(lastPlayedId);
      if (song != null) {
        _currentSong = song;
        notifyListeners();
      }
    }
  }

  Future<void> playSong(Song song) async {
    try {
      _currentSong = song;
      
      // Save last played
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('last-played', song.id);
      
      // Load suggestions
      _loadSuggestions(song.id);
      
      // Set audio source
      await _audioPlayer.setUrl(song.audioUrl);
      await _audioPlayer.play();
      
      notifyListeners();
    } catch (e) {
      print('Error playing song: $e');
    }
  }

  Future<void> _loadSuggestions(String songId) async {
    _suggestions = await ApiService.getSongSuggestions(songId);
    notifyListeners();
  }

  Future<void> togglePlayPause() async {
    if (_isPlaying) {
      await _audioPlayer.pause();
    } else {
      await _audioPlayer.play();
    }
  }

  Future<void> seek(Duration position) async {
    await _audioPlayer.seek(position);
  }

  Future<void> toggleLoop() async {
    _isLooping = !_isLooping;
    await _audioPlayer.setLoopMode(_isLooping ? LoopMode.one : LoopMode.off);
    notifyListeners();
  }

  void setDownloadProgress(double progress) {
    _downloadProgress = progress;
    notifyListeners();
  }

  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }
}
