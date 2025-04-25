import 'dart:io';

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
  final String path;
  final String? thumbnailUrl;
  final String? title;
  final String? artist;
  final String? album;
  final bool isUrl;

  SongData({
    required this.path,
    this.thumbnailUrl,
    this.title,
    this.artist,
    this.album,
    this.isUrl = false,
  });

  // Convert from Map (e.g., from API or JSON)
  factory SongData.fromMap(Map<String, dynamic> map) {
    return SongData(
      path: map['path'] ?? map['mp3Url'] ?? '',
      thumbnailUrl: map['thumbnailUrl'],
      title: map['title'],
      artist: map['artist'],
      album: map['album'],
      isUrl: map['isUrl'] ?? false,
    );
  }

  // Convert from File (e.g., from DownloadedSongsScreen)
  factory SongData.fromFile(File file) {
    return SongData(
      path: file.path,
      title: file.path.split('/').last.replaceAll('.mp3', ''),
      isUrl: false,
    );
  }

  // Convert to Map (e.g., for saving to JSON)
  Map<String, dynamic> toMap() {
    return {
      'path': path,
      'thumbnailUrl': thumbnailUrl,
      'title': title,
      'artist': artist,
      'album': album,
      'isUrl': isUrl,
    };
  }
}
