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
  State<PlaylistManagementScreen> createState() => _PlaylistManagementScreenState();
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
      return loginState.token;
    }
    return await _storage.read(key: 'auth_token');
  }

  Future<String?> _getUserId(BuildContext context) async {
    final loginState = context.read<LoginBlocCubit>().state;
    if (loginState is LoginSuccess) {
      return loginState.userId; // Make sure LoginSuccess contains userId
    }
    return await _storage.read(key: 'userId');
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

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ).timeout(const Duration(seconds: 10));

      print('Fetch playlists response: ${response.statusCode} ${response.body}');

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
            errorMessage = 'Playlist endpoint not found. Please check the server configuration.';
          });
        }
      } else {
        if (mounted) {
          setState(() {
            isLoading = false;
            errorMessage = 'Failed to load playlists: Status ${response.statusCode}, ${response.body}';
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

      final response = await http.post(
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
      ).timeout(const Duration(seconds: 10));

      print('Create playlist response: ${response.statusCode} ${response.body}');

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
              content: Text('Playlist creation endpoint not found. Please check the server.'),
            ),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to create playlist: Status ${response.statusCode}, ${response.body}'),
            ),
          );
        }
      }
    } catch (e) {
      print('Create playlist error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error creating playlist: $e')),
        );
      }
    }
  }

  void _showCreatePlaylistDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create New Playlist'),
        content: TextField(
          controller: _playlistNameController,
          decoration: const InputDecoration(hintText: 'Enter playlist name'),
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

    return ListTile(
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: CachedNetworkImage(
          imageUrl: thumbnailUrl,
          width: 50,
          height: 50,
          fit: BoxFit.cover,
          placeholder: (context, url) => const CircularProgressIndicator(),
          errorWidget: (context, url, error) => const Icon(
            Icons.playlist_play,
            color: ThemeColor.white,
          ),
        ),
      ),
      title: Text(
        title,
        style: const TextStyle(color: ThemeColor.white),
      ),
      onTap: () {
        if (playlist['id'] == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Playlist ID is missing')),
          );
          return;
        }
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PlaylistDetailScreen(playlist: playlist),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColor.darkBackground,
      appBar: AppBar(
        title: const Text('My Playlists', style: TextStyle(color: ThemeColor.white)),
        backgroundColor: ThemeColor.darkBackground,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: ThemeColor.white),
            onPressed: _showCreatePlaylistDialog,
          ),
          IconButton(
            icon: const Icon(Icons.library_music_rounded, color: ThemeColor.white),
            onPressed: () => context.push(context, target: const DownloadedSongsScreen()),
          ),
          IconButton(
            icon: const Icon(Icons.home, color: ThemeColor.white),
            onPressed: () => context.push(context, target: const HomeScreen()),
          ),
          IconButton(
            icon: const Icon(Icons.search, color: ThemeColor.white),
            onPressed: () => context.push(context, target: const SongBrowserScreen()),
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: ThemeColor.white))
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
        itemBuilder: (context, index) => _buildPlaylistTile(userPlaylists[index]),
      ),
    );
  }
}

class PlaylistDetailScreen extends StatefulWidget {
  final Map<String, dynamic> playlist;

  const PlaylistDetailScreen({super.key, required this.playlist});

  @override
  State<PlaylistDetailScreen> createState() => _PlaylistDetailScreenState();
}

class _PlaylistDetailScreenState extends State<PlaylistDetailScreen> {
  final TextEditingController _songController = TextEditingController();
  List<dynamic> songs = [];
  final _storage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    songs = List.from(widget.playlist['songs'] ?? []);
  }

  Future<String?> _getAuthToken(BuildContext context) async {
    final loginState = context.read<LoginBlocCubit>().state;
    if (loginState is LoginSuccess) {
      return loginState.token;
    }
    return await _storage.read(key: 'auth_token');
  }

  Future<void> addSongToPlaylist(String songTitle) async {
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

      final url = '${AppStrings.baseUrl}playlists/${widget.playlist['id']}';
      print('Updating playlist at: $url');

      final response = await http.put(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'name': widget.playlist['name'],
          'description': widget.playlist['description'] ?? 'A new playlist created by the user',
          'thumbnailUrl': widget.playlist['thumbnailUrl'] ?? '',
          'songs': [...songs, {'name': songTitle}],
        }),
      ).timeout(const Duration(seconds: 10));

      print('Add song response: ${response.statusCode} ${response.body}');

      if (response.statusCode == 200) {
        if (mounted) {
          setState(() {
            songs.add({'name': songTitle});
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Song added successfully')),
          );
        }
      } else if (response.statusCode == 404) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Playlist update endpoint not found. Please check the server.'),
            ),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to add song: Status ${response.statusCode}, ${response.body}'),
            ),
          );
        }
      }
    } catch (e) {
      print('Add song error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error adding song: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.playlist['name']?.toString() ?? 'Unknown Playlist';
    return Scaffold(
      backgroundColor: ThemeColor.darkBackground,
      appBar: AppBar(
        title: Text(title, style: const TextStyle(color: ThemeColor.white)),
        backgroundColor: ThemeColor.darkBackground,
        elevation: 0,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _songController,
                    decoration: const InputDecoration(
                      hintText: 'Enter song title',
                      hintStyle: TextStyle(color: ThemeColor.white),
                      border: OutlineInputBorder(),
                    ),
                    style: const TextStyle(color: ThemeColor.white),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    final songTitle = _songController.text.trim();
                    if (songTitle.isNotEmpty) {
                      addSongToPlaylist(songTitle);
                      _songController.clear();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Song title cannot be empty')),
                      );
                    }
                  },
                  child: const Text('Add Song'),
                ),
              ],
            ),
          ),
          Expanded(
            child: songs.isEmpty
                ? const Center(
              child: Text(
                'No songs in this playlist',
                style: TextStyle(color: ThemeColor.white),
              ),
            )
                : ListView.builder(
              itemCount: songs.length,
              itemBuilder: (context, index) {
                final song = songs[index];
                return ListTile(
                  title: Text(
                    song['name']?.toString() ?? 'Unknown Song',
                    style: const TextStyle(color: ThemeColor.white),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}