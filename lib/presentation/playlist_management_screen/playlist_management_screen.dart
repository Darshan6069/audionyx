import 'package:audionyx/playlist_screen.dart';
import 'package:audionyx/presentation/playlist_management_screen/widget/create_playlist_dialog_widget.dart';
import 'package:audionyx/presentation/playlist_management_screen/widget/playlist_tile_widget.dart';
import 'package:audionyx/repository/bloc/playlist_bloc_cubit/playlist_bloc_cubit.dart';
import 'package:audionyx/repository/bloc/playlist_bloc_cubit/playlist_state.dart';
import 'package:audionyx/repository/service/song_service/playlist_service/playlist_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:audionyx/core/constants/extension.dart';
import 'package:audionyx/core/constants/theme_color.dart';
import 'package:audionyx/presentation/download_song_screen/download_song_screen.dart';
import 'package:audionyx/presentation/bottom_navigation_bar/search_screen/song_browser_screen.dart';
import 'package:audionyx/presentation/auth_screen/email_auth/login_screen.dart';

class PlaylistManagementScreen extends StatefulWidget {
  const PlaylistManagementScreen({super.key});

  @override
  State<PlaylistManagementScreen> createState() => _PlaylistManagementScreenState();
}

class _PlaylistManagementScreenState extends State<PlaylistManagementScreen> {
  @override
  void initState() {
    super.initState();
    context.read<PlaylistBlocCubit>().fetchPlaylists();
  }

  final TextEditingController _playlistNameController = TextEditingController();

  void _showCreatePlaylistDialog() {
    showDialog(
      context: context,
      builder: (context) => CreatePlaylistDialogWidget(
        controller: _playlistNameController,
        onCreate: (playlistName) {
          context.read<PlaylistBlocCubit>().createPlaylist(playlistName);
          _playlistNameController.clear();
          Navigator.pop(context);
        },
        onCancel: () => Navigator.pop(context),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PlaylistBlocCubit(PlaylistService())..fetchPlaylists(),
      child: Scaffold(
        backgroundColor: ThemeColor.darkBackground,
        appBar: AppBar(
          title: const Text(
            'My Playlists',
            style: TextStyle(
              color: ThemeColor.white,
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [ThemeColor.darGreyColor.withOpacity(0.8), ThemeColor.darkBackground],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.add, size: 28),
              onPressed: _showCreatePlaylistDialog,
              tooltip: 'Create Playlist',
            ),
            IconButton(
              icon: const Icon(Icons.library_music_rounded,  size: 28),
              onPressed: () => context.push(context, target: const DownloadedSongsScreen()),
              tooltip: 'Downloaded Songs',
            ),
            IconButton(
              icon: const Icon(Icons.search,  size: 28),
              onPressed: () => context.push(context, target: const SongBrowserScreen()),
              tooltip: 'Search Songs',
            ),
          ],
        ),
        body: BlocConsumer<PlaylistBlocCubit, PlaylistState>(
          listener: (context, state) {
            if (state is PlaylistFailure) {
              if (state.error.contains('Authentication token is missing')) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.error),
                    backgroundColor: ThemeColor.darGreyColor,
                  ),
                );
              }
            } else if (state is PlaylistSuccess && state.isNewPlaylistCreated) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Playlist created successfully'),
                ),
              );
              context.read<PlaylistBlocCubit>().fetchPlaylists(); // Refresh playlists
            }
          },
          builder: (context, state) {
            if (state is PlaylistInitial || state is PlaylistLoading) {
              return const Center(
                child: CircularProgressIndicator(color: ThemeColor.greenAccent),
              );
            } else if (state is PlaylistSuccess) {
              if (state.playlists.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.queue_music,
                        color: ThemeColor.grey,
                        size: 80,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'No playlists yet',
                        style: TextStyle(
                          color: ThemeColor.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Create your first playlist!',
                        style: TextStyle(
                          color: ThemeColor.grey,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: _showCreatePlaylistDialog,
                        icon: const Icon(Icons.add, color: ThemeColor.white),
                        label: const Text(
                          'Create Playlist',
                          style: TextStyle(color: ThemeColor.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }
              return ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                itemCount: state.playlists.length,
                itemBuilder: (context, index) {
                  final playlist = state.playlists[index];
                  final title = playlist['name']?.toString() ?? 'Unknown Playlist';
                  final playlistId = playlist['_id']?.toString() ?? '';

                  return PlaylistTileWidget(
                    title: title,
                    playlistId: playlistId,
                    onTap: () => context.push(
                      context,
                      target: PlaylistSongsScreen(
                        playlistId: playlistId,
                        playlistName: title,
                      ),
                    ),
                    onDelete: () {
                      if (playlistId.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Playlist ID is missing'),
                            backgroundColor: ThemeColor.darGreyColor,
                          ),
                        );
                        return;
                      }
                      context.read<PlaylistBlocCubit>().deletePlaylist(playlistId);
                    },
                  );
                },
              );
            } else if (state is PlaylistFailure) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      color: ThemeColor.grey,
                      size: 80,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      state.error,
                      style: const TextStyle(
                        color: ThemeColor.white,
                        fontSize: 18,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => context.read<PlaylistBlocCubit>().fetchPlaylists(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ThemeColor.greenAccent,
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                      child: const Text(
                        'Retry',
                        style: TextStyle(color: ThemeColor.white),
                      ),
                    ),
                  ],
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}