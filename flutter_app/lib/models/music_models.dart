class Song {
  final String id;
  final String name;
  final String album;
  final List<Artist> artists;
  final List<ImageQuality> images;
  final List<DownloadUrl> downloadUrls;
  final int duration;
  final String? language;

  Song({
    required this.id,
    required this.name,
    required this.album,
    required this.artists,
    required this.images,
    required this.downloadUrls,
    required this.duration,
    this.language,
  });

  factory Song.fromJson(Map<String, dynamic> json) {
    return Song(
      id: json['id'] ?? '',
      name: json['name'] ?? 'Unknown',
      album: json['album']?['name'] ?? json['album'] ?? 'Unknown Album',
      artists: (json['artists']?['primary'] as List<dynamic>?)
              ?.map((e) => Artist.fromJson(e))
              .toList() ??
          [],
      images: (json['image'] as List<dynamic>?)
              ?.map((e) => ImageQuality.fromJson(e))
              .toList() ??
          [],
      downloadUrls: (json['downloadUrl'] as List<dynamic>?)
              ?.map((e) => DownloadUrl.fromJson(e))
              .toList() ??
          [],
      duration: json['duration'] ?? 0,
      language: json['language'],
    );
  }

  String get imageUrl => images.isNotEmpty ? images.last.url : '';
  String get artistName => artists.isNotEmpty ? artists.first.name : 'Unknown';
  String get audioUrl {
    if (downloadUrls.isEmpty) return '';
    // Prefer medium quality (index 2), fallback to available
    if (downloadUrls.length > 2) return downloadUrls[2].url;
    if (downloadUrls.length > 1) return downloadUrls[1].url;
    return downloadUrls.first.url;
  }
}

class Artist {
  final String id;
  final String name;
  final List<ImageQuality> images;

  Artist({
    required this.id,
    required this.name,
    required this.images,
  });

  factory Artist.fromJson(Map<String, dynamic> json) {
    return Artist(
      id: json['id'] ?? '',
      name: json['name'] ?? 'Unknown',
      images: (json['image'] as List<dynamic>?)
              ?.map((e) => ImageQuality.fromJson(e))
              .toList() ??
          [],
    );
  }

  String get imageUrl => images.isNotEmpty ? images.last.url : '';
}

class Album {
  final String id;
  final String name;
  final String description;
  final List<Artist> artists;
  final List<ImageQuality> images;
  final List<Song> songs;
  final int songCount;
  final String? language;

  Album({
    required this.id,
    required this.name,
    required this.description,
    required this.artists,
    required this.images,
    required this.songs,
    required this.songCount,
    this.language,
  });

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      id: json['id'] ?? '',
      name: json['name'] ?? 'Unknown Album',
      description: json['description'] ?? '',
      artists: (json['artists']?['primary'] as List<dynamic>?)
              ?.map((e) => Artist.fromJson(e))
              .toList() ??
          [],
      images: (json['image'] as List<dynamic>?)
              ?.map((e) => ImageQuality.fromJson(e))
              .toList() ??
          [],
      songs: (json['songs'] as List<dynamic>?)
              ?.map((e) => Song.fromJson(e))
              .toList() ??
          [],
      songCount: json['songCount'] ?? 0,
      language: json['language'],
    );
  }

  String get imageUrl => images.isNotEmpty ? images.last.url : '';
  String get artistNames =>
      artists.map((a) => a.name).join(', ');
}

class ImageQuality {
  final String url;
  final String quality;

  ImageQuality({
    required this.url,
    required this.quality,
  });

  factory ImageQuality.fromJson(Map<String, dynamic> json) {
    return ImageQuality(
      url: json['url'] ?? json['link'] ?? '',
      quality: json['quality'] ?? '',
    );
  }
}

class DownloadUrl {
  final String url;
  final String quality;

  DownloadUrl({
    required this.url,
    required this.quality,
  });

  factory DownloadUrl.fromJson(Map<String, dynamic> json) {
    return DownloadUrl(
      url: json['url'] ?? json['link'] ?? '',
      quality: json['quality'] ?? '',
    );
  }
}
