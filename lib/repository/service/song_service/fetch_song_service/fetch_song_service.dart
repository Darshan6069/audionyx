import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../domain/song_model/song_model.dart';

class FetchSongService {
  Future<List<SongModel>> fetchSongs() async {
    try {
      final response = await http.get(
        Uri.parse('http://192.168.0.3:4000/api/songs'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => SongModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to fetch songs: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching songs: $e');
    }
  }
}