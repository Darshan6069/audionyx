class SongData {
  final String id;
  final String mp3Url;
  final String title;
  final String artist;
  final String thumbnailUrl;
  final String album;
  final String genre;
  final DateTime? createdAt;

  final String subtitleUrl; // ✅ New: URL to .srt file

  SongData({
    required this.id,
    required this.mp3Url,
    required this.title,
    required this.artist,
    this.thumbnailUrl = '',
    this.album = '',
    this.genre = 'Unknown',
    this.createdAt,
    required this.subtitleUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'mp3Url': mp3Url,
      'title': title,
      'artist': artist,
      'thumbnailUrl': thumbnailUrl,
      'album': album,
      'genre': genre,
      'createdAt': createdAt?.toIso8601String(),
      'subtitleUrl': subtitleUrl,
    }..removeWhere(
      (key, value) =>
          value == null &&
          key != 'id' &&
          key != 'mp3Url' &&
          key != 'title' &&
          key != 'artist',
    );
  }

  factory SongData.fromJson(Map<String, dynamic> json) {
    return SongData(
      id: json['id'] ?? json['_id'] ?? '',
      mp3Url: json['mp3Url'] ?? '',
      title: json['title'] ?? '',
      artist: json['artist'] ?? '',
      thumbnailUrl: json['thumbnailUrl'] ?? '',
      album: json['album'] ?? '',
      genre: json['genre'] ?? 'Unknown',
      createdAt:
          json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      subtitleUrl: json['subtitleUrl'],
    );
  }
}
