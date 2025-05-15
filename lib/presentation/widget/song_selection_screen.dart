import 'package:audionyx/repository/bloc/fetch_song_bloc_cubit/fetch_song_bloc_cubit.dart';
import 'package:audionyx/repository/bloc/playlist_bloc_cubit/playlist_bloc_cubit.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repository/bloc/fetch_song_bloc_cubit/fetch_song_state.dart';
import '../../repository/bloc/playlist_bloc_cubit/playlist_state.dart';

class SongSelectionScreen extends StatefulWidget {
  final String playlistId;
  final String playlistName;
  final PlaylistBlocCubit playlistCubit;

  const SongSelectionScreen({
    super.key,
    required this.playlistId,
    required this.playlistName,
    required this.playlistCubit,
  });

  @override
  State<SongSelectionScreen> createState() => _SongSelectionScreenState();
}

class _SongSelectionScreenState extends State<SongSelectionScreen> {
  final List<String> _selectedSongIds = [];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return BlocProvider(
      create: (context) => FetchSongBlocCubit()..fetchSongs(),
      child: BlocListener<PlaylistBlocCubit, PlaylistState>(
        bloc: widget.playlistCubit,
        listener: (context, state) {
          print('SongSelectionScreen PlaylistBlocCubit state: $state');
          if (state is PlaylistFailure && mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error),
                backgroundColor: theme.colorScheme.error,
              ),
            );
          }
        },
        child: Scaffold(
          backgroundColor: theme.scaffoldBackgroundColor,
          appBar: AppBar(
            backgroundColor: theme.scaffoldBackgroundColor,
            title: Text(
              'Add Songs to ${widget.playlistName}',
              style: textTheme.titleLarge?.copyWith(color: colorScheme.onSurface),
            ),
            iconTheme: IconThemeData(color: colorScheme.onSurface),
            actions: [
              TextButton(
                onPressed: _selectedSongIds.isEmpty
                    ? null
                    : () async {
                  print('Adding songs to playlist ${widget.playlistId}: $_selectedSongIds');
                  await widget.playlistCubit.addSongToPlaylist(widget.playlistId, _selectedSongIds);
                  if (!mounted) return;
                  print('Popping SongSelectionScreen');
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Songs added to ${widget.playlistName}'),
                      backgroundColor: colorScheme.primary,
                    ),
                  );
                },
                child: Text(
                  'Add',
                  style: TextStyle(
                    color: _selectedSongIds.isEmpty
                        ? colorScheme.onSurface.withOpacity(0.5)
                        : colorScheme.primary,
                  ),
                ),
              ),
            ],
          ),
          body: BlocBuilder<FetchSongBlocCubit, FetchSongState>(
            builder: (context, state) {
              print('SongSelectionScreen FetchSongBlocCubit state: $state');
              if (state is FetchSongLoading) {
                return Center(child: CircularProgressIndicator(color: colorScheme.primary));
              } else if (state is FetchSongFailure) {
                return Center(
                  child: Text(
                    state.error,
                    style: textTheme.bodyLarge?.copyWith(color: colorScheme.error),
                    textAlign: TextAlign.center,
                  ),
                );
              } else if (state is FetchSongSuccess) {
                if (state.songs.isEmpty) {
                  return Center(
                    child: Text(
                      'No songs available to add.',
                      style: textTheme.bodyLarge?.copyWith(color: colorScheme.onSurface),
                    ),
                  );
                }
                return ListView.builder(
                  itemCount: state.songs.length,
                  itemBuilder: (context, index) {
                    final song = state.songs[index];
                    final isSelected = _selectedSongIds.contains(song.id);
                    return ListTile(
                      leading: CachedNetworkImage(
                        imageUrl: song.thumbnailUrl,
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                        placeholder: (_, __) => Container(color: colorScheme.surface),
                        errorWidget: (_, __, ___) => Icon(Icons.music_note, color: colorScheme.onSurface),
                      ),
                      title: Text(
                        song.title,
                        style: textTheme.bodyLarge?.copyWith(color: colorScheme.onSurface),
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Text(
                        song.artist ?? 'Unknown Artist',
                        style: textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurface.withOpacity(0.6),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: Checkbox(
                        value: isSelected,
                        onChanged: (bool? value) {
                          setState(() {
                            if (value == true) {
                              _selectedSongIds.add(song.id);
                            } else {
                              _selectedSongIds.remove(song.id);
                            }
                          });
                        },
                        activeColor: colorScheme.primary,
                      ),
                      onTap: () {
                        setState(() {
                          if (isSelected) {
                            _selectedSongIds.remove(song.id);
                          } else {
                            _selectedSongIds.add(song.id);
                          }
                        });
                      },
                    );
                  },
                );
              }
              return Center(
                child: Text(
                  'No songs available.',
                  style: textTheme.bodyLarge?.copyWith(color: colorScheme.onSurface),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}