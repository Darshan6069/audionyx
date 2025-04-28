
class PlaylistModel {
  final String id;
  final String name;
  final String description;
  final String userId;
  final List<PlaylistSong> songs;

  PlaylistModel({
    required this.id,
    required this.name,
    required this.description,
    required this.userId,
    required this.songs,
  });

  factory PlaylistModel.fromJson(Map<String, dynamic> json) {
    return PlaylistModel(
      id: json['_id'],
      name: json['name'],
      description: json['description'] ?? '',
      userId: json['userId'],
      songs: (json['songs'] as List)
          .map((song) => PlaylistSong.fromJson(song))
          .toList(),
    );
  }
}

class PlaylistSong {
  final String songId;
  final String title;
  final String artist;
  final String url;

  PlaylistSong({
    required this.songId,
    required this.title,
    required this.artist,
    required this.url,
  });

  factory PlaylistSong.fromJson(Map<String, dynamic> json) {
    return PlaylistSong(
      songId: json['songId'],
      title: json['title'],
      artist: json['artist'],
      url: json['url'],
    );
  }
}