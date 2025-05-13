import 'package:audionyx/repository/service/song_service/playlist_service/playlist_service.dart';
import 'package:flutter/material.dart';

import '../../domain/song_model/song_model.dart';

class PlaylistSelectionPopup extends StatefulWidget {
  final SongData song;

  const PlaylistSelectionPopup({required this.song, super.key});

  @override
  _PlaylistSelectionPopupState createState() => _PlaylistSelectionPopupState();
}

class _PlaylistSelectionPopupState extends State<PlaylistSelectionPopup> {
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
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16.0),
      height: 300, // Adjust height as needed
      // Using surface color from theme
      color: theme.colorScheme.surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Add Song to Playlist',
            // Using primary text color from theme with proper typography
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: FutureBuilder<List<dynamic>>(
              future: playlists,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(
                      // Using primary color from theme
                      color: theme.colorScheme.primary,
                    ),
                  );
                } else if (snapshot.hasError) {
                  print('Playlist fetch error: ${snapshot.error}');
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Failed to load playlists. Please try again.',
                          // Using on surface color from theme
                          style: TextStyle(color: theme.colorScheme.onSurface),
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              playlists = PlaylistService().fetchUserPlaylists();
                            });
                          },
                          // Button already uses theme styling from main.dart
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  );
                } else {
                  final playlists = snapshot.data!;
                  if (playlists.isEmpty) {
                    return Center(
                      child: Text(
                        'No playlists found. Create one first.',
                        // Using on surface color from theme
                        style: TextStyle(color: theme.colorScheme.onSurface),
                      ),
                    );
                  }
                  return Column(
                    children: [
                      // Using theme-consistent dropdown
                      Container(
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: DropdownButton<String>(
                          hint: Text(
                            'Select Playlist',
                            style: TextStyle(color: theme.colorScheme.onSurfaceVariant),
                          ),
                          value: selectedPlaylistId,
                          isExpanded: true,
                          // Using dropdown theme alignment
                          icon: Icon(Icons.arrow_drop_down, color: theme.colorScheme.onSurfaceVariant),
                          underline: const SizedBox(), // Remove underline
                          dropdownColor: theme.colorScheme.surface,
                          onChanged: (value) {
                            print('Selected playlist ID: $value');
                            setState(() {
                              selectedPlaylistId = value;
                            });
                          },
                          items: playlists.map<DropdownMenuItem<String>>((playlist) {
                            return DropdownMenuItem<String>(
                              value: playlist['_id'],
                              child: Text(
                                playlist['name'],
                                style: TextStyle(color: theme.colorScheme.onSurface),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () async {
                            if (selectedPlaylistId == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Please select a playlist',
                                    style: TextStyle(color: theme.colorScheme.onPrimary),
                                  ),
                                  backgroundColor: theme.colorScheme.primary,
                                ),
                              );
                              return;
                            }

                            try {
                              await PlaylistService().addSongToPlaylist(
                                selectedPlaylistId!,
                                widget.song.id,
                              );
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Song added to playlist successfully',
                                    style: TextStyle(color: theme.colorScheme.onPrimary),
                                  ),
                                  backgroundColor: theme.colorScheme.primary,
                                ),
                              );
                              Navigator.pop(context); // Close the bottom sheet
                            } catch (e) {
                              print('Add song error: $e');
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Failed to add song. Please try again.',
                                    style: TextStyle(color: theme.colorScheme.onError),
                                  ),
                                  backgroundColor: theme.colorScheme.error,
                                ),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: theme.colorScheme.primary,
                            foregroundColor: theme.colorScheme.onPrimary,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text('Add Song'),
                        ),
                      ),
                    ],
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}