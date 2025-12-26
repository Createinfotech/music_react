import 'package:flutter/material.dart';
import '../models/music_models.dart';

class ArtistCard extends StatelessWidget {
  final Artist artist;

  const ArtistCard({super.key, required this.artist});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigate to search with artist name
        Navigator.pushNamed(
          context,
          '/search',
          arguments: artist.name.toLowerCase(),
        );
      },
      child: Container(
        width: 120,
        child: Column(
          children: [
            // Artist Image (circular)
            ClipRRect(
              borderRadius: BorderRadius.circular(60),
              child: Image.network(
                artist.imageUrl.isNotEmpty
                    ? artist.imageUrl
                    : 'https://via.placeholder.com/100',
                width: 100,
                height: 100,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        artist.name.isNotEmpty
                            ? artist.name[0].toUpperCase()
                            : 'A',
                        style: const TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 8),
            // Artist Name
            Text(
              artist.name.length > 15 ? '${artist.name.substring(0, 15)}...' : artist.name,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
