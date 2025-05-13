import 'package:audionyx/core/constants/extension.dart';
import 'package:audionyx/presentation/song_play_screen/song_play_screen.dart';
import 'package:audionyx/repository/bloc/playlist_bloc_cubit/playlist_bloc_cubit.dart';
import 'package:audionyx/repository/bloc/playlist_bloc_cubit/playlist_state.dart';
import 'package:audionyx/repository/service/song_service/playlist_service/playlist_service.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../domain/song_model/song_model.dart';

class PlaylistSongsScreen extends StatefulWidget {
  final String playlistId;
  final String playlistName;

  const PlaylistSongsScreen({
    super.key,
    required this.playlistId,
    required this.playlistName,
  });

  @override
  State<PlaylistSongsScreen> createState() => _PlaylistSongsScreenState();
}

class _PlaylistSongsScreenState extends State<PlaylistSongsScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return BlocProvider(
      create: (_) => PlaylistBlocCubit(PlaylistService())..fetchSongsFromPlaylist(widget.playlistId),
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: theme.scaffoldBackgroundColor,
          title: Text(
              widget.playlistName,
              style: textTheme.titleLarge?.copyWith(color: colorScheme.onSurface)
          ),
          iconTheme: IconThemeData(color: colorScheme.onSurface),
        ),
        body: BlocConsumer<PlaylistBlocCubit, PlaylistState>(
          listener: (context, state) {
            if (state is PlaylistFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.error),
                  backgroundColor: theme.colorScheme.error,
                ),
              );
            } else if (state is PlaylistSongsFetched && state.songs.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Playlist is now empty.'),
                  backgroundColor: colorScheme.secondary,
                ),
              );
            }
          },
          builder: (context, state) {
            if (state is PlaylistLoading) {
              return Center(
                  child: CircularProgressIndicator(color: colorScheme.primary)
              );
            } else if (state is PlaylistFailure) {
              return Center(
                child: Text(
                  state.error,
                  style: textTheme.bodyLarge?.copyWith(color: colorScheme.error),
                  textAlign: TextAlign.center,
                ),
              );
            } else if (state is PlaylistSongsFetched) {
              if (state.songs.isEmpty) {
                return Center(
                  child: Text(
                    'No songs found in this playlist.',
                    style: textTheme.bodyLarge?.copyWith(color: colorScheme.onSurface),
                  ),
                );
              }
              return ListView.builder(
                itemCount: state.songs.length,
                itemBuilder: (context, index) {
                  final song = state.songs[index];
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
                      style: textTheme.bodySmall?.copyWith(color: colorScheme.onSurface.withOpacity(0.6)),
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.remove_circle, color: colorScheme.error),
                      onPressed: () {
                        _showRemoveSongDialog(context, song, widget.playlistId);
                      },
                    ),
                    onTap: () => context.push(context, target: SongPlayerScreen(
                      songList: state.songs,
                      initialIndex: index,
                    ),
                    )
                  );
                },
              );
            } else {
              return Center(
                child: Text(
                  'No songs found.',
                  style: textTheme.bodyLarge?.copyWith(color: colorScheme.onSurface),
                ),
              );
            }
          },
        ),
      ),
    );
  }

  void _showRemoveSongDialog(BuildContext context, SongData song, String playlistId) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: theme.scaffoldBackgroundColor,
        title: Text(
          'Remove Song',
          style: textTheme.titleMedium?.copyWith(color: colorScheme.onSurface),
        ),
        content: Text(
          'Are you sure you want to remove "${song.title}" from "${widget.playlistName}"?',
          style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurface.withOpacity(0.7)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(
              'Cancel',
              style: TextStyle(color: colorScheme.onSurface),
            ),
          ),
          TextButton(
            onPressed: () {
              context.read<PlaylistBlocCubit>().removeSongFromPlaylist(playlistId, song.id);
              Navigator.pop(dialogContext);
            },
            child: Text(
              'Remove',
              style: TextStyle(color: colorScheme.error),
            ),
          ),
        ],
      ),
    );
  }
}