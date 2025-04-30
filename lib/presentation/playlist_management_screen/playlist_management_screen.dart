import 'package:audionyx/repository/bloc/playlist_bloc_cubit/playlist_bloc_cubit.dart';
import 'package:audionyx/repository/bloc/playlist_bloc_cubit/playlist_state.dart';
import 'package:audionyx/repository/service/song_service/playlist_service/playlist_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:audionyx/core/constants/extension.dart';
import 'package:audionyx/core/constants/theme_color.dart';
import 'package:audionyx/download_song_screen.dart';
import 'package:audionyx/song_browser_screen.dart';
import 'package:audionyx/presentation/auth_screen/email_auth/login_screen.dart';
import 'package:audionyx/presentation/bottom_navigation_bar/home_screen/home_screen.dart';


class PlaylistManagementScreen extends StatefulWidget {
  const PlaylistManagementScreen({super.key});

  @override
  State<PlaylistManagementScreen> createState() => _PlaylistManagementScreenState();
}

class _PlaylistManagementScreenState extends State<PlaylistManagementScreen> {
  final TextEditingController _playlistNameController = TextEditingController();

  void _showCreatePlaylistDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create New Playlist'),
        content: TextField(
          controller: _playlistNameController,
          decoration: const InputDecoration(
            hintText: 'Enter playlist name',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              final playlistName = _playlistNameController.text.trim();
              if (playlistName.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Playlist name cannot be empty')),
                );
                return;
              }
              context.read<PlaylistBlocCubit>().createPlaylist(playlistName);
              _playlistNameController.clear();
              Navigator.pop(context);
            },
            child: const Text('Create'),
          ),
        ],
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
            style: TextStyle(color: ThemeColor.white),
          ),
          backgroundColor: ThemeColor.darkBackground,
          elevation: 0,
          actions: [
            IconButton(
              icon: const Icon(Icons.add, color: ThemeColor.white),
              onPressed: _showCreatePlaylistDialog,
            ),
            IconButton(
              icon: const Icon(
                Icons.library_music_rounded,
                color: ThemeColor.white,
              ),
              onPressed: () =>
                  context.push(context, target: const DownloadedSongsScreen()),
            ),
            IconButton(
              icon: const Icon(Icons.home, color: ThemeColor.white),
              onPressed: () => context.push(context, target: const HomeScreen()),
            ),
            IconButton(
              icon: const Icon(Icons.search, color: ThemeColor.white),
              onPressed: () =>
                  context.push(context, target: const SongBrowserScreen()),
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
                  SnackBar(content: Text(state.error)),
                );
              }
            } else if (state is PlaylistSuccess) {
              // Show success message only after createPlaylist to avoid on initial fetch
              if (_playlistNameController.text.isNotEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Playlist created successfully')),
                );
                _playlistNameController.text = ''; // Reset to avoid repeated messages
              }
            }
          },
          builder: (context, state) {
            if (state is PlaylistInitial) {
              return const Center(
                child: CircularProgressIndicator(color: ThemeColor.white),
              );
            } else if (state is PlaylistLoading) {
              return const Center(
                child: CircularProgressIndicator(color: ThemeColor.white),
              );
            } else if (state is PlaylistSuccess) {
              if (state.playlists.isEmpty) {
                return const Center(
                  child: Text(
                    'No playlists found',
                    style: TextStyle(color: ThemeColor.white),
                  ),
                );
              }
              return ListView.builder(
                itemCount: state.playlists.length,
                itemBuilder: (context, index) {
                  final playlist = state.playlists[index];
                  final title = playlist['name']?.toString() ?? 'Unknown Playlist';
                  final thumbnailUrl = playlist['thumbnailUrl']?.toString() ?? '';
                  final playlistId = playlist['_id']?.toString() ?? '';

                  return ListTile(
                    trailing: IconButton(
                      onPressed: () {
                        if (playlistId.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Playlist ID is missing')),
                          );
                          return;
                        }
                        context.read<PlaylistBlocCubit>().deletePlaylist(playlistId);
                      },
                      icon: const Icon(Icons.delete),
                    ),
                    leading: Icon(Icons.playlist_play),
                    title: Text(title, style: const TextStyle(color: ThemeColor.white)),
                    onTap: () {
                      // Handle playlist tap (e.g., navigate to PlaylistDetailScreen)
                    },
                  );
                },
              );
            } else if (state is PlaylistFailure) {
              return Center(
                child: Text(
                  state.error,
                  style: const TextStyle(color: ThemeColor.white),
                ),
              );
            }
            // Fallback case (should not occur with freezed)
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}