import 'dart:convert';
import 'dart:io';
import 'package:audionyx/core/constants/extension.dart';
import 'package:audionyx/download_song_screen.dart';
import 'package:audionyx/presentation/bottom_navigation_bar/home_screen/home_screen.dart';
import 'package:audionyx/song_play_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:path_provider/path_provider.dart';

import 'domain/song_model/song_model.dart';

class SongBrowserScreen extends StatefulWidget {
  const SongBrowserScreen({super.key});

  @override
  State<SongBrowserScreen> createState() => _SongBrowserScreenState();
}

class _SongBrowserScreenState extends State<SongBrowserScreen> with SingleTickerProviderStateMixin {
  List<SongData> allSongs = [];
  List<SongData> filteredSongs = [];
  bool isLoading = false;
  String? errorMessage;
  String searchQuery = '';
  String? selectedGenre;
  String? selectedArtist;
  String? selectedAlbum;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    fetchSongs();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> fetchSongs() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final response = await http
          .get(Uri.parse('http://192.168.0.3:4000/api/songs'))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        if (mounted) {
          setState(() {
            allSongs = (jsonDecode(response.body) as List)
                .map((song) => SongData.fromMap(song))
                .toList();
            filteredSongs = allSongs;
            isLoading = false;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            isLoading = false;
            errorMessage = 'Failed to load songs';
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoading = false;
          errorMessage = 'Error fetching songs: $e';
        });
      }
    }
  }

  void _filterSongs() {
    setState(() {
      filteredSongs = allSongs.where((song) {
        final matchesSearch = searchQuery.isEmpty ||
            (song.title?.toLowerCase().contains(searchQuery.toLowerCase()) ?? false) ||
            (song.artist?.toLowerCase().contains(searchQuery.toLowerCase()) ?? false) ||
            (song.album?.toLowerCase().contains(searchQuery.toLowerCase()) ?? false);

       // final matchesGenre = selectedGenre == null || song.genre == selectedGenre;
        final matchesArtist = selectedArtist == null || song.artist == selectedArtist;
        final matchesAlbum = selectedAlbum == null || song.album == selectedAlbum;

        return matchesSearch  && matchesArtist && matchesAlbum;
      }).toList();
    });
  }

  void _playSong(SongData song, int index) async {
    await RecentlyPlayedManager.addRecentlyPlayed(song);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SongPlayerScreen(
          downloadedFiles: filteredSongs,
          initialIndex: index,
        ),
      ),
    );
  }

  // List<String> _getUniqueGenres() {
  //   return allSongs.map((song) => song.genre).whereType<String>().toSet().toList()..sort();
  // }

  List<String> _getUniqueArtists() {
    return allSongs.map((song) => song.artist).whereType<String>().toSet().toList()..sort();
  }

  List<String> _getUniqueAlbums() {
    return allSongs.map((song) => song.album).whereType<String>().toSet().toList()..sort();
  }

  Widget _buildSongTile(SongData song, int index) {
    return ListTile(
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: CachedNetworkImage(
          imageUrl: song.thumbnailUrl ?? '',
          width: 50,
          height: 50,
          fit: BoxFit.cover,
          placeholder: (context, url) => const CircularProgressIndicator(),
          errorWidget: (context, url, error) => const Icon(Icons.music_note),
        ),
      ),
      title: Text(
        song.title ?? 'Unknown Title',
        style: const TextStyle(color: Colors.white),
      ),
      subtitle: Text(
        song.artist ?? 'Unknown Artist',
        style: const TextStyle(color: Colors.white70),
      ),
      trailing: IconButton(
        icon: const Icon(Icons.play_arrow, color: Colors.white),
        onPressed: () => _playSong(song, index),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: TextField(
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            hintText: 'Search songs...',
            hintStyle: TextStyle(color: Colors.white54),
            border: InputBorder.none,
          ),
          onChanged: (value) {
            setState(() {
              searchQuery = value;
              _filterSongs();
            });
          },
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.library_music_rounded),
            onPressed: () => context.push(context, target: const DownloadedSongsScreen()),
          ),
          IconButton(
            icon: const Icon(Icons.home),
            onPressed: () => context.push(context, target: const HomeScreen()),
          ),
        ],
      ),
      body: Column(
        children: [
          TabBar(
            controller: _tabController,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white54,
            indicatorColor: Colors.white,
            tabs: const [
              Tab(text: 'Genre'),
              Tab(text: 'Artist'),
              Tab(text: 'Album'),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                // Expanded(
                //   child: DropdownButton<String>(
                //     hint: const Text('Select Genre', style: TextStyle(color: Colors.white)),
                //     value: selectedGenre,
                //     isExpanded: true,
                //     dropdownColor: Colors.grey.shade800,
                //     items: _getUniqueGenres().map((genre) {
                //       return DropdownMenuItem(
                //         value: genre,
                //         child: Text(genre, style: const TextStyle(color: Colors.white)),
                //       );
                //     }).toList(),
                //     onChanged: (value) {
                //       setState(() {
                //         selectedGenre = value;
                //         _filterSongs();
                //       });
                //     },
                //   ),
                // ),
                if (_tabController.index == 1) ...[
                  const SizedBox(width: 8),
                  Expanded(
                    child: DropdownButton<String>(
                      hint: const Text('Select Artist', style: TextStyle(color: Colors.white)),
                      value: selectedArtist,
                      isExpanded: true,
                      dropdownColor: Colors.grey.shade800,
                      items: _getUniqueArtists().map((artist) {
                        return DropdownMenuItem(
                          value: artist,
                          child: Text(artist, style: const TextStyle(color: Colors.white)),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedArtist = value;
                          _filterSongs();
                        });
                      },
                    ),
                  ),
                ],
                if (_tabController.index == 2) ...[
                  const SizedBox(width: 8),
                  Expanded(
                    child: DropdownButton<String>(
                      hint: const Text('Select Album', style: TextStyle(color: Colors.white)),
                      value: selectedAlbum,
                      isExpanded: true,
                      dropdownColor: Colors.grey.shade800,
                      items: _getUniqueAlbums().map((album) {
                        return DropdownMenuItem(
                          value: album,
                          child: Text(album, style: const TextStyle(color: Colors.white)),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedAlbum = value;
                          _filterSongs();
                        });
                      },
                    ),
                  ),
                ],
              ],
            ),
          ),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator(color: Colors.white))
                : errorMessage != null
                ? Center(child: Text(errorMessage!, style: const TextStyle(color: Colors.white)))
                : filteredSongs.isEmpty
                ? const Center(child: Text('No songs found', style: TextStyle(color: Colors.white)))
                : ListView.builder(
              itemCount: filteredSongs.length,
              itemBuilder: (context, index) => _buildSongTile(filteredSongs[index], index),
            ),
          ),
        ],
      ),
    );
  }
}

class RecentlyPlayedManager {
  static Future<String> _getFilePath() async {
    final directory = await getApplicationDocumentsDirectory();
    return '${directory.path}/recently_played.json';
  }

  static Future<List<SongData>> loadRecentlyPlayed() async {
    try {
      final file = File(await _getFilePath());
      if (await file.exists()) {
        final contents = await file.readAsString();
        final List<dynamic> json = jsonDecode(contents);
        return json.map((map) => SongData.fromMap(map)).toList();
      }
    } catch (e) {
      print('Error loading recently played: $e');
    }
    return [];
  }

  static Future<void> addRecentlyPlayed(SongData song) async {
    try {
      final file = File(await _getFilePath());
      List<SongData> songs = await loadRecentlyPlayed();
      songs.removeWhere((s) => s.path == song.path);
      songs.insert(0, song);
      if (songs.length > 10) songs = songs.sublist(0, 10);
      await file.writeAsString(jsonEncode(songs.map((s) => s.toMap()).toList()));
    } catch (e) {
      print('Error saving recently played: $e');
    }
  }
}