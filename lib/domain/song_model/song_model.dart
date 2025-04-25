class SongModel {
  String id;
  String title;
  String artist;
  String album;
  String thumbnail;
  String mp3Url;

  SongModel({
    required this.id,
    required this.title,
    required this.artist,
    required this.album,
    required this.thumbnail,
    required this.mp3Url,
  });

  factory SongModel.fromJson(Map<String, dynamic> json) {
    return SongModel(
      id: json['id'] as String,
      title: json['title'] as String,
      artist: json['artist'] as String,
      album: json['album'] as String,
      thumbnail: json['thumbnail'] as String,
      mp3Url: json['mp3Url'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'artist': artist,
      'album': album,
      'thumbnail': thumbnail,
      'mp3Url': mp3Url,
    };
  }
}

class SongData {
  final String path; // URL or local path
  final String title;
  final String thumbnailPath; // URL or local path
  final bool isOnline;

  SongData({
    required this.path,
    required this.title,
    required this.thumbnailPath,
    required this.isOnline,
  });
}
