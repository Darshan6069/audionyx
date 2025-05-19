import 'package:audionyx/domain/song_model/song_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repository/bloc/playlist_bloc_cubit/playlist_bloc_cubit.dart';
import '../../repository/bloc/playlist_bloc_cubit/playlist_state.dart';

class PlaylistSelectionPopup extends StatefulWidget {
  final SongData song;

  const PlaylistSelectionPopup({required this.song, super.key});

  @override
  _PlaylistSelectionPopupState createState() => _PlaylistSelectionPopupState();
}

class _PlaylistSelectionPopupState extends State<PlaylistSelectionPopup> {
  String? selectedPlaylistId;

  @override
  void initState() {
    super.initState();
    print('PlaylistSelectionPopup init, song: ${widget.song.title}');
    context.read<PlaylistBlocCubit>().fetchPlaylists();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16.0),
      height: 300,
      color: theme.colorScheme.surface,
      child: BlocConsumer<PlaylistBlocCubit, PlaylistState>(
        listener: (context, state) {
          print('PlaylistState changed: $state');
          if (state is PlaylistSuccess && state.isNewPlaylistCreated) {
            print('New playlist created, resetting selection');
            setState(() {
              selectedPlaylistId = null;
            });
          } else if (state is PlaylistSongsFetched) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Song added to playlist successfully',
                  style: TextStyle(color: theme.colorScheme.onPrimary),
                ),
                backgroundColor: theme.colorScheme.primary,
              ),
            );
            Navigator.pop(context);
          } else if (state is PlaylistFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Failed to add song: ${state.error}',
                  style: TextStyle(color: theme.colorScheme.onError),
                ),
                backgroundColor: theme.colorScheme.error,
              ),
            );
          }
        },
        builder: (context, state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Add Song to Playlist',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 16),
              Expanded(child: _buildPlaylistContent(context, state, theme)),
            ],
          );
        },
      ),
    );
  }

  Widget _buildPlaylistContent(
    BuildContext context,
    PlaylistState state,
    ThemeData theme,
  ) {
    if (state is PlaylistLoading) {
      return Center(
        child: CircularProgressIndicator(color: theme.colorScheme.primary),
      );
    } else if (state is PlaylistFailure) {
      print('Playlist fetch error: ${state.error}');
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Failed to load playlists. Please try again.',
              style: TextStyle(color: theme.colorScheme.onSurface),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                context.read<PlaylistBlocCubit>().fetchPlaylists();
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    } else if (state is PlaylistSuccess && state.playlists.isEmpty) {
      return Center(
        child: Text(
          'No playlists found. Create one first.',
          style: TextStyle(color: theme.colorScheme.onSurface),
        ),
      );
    } else if (state is PlaylistSuccess) {
      // Safely convert state.playlists to List<Map<String, dynamic>>
      final playlists =
          state.playlists
              .whereType<Map>()
              .map((item) => Map<String, dynamic>.from(item))
              .where((map) => map['_id'] is String && map['name'] is String)
              .toList();

      if (playlists.isEmpty) {
        print('No valid playlists found after filtering');
        return Center(
          child: Text(
            'No valid playlists found.',
            style: TextStyle(color: theme.colorScheme.onSurface),
          ),
        );
      }

      return Column(
        children: [
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
              icon: Icon(
                Icons.arrow_drop_down,
                color: theme.colorScheme.onSurfaceVariant,
              ),
              underline: const SizedBox(),
              dropdownColor: theme.colorScheme.surface,
              onChanged: (value) {
                print('Selected playlist ID: $value');
                setState(() {
                  selectedPlaylistId = value;
                });
              },
              items:
                  playlists.map<DropdownMenuItem<String>>((playlist) {
                    return DropdownMenuItem<String>(
                      value: playlist['_id'] as String,
                      child: Text(
                        playlist['name'] as String,
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
              onPressed: () {
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

                print(
                  'Adding song ${widget.song.id} to playlist $selectedPlaylistId',
                );
                context.read<PlaylistBlocCubit>().addSongToPlaylist(
                  selectedPlaylistId!,
                  [widget.song.id],
                );
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
    return Center(
      child: Text(
        'Please wait...',
        style: TextStyle(color: theme.colorScheme.onSurface),
      ),
    );
  }
}
