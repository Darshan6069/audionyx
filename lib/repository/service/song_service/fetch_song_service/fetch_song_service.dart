import 'package:audionyx/repository/service/api_service.dart';
import '../../../../domain/song_model/song_model.dart';
import '../../../../main.dart';

class FetchSongService {
  final ApiService _apiService = ApiService(navigatorKey);


  Future<List<SongData>> fetchSongs() async {
    try {
      final response = await _apiService.get('songs');

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => SongData.fromJson(json)).toList();
      } else {
        throw Exception('Failed to fetch songs: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching songs: $e');
    }
  }
}