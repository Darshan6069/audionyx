class SongData {
  final String id; // Use 'id' to match backend's toJSON output
  final String mp3Url; // Required
  final String title; // Required
  final String artist; // Required
  final String thumbnailUrl; // Optional, default ''
  final String album; // Optional, default ''
  final String genre; // Optional, default 'Unknown'
  final DateTime? createdAt; // Optional, default Date.now

  SongData({
    required this.id,
    required this.mp3Url,
    required this.title,
    required this.artist,
    this.thumbnailUrl = '', // Match backend default
    this.album = '', // Match backend default
    this.genre = 'Unknown', // Match backend default
    this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id, // Send 'id' to match backend's expected input
      'mp3Url': mp3Url,
      'title': title,
      'artist': artist,
      'thumbnailUrl': thumbnailUrl,
      'album': album,
      'genre': genre,
      'createdAt': createdAt?.toIso8601String(),
    }..removeWhere((key, value) => value == null && key != 'id' && key != 'mp3Url' && key != 'title' && key != 'artist');
  }

  factory SongData.fromJson(Map<String, dynamic> json) {
    return SongData(
      id: json['id'] ?? json['_id'] ?? '', // Handle both 'id' (from toJSON) and '_id'
      mp3Url: json['mp3Url'] ?? '',
      title: json['title'] ?? '',
      artist: json['artist'] ?? '',
      thumbnailUrl: json['thumbnailUrl'] ?? '',
      album: json['album'] ?? '',
      genre: json['genre'] ?? 'Unknown',
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
    );
  }
}