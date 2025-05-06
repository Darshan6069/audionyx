import 'package:audionyx/presentation/song_play_screen/song_play_screen.dart';
import 'package:audionyx/presentation/widget/mini_player.dart';
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
  List<SongData> songs = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    PlaylistBlocCubit(PlaylistService()).fetchSongsFromPlaylist(widget.playlistId);
  }

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
                SnackBar(content: Text(state.error)),
              );
            }
          },
          builder: (context, state) {
            if (state is PlaylistLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is PlaylistFailure) {
              return Center(child: Text(state.error, style: const TextStyle(color: Colors.red)));
            } else if (state is PlaylistSongsFetched) {
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
                    title: Text(song.title, style: const TextStyle(color: ThemeColor.white)),
                    subtitle: Text(song.artist ?? '', style: const TextStyle(color: ThemeColor.grey, fontSize: 12)),
                    trailing: IconButton(
                      icon: const Icon(Icons.remove_circle, color: Colors.red),
                      onPressed: () {
                        context.read<PlaylistBlocCubit>().removeSongFromPlaylist(widget.playlistId, song.id);
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
          },
        ),
      ),
    );
  }
}
