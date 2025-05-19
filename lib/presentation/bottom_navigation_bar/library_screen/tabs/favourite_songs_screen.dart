import 'dart:io';

import 'package:audionyx/core/constants/extension.dart';
import 'package:audionyx/domain/song_model/song_model.dart';
import 'package:audionyx/presentation/song_play_screen/song_play_screen.dart';
import 'package:audionyx/repository/service/song_service/favorite_song_service/favorite_song_service.dart';
import 'package:flutter/material.dart';

class FavoriteSongScreen extends StatefulWidget {
  const FavoriteSongScreen({super.key});

  @override
  State<FavoriteSongScreen> createState() => _FavoriteSongScreenState();
}

class _FavoriteSongScreenState extends State<FavoriteSongScreen> {
  final FavoriteSongService _favoriteService = FavoriteSongService();
  List<SongData> _favoriteSongs = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFavoriteSongs();
  }

  Future<void> _loadFavoriteSongs() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final songs = await _favoriteService.getFavoriteSongs();
      if (mounted) {
        setState(() {
          _favoriteSongs = songs;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Failed to load favorite songs'),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  Future<void> _removeFavorite(SongData song) async {
    final success = await _favoriteService.removeFromFavorites(song);

    if (success && mounted) {
      setState(() {
        _favoriteSongs.removeWhere((s) => s.id == song.id);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Removed from favorites'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.blueGrey,
        ),
      );
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Failed to remove from favorites'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }

  void _playSong(int index) {
    context
        .push(
          context,
          target: SongPlayerScreen(
            songList: _favoriteSongs,
            initialIndex: index,
          ),
        )
        .then((_) {
          // Refresh the list when coming back from player screen
          _loadFavoriteSongs();
        });
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              theme.brightness == Brightness.dark
                  ? theme.scaffoldBackgroundColor
                  : Colors.white.withOpacity(0.9),
              theme.brightness == Brightness.dark
                  ? theme.scaffoldBackgroundColor
                  : Colors.white,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child:
            _isLoading
                ? Center(
                  child: CircularProgressIndicator(
                    color: theme.colorScheme.secondary,
                  ),
                )
                : _favoriteSongs.isEmpty
                ? _buildEmptyState()
                : _buildSongList(),
      ),
    );
  }

  Widget _buildEmptyState() {
    final ThemeData theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.favorite_border,
            size: 80,
            color: theme.iconTheme.color?.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'No favorite songs yet',
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.textTheme.bodyLarge?.color?.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Like songs to see them here',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.textTheme.bodyLarge?.color?.withOpacity(0.5),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSongList() {
    final ThemeData theme = Theme.of(context);
    return RefreshIndicator(
      onRefresh: _loadFavoriteSongs,
      color: theme.colorScheme.secondary,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: _favoriteSongs.length,
        itemBuilder: (context, index) {
          final song = _favoriteSongs[index];
          return _buildSongTile(song, index);
        },
      ),
    );
  }

  Widget _buildSongTile(SongData song, int index) {
    final ThemeData theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color:
            theme.brightness == Brightness.dark
                ? Colors.white.withOpacity(0.05)
                : Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child:
              song.thumbnailUrl.isNotEmpty
                  ? song.thumbnailUrl.contains('http')
                      ? Image.network(
                        song.thumbnailUrl,
                        width: 56,
                        height: 56,
                        fit: BoxFit.cover,
                        errorBuilder:
                            (_, __, ___) => Container(
                              width: 56,
                              height: 56,
                              color: theme.colorScheme.surface,
                              child: Icon(
                                Icons.music_note,
                                color: theme.iconTheme.color,
                              ),
                            ),
                      )
                      : File(song.thumbnailUrl).existsSync()
                      ? Image.file(
                        File(song.thumbnailUrl),
                        width: 56,
                        height: 56,
                        fit: BoxFit.cover,
                        errorBuilder:
                            (_, __, ___) => Container(
                              width: 56,
                              height: 56,
                              color: theme.colorScheme.surface,
                              child: Icon(
                                Icons.music_note,
                                color: theme.iconTheme.color,
                              ),
                            ),
                      )
                      : Container(
                        width: 56,
                        height: 56,
                        color: theme.colorScheme.surface,
                        child: Icon(
                          Icons.music_note,
                          color: theme.iconTheme.color,
                        ),
                      )
                  : Container(
                    width: 56,
                    height: 56,
                    color: theme.colorScheme.surface,
                    child: Icon(Icons.music_note, color: theme.iconTheme.color),
                  ),
        ),
        title: Text(
          song.title,
          style: theme.textTheme.titleMedium?.copyWith(
            color: theme.textTheme.bodyLarge?.color,
            fontWeight: FontWeight.w500,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          song.artist,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.textTheme.bodyLarge?.color?.withOpacity(0.7),
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: IconButton(
          icon: Icon(
            Icons.favorite,
            color:
                theme.brightness == Brightness.dark
                    ? Colors.pinkAccent
                    : Colors.pink[600],
          ),
          onPressed: () => _removeFavorite(song),
        ),
        onTap: () => _playSong(index),
      ),
    );
  }
}
