import 'package:audionyx/presentation/song_play_screen/song_play_screen.dart';
import 'package:audionyx/repository/bloc/playlist_bloc_cubit/playlist_bloc_cubit.dart';
import 'package:audionyx/repository/bloc/playlist_bloc_cubit/playlist_state.dart';
import 'package:audionyx/repository/service/song_service/playlist_service/playlist_service.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/constants/theme_color.dart';
import '../../domain/song_model/song_model.dart';

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
    return BlocProvider(
      create: (_) => PlaylistBlocCubit(PlaylistService())..fetchSongsFromPlaylist(widget.playlistId),
      child: Scaffold(
        backgroundColor: ThemeColor.darkBackground,
        appBar: AppBar(
          backgroundColor: ThemeColor.darkBackground,
          title: Text(widget.playlistName, style: const TextStyle(color: ThemeColor.white)),
          iconTheme: const IconThemeData(color: ThemeColor.white),
        ),
        body: BlocConsumer<PlaylistBlocCubit, PlaylistState>(
          listener: (context, state) {
            if (state is PlaylistFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.error),
                  backgroundColor: Colors.red,
                ),
              );
            } else if (state is PlaylistSongsFetched && state.songs.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Playlist is now empty.'),
                  backgroundColor: ThemeColor.grey,
                ),
              );
            }
          },
          builder: (context, state) {
            if (state is PlaylistLoading) {
              return const Center(child: CircularProgressIndicator(color: ThemeColor.white));
            } else if (state is PlaylistFailure) {
              return Center(
                child: Text(
                  state.error,
                  style: const TextStyle(color: Colors.red, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              );
            } else if (state is PlaylistSongsFetched) {
              if (state.songs.isEmpty) {
                return const Center(
                  child: Text(
                    'No songs found in this playlist.',
                    style: TextStyle(color: ThemeColor.white, fontSize: 16),
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
                      placeholder: (_, __) => Container(color: ThemeColor.grey),
                      errorWidget: (_, __, ___) => const Icon(Icons.music_note, color: ThemeColor.white),
                    ),
                    title: Text(
                      song.title,
                      style: const TextStyle(color: ThemeColor.white),
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Text(
                      song.artist ?? 'Unknown Artist',
                      style: const TextStyle(color: ThemeColor.grey, fontSize: 12),
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.remove_circle, color: Colors.red),
                      onPressed: () {
                        _showRemoveSongDialog(context, song, widget.playlistId);
                      },
                    ),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => SongPlayerScreen(
                          songList: state.songs,
                          initialIndex: index,
                        ),
                      ),
                    ),
                  );
                },
              );
            } else {
              return const Center(child: Text('No songs found.'));
            }
            return const Center(
              child: Text(
                'No songs found.',
                style: TextStyle(color: ThemeColor.white, fontSize: 16),
              ),
            );
          },
        ),
      ),
    );
  }

  void _showRemoveSongDialog(BuildContext context, SongData song, String playlistId) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: ThemeColor.darkBackground,
        title: const Text(
          'Remove Song',
          style: TextStyle(color: ThemeColor.white),
        ),
        content: Text(
          'Are you sure you want to remove "${song.title}" from "${widget.playlistName}"?',
          style: const TextStyle(color: ThemeColor.grey),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text(
              'Cancel',
              style: TextStyle(color: ThemeColor.white),
            ),
          ),
          TextButton(
            onPressed: () {
              context.read<PlaylistBlocCubit>().removeSongFromPlaylist(playlistId, song.id);
              Navigator.pop(dialogContext);
            },
            child: const Text(
              'Remove',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}