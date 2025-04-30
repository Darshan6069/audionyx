import 'package:audionyx/domain/song_model/song_model.dart';

class PlaylistModel {
  final String id;
  final String name;
  final String? description;
  final String? thumbnailUrl;
  final List<SongData> songs;

  PlaylistModel({
    required this.id,
    required this.name,
    this.description,
    this.thumbnailUrl,
    this.songs = const [],
  });

  factory PlaylistModel.fromJson(Map<String, dynamic> json) {
    return PlaylistModel(
      id: json['_id'] ?? json['id'],
      name: json['name'],
      description: json['description'],
      thumbnailUrl: json['thumbnailUrl'],
      songs: List<SongData>.from(json['songs'] ?? []),
    );
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'description': description ?? '',
    'thumbnailUrl': thumbnailUrl ?? '',
    'songs': songs,
  };
}
