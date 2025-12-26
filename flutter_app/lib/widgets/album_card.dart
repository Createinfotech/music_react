import 'package:flutter/material.dart';
import '../models/music_models.dart';

class AlbumCard extends StatelessWidget {
  final Album album;

  const AlbumCard({super.key, required this.album});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          '/album',
          arguments: album.id,
        );
      },
      child: Container(
        width: 180,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Album Cover
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                album.imageUrl,
                width: 180,
                height: 180,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 180,
                    height: 180,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.album, size: 48),
                  );
                },
              ),
            ),
            const SizedBox(height: 8),
            // Album Title
            Text(
              album.name.length > 20 ? '${album.name.substring(0, 20)}...' : album.name,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            // Artist Names
            Text(
              album.artistNames.length > 20
                  ? '${album.artistNames.substring(0, 20)}...'
                  : album.artistNames,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            if (album.language != null) ...[
              const SizedBox(height: 4),
              Text(
                album.language!,
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.grey[500],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
