import 'dart:io';

class SongData {
  final String id;
  final String path;
  final String thumbnailUrl;
  final String title;
  final String artist;
  final String album;
  final String genre;
  final bool isUrl;

  SongData({
    required this.id,
    required this.path,
    required this.thumbnailUrl,
    required this.title,
    required this.artist,
    required this.album,
    required this.genre,
    this.isUrl = false,
  });

  // Convert from Map (e.g., from API or JSON)
  factory SongData.fromMap(Map<String, dynamic> map) {
    return SongData(
      id: map['id']?.toString() ?? 'unknown',
      path: map['path']?.toString() ?? map['mp3Url']?.toString() ?? '',
      thumbnailUrl: map['thumbnailUrl']?.toString() ?? '',
      title: map['title']?.toString() ?? 'Unknown Title',
      artist: map['artist']?.toString() ?? 'Unknown Artist',
      album: map['album']?.toString() ?? 'Unknown Album',
      genre: map['genre']?.toString() ?? 'Unknown Genre',
      isUrl: map['isUrl'] as bool? ?? false,
    );
  }

  // Convert from File (e.g., from DownloadedSongsScreen)
  factory SongData.fromFile(File file) {
    final fileName = file.path.split('/').last.replaceAll('.mp3', '');
    return SongData(
      id: fileName,
      path: file.path,
      thumbnailUrl: file.path.replaceAll('.mp3', '_thumbnail.jpg'),
      title: fileName,
      artist: 'Unknown Artist',
      album: 'Unknown Album',
      genre: 'Unknown Genre',
      isUrl: false,
    );
  }

  // Convert to Map (e.g., for saving to JSON)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'path': path,
      'thumbnailUrl': thumbnailUrl,
      'title': title,
      'artist': artist,
      'album': album,
      'genre': genre,
      'isUrl': isUrl,
    };
  }
}