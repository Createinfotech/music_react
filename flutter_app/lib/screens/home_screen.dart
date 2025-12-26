import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../providers/music_provider.dart';
import '../services/api_service.dart';
import '../models/music_models.dart';
import '../widgets/song_card.dart';
import '../widgets/album_card.dart';
import '../widgets/artist_card.dart';
import '../widgets/app_header.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Song> _latestSongs = [];
  List<Song> _trendingSongs = [];
  List<Album> _albums = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    
    final latest = await ApiService.searchSongs('latest');
    final trending = await ApiService.searchSongs('trending');
    final albums = await ApiService.searchAlbums('latest');
    
    setState(() {
      _latestSongs = latest;
      _trendingSongs = trending;
      _albums = albums;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            const SliverToBoxAdapter(
              child: AppHeader(showBackButton: false),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Latest Songs Section
                    const Text(
                      'Songs',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Top new released songs.',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 240,
                      child: _isLoading
                          ? _buildLoadingList()
                          : ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: _latestSongs.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.only(right: 12),
                                  child: SongCard(song: _latestSongs[index]),
                                );
                              },
                            ),
                    ),
                    
                    const SizedBox(height: 32),
                    
                    // Albums Section
                    const Text(
                      'Albums',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Top new released albums.',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 240,
                      child: _isLoading
                          ? _buildLoadingList()
                          : ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: _albums.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.only(right: 12),
                                  child: AlbumCard(album: _albums[index]),
                                );
                              },
                            ),
                    ),
                    
                    const SizedBox(height: 32),
                    
                    // Artists Section
                    const Text(
                      'Artists',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Most searched artists.',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 140,
                      child: _isLoading
                          ? _buildLoadingList()
                          : _buildArtistsList(),
                    ),
                    
                    const SizedBox(height: 32),
                    
                    // Trending Section
                    const Text(
                      'Trending',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Most played songs this week.',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 240,
                      child: _isLoading
                          ? _buildLoadingList()
                          : ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: _trendingSongs.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.only(right: 12),
                                  child: SongCard(song: _trendingSongs[index]),
                                );
                              },
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingList() {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: 5,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(right: 12),
          child: Container(
            width: 180,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      },
    );
  }

  Widget _buildArtistsList() {
    // Extract unique artists from latest songs
    final uniqueArtists = <String, Artist>{};
    for (var song in _latestSongs) {
      if (song.artists.isNotEmpty) {
        final artist = song.artists.first;
        uniqueArtists[artist.id] = artist;
      }
    }
    
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: uniqueArtists.length,
      itemBuilder: (context, index) {
        final artist = uniqueArtists.values.elementAt(index);
        return Padding(
          padding: const EdgeInsets.only(right: 12),
          child: ArtistCard(artist: artist),
        );
      },
    );
  }
}
