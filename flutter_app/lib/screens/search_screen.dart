import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/music_models.dart';
import '../widgets/song_card.dart';
import '../widgets/album_card.dart';
import '../widgets/artist_card.dart';
import '../widgets/app_header.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Song> _songs = [];
  List<Album> _albums = [];
  bool _isLoading = false;
  String _query = '';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Get query from route arguments if provided
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is String && args.isNotEmpty) {
      _searchController.text = args;
      _performSearch(args);
    }
  }

  Future<void> _performSearch(String query) async {
    if (query.isEmpty) return;
    
    setState(() {
      _isLoading = true;
      _query = query;
    });
    
    final songs = await ApiService.searchSongs(query);
    final albums = await ApiService.searchAlbums(query);
    
    setState(() {
      _songs = songs;
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
              child: AppHeader(showBackButton: true),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search songs, artists, albums...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              setState(() {
                                _songs = [];
                                _albums = [];
                                _query = '';
                              });
                            },
                          )
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onSubmitted: _performSearch,
                  onChanged: (value) {
                    setState(() {});
                  },
                ),
              ),
            ),
            if (_isLoading)
              const SliverFillRemaining(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )
            else if (_query.isNotEmpty)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Search Results Header
                      const Text(
                        'Search Results',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Search results for "$_query"',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      // Songs
                      if (_songs.isNotEmpty) ...[
                        SizedBox(
                          height: 240,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: _songs.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.only(right: 12),
                                child: SongCard(song: _songs[index]),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 32),
                      ],
                      
                      // Related Albums
                      if (_albums.isNotEmpty) ...[
                        const Text(
                          'Related Albums',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Albums related to "$_query"',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          height: 240,
                          child: ListView.builder(
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
                      ],
                      
                      // Related Artists
                      if (_songs.isNotEmpty) ...[
                        const Text(
                          'Related Artists',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Artists related to "$_query"',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          height: 140,
                          child: _buildArtistsList(),
                        ),
                      ],
                      
                      // No Results
                      if (_songs.isEmpty && _albums.isEmpty)
                        const Padding(
                          padding: EdgeInsets.all(32.0),
                          child: Center(
                            child: Text(
                              'No results found',
                              style: TextStyle(fontSize: 16),
                            ),
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

  Widget _buildArtistsList() {
    // Extract unique artists from songs
    final uniqueArtists = <String, Artist>{};
    for (var song in _songs) {
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

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
