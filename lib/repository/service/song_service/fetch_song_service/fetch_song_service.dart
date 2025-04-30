import 'dart:convert';
import 'package:audionyx/core/constants/app_strings.dart';
import 'package:http/http.dart' as http;
import '../../../../domain/song_model/song_model.dart';

class FetchSongService {
  Future<List<SongData>> fetchSongs() async {
    try {
      final response = await http.get(
        Uri.parse('${AppStrings.baseUrl}songs'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => SongData.fromMap(json)).toList();
      } else {
        throw Exception('Failed to fetch songs: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching songs: $e');
    }
  }
}