import 'package:audionyx/domain/song_model/song_model.dart';
import 'package:audionyx/presentation/song_play_screen/song_play_screen.dart';
import 'package:audionyx/repository/service/song_service/favorite_song_service/favorite_song_service.dart';
import 'package:flutter/material.dart';

class LikedSongsScreen extends StatefulWidget {
  const LikedSongsScreen({super.key});

  @override
  State<LikedSongsScreen> createState() => _LikedSongsScreenState();
}

class _LikedSongsScreenState extends State<LikedSongsScreen> {
  final FavoriteSongService _apiService = FavoriteSongService();
  List<SongData> likedSongs = [];
  bool isLoading = true;
  bool hasError = false;

  @override
  void initState() {
    super.initState();
    _fetchLikedSongs();
  }

  Future<void> _fetchLikedSongs() async {
    try {
      final songs = await _apiService.getLikedSongs();
      if (mounted) {
        setState(() {
          likedSongs = songs;
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          hasError = true;
          isLoading = false;
        });
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error fetching liked songs: $e'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _navigateToSongPlayer(SongData selectedSong) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SongPlayerScreen(
          songList: likedSongs,
          initialIndex: likedSongs.indexOf(selectedSong),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.black.withOpacity(0.8), const Color(0xFF1A2A44)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(child: _buildBody()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator(color: Colors.white));
    }

    if (hasError) {
      return _buildErrorWidget();
    }

    if (likedSongs.isEmpty) {
      return const Center(
        child: Text(
          'No liked songs yet',
          style: TextStyle(color: Colors.white70, fontSize: 18),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: likedSongs.length,
      itemBuilder: (context, index) {
        final song = likedSongs[index];
        return _buildSongCard(song);
      },
    );
  }

  Widget _buildSongCard(SongData song) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: Colors.white.withOpacity(0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: song.thumbnailUrl != null
              ? Image.network(
            song.thumbnailUrl!,
            width: 50,
            height: 50,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => _buildPlaceholderImage(),
          )
              : _buildPlaceholderImage(),
        ),
        title: Text(
          song.title,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          song.artist,
          style: TextStyle(color: Colors.white.withOpacity(0.7)),
        ),
        trailing: const Icon(Icons.play_circle_outline, color: Colors.white, size: 32),
        onTap: () => _navigateToSongPlayer(song),
      ),
    );
  }

  Widget _buildPlaceholderImage() {
    return Container(
      width: 50,
      height: 50,
      color: Colors.grey.withOpacity(0.3),
      child: const Icon(Icons.music_note, color: Colors.white70),
    );
  }

  Widget _buildErrorWidget() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.error_outline, size: 60, color: Colors.white60),
          const SizedBox(height: 16),
          const Text(
            'Failed to load liked songs',
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          const SizedBox(height: 24),
          TextButton.icon(
            onPressed: _fetchLikedSongs,
            icon: const Icon(Icons.refresh, color: Colors.white),
            label: const Text(
              'Try Again',
              style: TextStyle(color: Colors.white),
            ),
            style: TextButton.styleFrom(
              backgroundColor: Colors.white.withOpacity(0.1),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            ),
          ),
        ],
      ),
    );
  }
}