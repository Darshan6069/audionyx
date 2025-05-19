import 'package:audionyx/repository/service/api_service.dart';
import 'package:audionyx/domain/song_model/song_model.dart';
import 'package:http/http.dart' as http;
import '../../../../main.dart';

class FetchSongService {
  final ApiService _apiService = ApiService(navigatorKey);

  Future<List<SongData>> fetchSongs() async {
    try {
      final response = await _apiService.get('songs');

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        List<SongData> songs = [];

        // Fetch lyrics content for each song
        for (var json in data) {
          SongData song = SongData.fromJson(json);
          String lyricsContent = '';
          if (song.subtitleUrl.isNotEmpty) {
            try {
              final lyricsResponse = await http.get(Uri.parse(song.subtitleUrl));
              if (lyricsResponse.statusCode == 200) {
                lyricsContent = lyricsResponse.body;
              } else {
                print('Failed to fetch lyrics for ${song.title}: ${lyricsResponse.statusCode}');
              }
            } catch (e) {
              print('Error fetching lyrics for ${song.title}: $e');
            }
          }
          // Create a new SongData with lyrics content (temporary solution)
          songs.add(SongData(
            id: song.id,
            title: song.title,
            mp3Url: song.mp3Url,
            subtitleUrl: song.subtitleUrl,
            thumbnailUrl: song.thumbnailUrl,
            artist: song.artist,
            album: song.album,
            genre: song.genre,
          ));
        }
        return songs;
      } else {
        throw Exception('Failed to fetch songs: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching songs: $e');
    }
  }
}