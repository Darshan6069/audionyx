import 'dart:convert';
import 'package:audionyx/core/constants/app_strings.dart';
import 'package:audionyx/core/constants/extension.dart';
import 'package:audionyx/core/constants/theme_color.dart';
import 'package:audionyx/download_song_screen.dart';
import 'package:audionyx/playlist_screen.dart';
import 'package:audionyx/presentation/auth_screen/email_auth/login_screen.dart';
import 'package:audionyx/presentation/bottom_navigation_bar/home_screen/home_screen.dart';
import 'package:audionyx/song_browser_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:audionyx/repository/bloc/auth_bloc_cubit/login_bloc_cubit/login_bloc_cubit.dart';
import 'package:audionyx/repository/bloc/auth_bloc_cubit/login_bloc_cubit/login_state.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class PlaylistManagementScreen extends StatefulWidget {
  const PlaylistManagementScreen({super.key});

  @override
  State<PlaylistManagementScreen> createState() =>
      _PlaylistManagementScreenState();
}

class _PlaylistManagementScreenState extends State<PlaylistManagementScreen> {
  List<dynamic> userPlaylists = [];
  bool isLoading = false;
  String? errorMessage;
  final TextEditingController _playlistNameController = TextEditingController();
  final _storage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    print('Base URL: ${AppStrings.baseUrl}'); // Debug base URL
    fetchUserPlaylists();
  }

  Future<String?> _getAuthToken(BuildContext context) async {
    final loginState = context.read<LoginBlocCubit>().state;
    if (loginState is LoginSuccess) {
      print('Auth token from login state: ${loginState.token}'); // Debug log
      return loginState.token;
    }
    final token = await _storage.read(key: 'jwt_token');
    print('Auth token from secure storage: $token'); // Debug log
    return token;
  }

  Future<String?> getUserId() async {
     final userId =await _storage.read(key: 'userId');
     print(userId);
     return userId;
  }

  Future<void> fetchUserPlaylists() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final token = await _getAuthToken(context);
      if (token == null) {
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const LoginScreen()),
          );
        }
        throw Exception('Authentication token is missing');
      }

      final url = '${AppStrings.baseUrl}playlists';
      print('Fetching playlists from: $url');

      final response = await http
          .get(
            Uri.parse(url),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token',
            },
          )
          .timeout(const Duration(seconds: 10));

      print(
        'Fetch playlists response: ${response.statusCode} ${response.body}',
      );

      if (response.statusCode == 200) {
        if (mounted) {
          setState(() {
            userPlaylists = jsonDecode(response.body);
            isLoading = false;
          });
        }
      } else if (response.statusCode == 404) {
        if (mounted) {
          setState(() {
            isLoading = false;
            errorMessage =
                'Playlist endpoint not found. Please check the server configuration.';
          });
        }
      } else {
        if (mounted) {
          setState(() {
            isLoading = false;
            errorMessage =
                'Failed to load playlists: Status ${response.statusCode}, ${response.body}';
          });
        }
      }
    } catch (e) {
      print('Fetch playlists error: $e');
      if (mounted) {
        setState(() {
          isLoading = false;
          errorMessage = 'Error fetching playlists: $e';
        });
      }
    }
  }

  Future<void> createPlaylist() async {
    final playlistName = _playlistNameController.text.trim();
    if (playlistName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Playlist name cannot be empty')),
      );
      return;
    }

    try {
      final token = await _getAuthToken(context);
      if (token == null) {
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const LoginScreen()),
          );
        }
        throw Exception('Authentication token is missing');
      }

      print('Token length: ${token.length}'); // Debug token
      final url = '${AppStrings.baseUrl}playlists/create';
      print('Creating playlist at: $url');

      final response = await http
          .post(
            Uri.parse(url),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token',
            },
            body: jsonEncode({
              'name': playlistName,
              'description': 'A new playlist created by the user',
              'thumbnailUrl': '',
              'songs': [],
            }),
          )
          .timeout(const Duration(seconds: 10));

      print(
        'Create playlist response: ${response.statusCode} ${response.body}',
      );

      if (response.statusCode == 201) {
        _playlistNameController.clear();
        await fetchUserPlaylists();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Playlist created successfully')),
          );
        }
      } else if (response.statusCode == 404) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Playlist creation endpoint not found. Please check the server.',
              ),
            ),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Failed to create playlist: Status ${response.statusCode}, ${response.body}',
              ),
            ),
          );
        }
      }
    } catch (e) {
      print('Create playlist error: $e');
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error creating playlist: $e')));
      }
    }
  }

  Future<void> deletePlaylist(String playlistId) async {
    final token = await _storage.read(key: 'jwt_token');
    final userId = await getUserId();

    // Debug logs for missing data
    print('Playlist ID: $playlistId');
    print('User ID: $userId');
    print('Auth token: $token');

    if (playlistId.isEmpty || token == null || userId == null) {
      throw Exception('Playlist ID, user ID, or token is missing');
    }

    final url = '${AppStrings.baseUrl}playlists/users/$userId/playlists/$playlistId';
    print('Delete playlist URL: $url');

    try {
      final response = await http.delete(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        print('Playlist deleted successfully');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Playlist deleted successfully')),
        );
        await fetchUserPlaylists(); // Refresh playlist list
      } else {
        print('Failed to delete playlist: ${response.statusCode}, ${response.body}');
        throw Exception('Failed to delete playlist: ${response.body}');
      }
    } catch (e) {
      print('Delete playlist error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting playlist: $e')),
      );
    }
  }


  void _showCreatePlaylistDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
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
                  Navigator.pop(context);
                  createPlaylist();
                },
                child: const Text('Create'),
              ),
            ],
          ),
    );
  }

  Widget _buildPlaylistTile(Map<String, dynamic> playlist) {
    final title = playlist['name']?.toString() ?? 'Unknown Playlist';
    final thumbnailUrl = playlist['thumbnailUrl']?.toString() ?? '';
    final playlistId = playlist['_id']?.toString();
    print(playlistId);

    return ListTile(
      trailing: IconButton(
        onPressed: () async {

              final playlistId = playlist['_id']?.toString();
              if (playlistId == null || playlistId.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Playlist ID is missing')),
                );
                return;
              }
              await deletePlaylist(playlistId);
        },
        icon: Icon(Icons.delete),
      ),
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: CachedNetworkImage(
          imageUrl: thumbnailUrl,
          width: 50,
          height: 50,
          fit: BoxFit.cover,
          placeholder: (context, url) => const CircularProgressIndicator(),
          errorWidget:
              (context, url, error) =>
                  const Icon(Icons.playlist_play, color: ThemeColor.white),
        ),
      ),
      title: Text(title, style: const TextStyle(color: ThemeColor.white)),
      onTap: () {
        // if (playlistId == null) {
        //   ScaffoldMessenger.of(context).showSnackBar(
        //     const SnackBar(content: Text('Playlist ID is missing')),
        //   );
        //   return;
        // }
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => PlaylistDetailScreen(playlist: playlist),
        //   ),
        // );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            onPressed:
                () => context.push(
                  context,
                  target: const DownloadedSongsScreen(),
                ),
          ),
          IconButton(
            icon: const Icon(Icons.home, color: ThemeColor.white),
            onPressed: () => context.push(context, target: const HomeScreen()),
          ),
          IconButton(
            icon: const Icon(Icons.search, color: ThemeColor.white),
            onPressed:
                () => context.push(context, target: const SongBrowserScreen()),
          ),
        ],
      ),
      body:
          isLoading
              ? const Center(
                child: CircularProgressIndicator(color: ThemeColor.white),
              )
              : errorMessage != null
              ? Center(
                child: Text(
                  errorMessage!,
                  style: const TextStyle(color: ThemeColor.white),
                ),
              )
              : userPlaylists.isEmpty
              ? const Center(
                child: Text(
                  'No playlists found',
                  style: TextStyle(color: ThemeColor.white),
                ),
              )
              : ListView.builder(
                itemCount: userPlaylists.length,
                itemBuilder:
                    (context, index) =>
                        _buildPlaylistTile(userPlaylists[index]),
              ),
    );
  }
}
