import 'package:audionyx/repository/service/song_service/playlist_service/playlist_service.dart';
import 'package:flutter/material.dart';

import '../../domain/song_model/song_model.dart';

class AddSongToPlaylistScreen extends StatefulWidget {
  final SongData song;

  const AddSongToPlaylistScreen({required this.song, super.key});

  @override
  _AddSongToPlaylistScreenState createState() => _AddSongToPlaylistScreenState();
}

class _AddSongToPlaylistScreenState extends State<AddSongToPlaylistScreen> {
  late Future<List<dynamic>> playlists;
  String? selectedPlaylistId;

  @override
  void initState() {
    super.initState();
    print('Fetching playlists with token: ${widget.song}');
    playlists = PlaylistService().fetchUserPlaylists();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Song to Playlist')),
      body: FutureBuilder<List<dynamic>>(
        future: playlists,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            print('Playlist fetch error: ${snapshot.error}');
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Failed to load playlists. Please try again.'),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        playlists = PlaylistService().fetchUserPlaylists();
                      });
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          } else {
            final playlists = snapshot.data!;
            if (playlists.isEmpty) {
              return const Center(child: Text('No playlists found. Create one first.'));
            }
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  DropdownButton<String>(
                    hint: const Text('Select Playlist'),
                    value: selectedPlaylistId,
                    isExpanded: true,
                    onChanged: (value) {
                      print('Selected playlist ID: $value');
                      setState(() {
                        selectedPlaylistId = value;
                      });
                    },
                    items: playlists.map<DropdownMenuItem<String>>((playlist) {
                      return DropdownMenuItem<String>(
                        value: playlist['_id'],
                        child: Text(playlist['name']),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      if (selectedPlaylistId == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Please select a playlist')),
                        );
                        return;
                      }

                      try {
                        await PlaylistService().addSongToPlaylist(
                          selectedPlaylistId!,
                          widget.song.id,
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Song added to playlist successfully')),
                        );
                        Navigator.pop(context);
                      } catch (e) {
                        print('Add song error: $e');
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Failed to add song. Please try again.')),
                        );
                      }
                    },
                    child: const Text('Add Song'),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}