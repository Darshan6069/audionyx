import 'dart:convert';
import 'package:audionyx/core/constants/extension.dart';
import 'package:audionyx/core/constants/theme_color.dart';
import 'package:audionyx/download_song_screen.dart';
import 'package:audionyx/playlist_screen.dart';
import 'package:audionyx/presentation/bottom_navigation_bar/home_screen/home_screen.dart';
import 'package:audionyx/song_browser_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';

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

  @override
  void initState() {
    super.initState();
    fetchUserPlaylists();
  }

  Future<void> fetchUserPlaylists() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final response = await http
          .get(Uri.parse('http://192.168.0.3:4000/api/user/playlists'))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        if (mounted) {
          setState(() {
            userPlaylists = jsonDecode(response.body);
            isLoading = false;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            isLoading = false;
            errorMessage = 'Failed to load playlists';
          });
        }
      }
    } catch (e) {
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
      final response = await http
          .post(
        Uri.parse('http://192.168.0.3:4000/api/playlists'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'title': playlistName,
          'thumbnailUrl': '',
          'songs': [],
        }),
      )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 201) {
        _playlistNameController.clear();
        fetchUserPlaylists();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Playlist created successfully')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to create playlist')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error creating playlist: $e')),
      );
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
              createPlaylist();
              Navigator.pop(context);
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaylistTile(Map<String, dynamic> playlist) {
    final title = playlist['title']?.toString() ?? 'Unknown Playlist';
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
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PlaylistsScreen(),
        ),
      ),
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