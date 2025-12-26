import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/music_provider.dart';
import '../models/music_models.dart';
import '../widgets/app_header.dart';
import 'package:share_plus/share_plus.dart';

class PlayerScreen extends StatefulWidget {
  const PlayerScreen({super.key});

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Consumer<MusicProvider>(
          builder: (context, musicProvider, child) {
            final song = musicProvider.currentSong;
            
            if (song == null) {
              return const Center(
                child: Text('No song selected'),
              );
            }

            return CustomScrollView(
              slivers: [
                const SliverToBoxAdapter(
                  child: AppHeader(showBackButton: true),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        // Album Art
                        Container(
                          width: double.infinity,
                          constraints: const BoxConstraints(maxWidth: 400),
                          child: AspectRatio(
                            aspectRatio: 1,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Image.network(
                                song.imageUrl,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    color: Colors.grey[300],
                                    child: const Icon(Icons.music_note, size: 64),
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                        
                        const SizedBox(height: 32),
                        
                        // Song Info
                        Text(
                          song.name,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'by ${song.artistName}',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                        
                        const SizedBox(height: 32),
                        
                        // Progress Bar
                        Slider(
                          value: musicProvider.position.inSeconds.toDouble(),
                          max: musicProvider.duration.inSeconds.toDouble().clamp(1, double.infinity),
                          onChanged: (value) {
                            musicProvider.seek(Duration(seconds: value.toInt()));
                          },
                        ),
                        
                        // Time Labels
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                musicProvider.formatDuration(musicProvider.position),
                                style: const TextStyle(fontSize: 12),
                              ),
                              Text(
                                musicProvider.formatDuration(musicProvider.duration),
                                style: const TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                        
                        const SizedBox(height: 24),
                        
                        // Controls
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Play/Pause Button
                            ElevatedButton(
                              onPressed: musicProvider.togglePlayPause,
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24),
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    musicProvider.isPlaying
                                        ? Icons.pause
                                        : Icons.play_arrow,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    musicProvider.isPlaying ? 'Pause' : 'Play',
                                  ),
                                ],
                              ),
                            ),
                            
                            // Additional Controls
                            Row(
                              children: [
                                // Loop Button
                                IconButton(
                                  onPressed: musicProvider.toggleLoop,
                                  icon: Icon(
                                    musicProvider.isLooping
                                        ? Icons.repeat_one
                                        : Icons.repeat,
                                  ),
                                  color: musicProvider.isLooping
                                      ? Theme.of(context).primaryColor
                                      : null,
                                ),
                                
                                // Download Button (placeholder)
                                IconButton(
                                  onPressed: () {
                                    // Download functionality would go here
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Download feature coming soon'),
                                      ),
                                    );
                                  },
                                  icon: const Icon(Icons.download),
                                ),
                                
                                // Share Button
                                IconButton(
                                  onPressed: () {
                                    Share.share(
                                      'Check out ${song.name} by ${song.artistName}',
                                    );
                                  },
                                  icon: const Icon(Icons.share),
                                ),
                              ],
                            ),
                          ],
                        ),
                        
                        // Next Song Preview
                        if (musicProvider.nextSong != null) ...[
                          const SizedBox(height: 32),
                          const Divider(),
                          const SizedBox(height: 16),
                          const Text(
                            'Up Next',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          _buildNextSongCard(
                            context,
                            musicProvider.nextSong!,
                            musicProvider,
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildNextSongCard(BuildContext context, Song song, MusicProvider provider) {
    return InkWell(
      onTap: () => provider.playSong(song),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                song.imageUrl,
                width: 60,
                height: 60,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 60,
                    height: 60,
                    color: Colors.grey[300],
                    child: const Icon(Icons.music_note),
                  );
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    song.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    song.artistName,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const Icon(Icons.play_arrow),
          ],
        ),
      ),
    );
  }
}
