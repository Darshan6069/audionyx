import 'dart:io';
import 'package:audionyx/core/constants/extension.dart';
import 'package:audionyx/domain/song_model/song_model.dart';
import 'package:audionyx/presentation/song_play_screen/song_play_screen.dart';
import 'package:audionyx/repository/service/song_service/favorite_song_service/favorite_song_service.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

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
        .push(context, target: SongPlayerScreen(songList: _favoriteSongs, initialIndex: index))
        .then((_) => _loadFavoriteSongs());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isTablet = ResponsiveBreakpoints.of(context).isTablet;
    final isDesktop = ResponsiveBreakpoints.of(context).isDesktop;

    // Responsive padding and sizes
    final horizontalPadding =
        isDesktop
            ? 80.0
            : isTablet
            ? 40.0
            : 20.0;
    final verticalPadding = isDesktop || isTablet ? 30.0 : 20.0;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              theme.brightness == Brightness.dark
                  ? theme.scaffoldBackgroundColor
                  : Colors.white.withOpacity(0.9),
              theme.brightness == Brightness.dark ? theme.scaffoldBackgroundColor : Colors.white,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child:
            _isLoading
                ? Center(child: CircularProgressIndicator(color: theme.colorScheme.secondary))
                : _favoriteSongs.isEmpty
                ? _buildEmptyState(isDesktop, isTablet, theme)
                : _buildSongList(isDesktop, isTablet, theme, horizontalPadding, verticalPadding),
      ),
    );
  }

  Widget _buildEmptyState(bool isDesktop, bool isTablet, ThemeData theme) {
    final iconSize =
        isDesktop
            ? 100.0
            : isTablet
            ? 90.0
            : 80.0;
    final titleFontSize =
        isDesktop
            ? 20.0
            : isTablet
            ? 18.0
            : 16.0;
    final subtitleFontSize =
        isDesktop
            ? 16.0
            : isTablet
            ? 14.0
            : 12.0;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.favorite_border,
            size: iconSize,
            color: theme.iconTheme.color?.withOpacity(0.5),
          ),
          SizedBox(height: isDesktop || isTablet ? 20.0 : 16.0),
          Text(
            'No favorite songs yet',
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.textTheme.bodyLarge?.color?.withOpacity(0.7),
              fontSize: titleFontSize,
            ),
          ),
          SizedBox(height: isDesktop || isTablet ? 12.0 : 8.0),
          Text(
            'Like songs to see them here',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.textTheme.bodyLarge?.color?.withOpacity(0.5),
              fontSize: subtitleFontSize,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSongList(
    bool isDesktop,
    bool isTablet,
    ThemeData theme,
    double horizontalPadding,
    double verticalPadding,
  ) {
    return RefreshIndicator(
      onRefresh: _loadFavoriteSongs,
      color: theme.colorScheme.secondary,
      child: ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: verticalPadding),
        itemCount: _favoriteSongs.length,
        itemBuilder: (context, index) {
          final song = _favoriteSongs[index];
          return _buildSongTile(
            song,
            index,
            isDesktop,
            isTablet,
            theme,
            horizontalPadding,
            verticalPadding,
          );
        },
      ),
    );
  }

  Widget _buildSongTile(
    SongData song,
    int index,
    bool isDesktop,
    bool isTablet,
    ThemeData theme,
    double horizontalPadding,
    double verticalPadding,
  ) {
    final thumbnailSize =
        isDesktop
            ? 64.0
            : isTablet
            ? 60.0
            : 56.0;
    final titleFontSize =
        isDesktop
            ? 18.0
            : isTablet
            ? 16.0
            : 14.0;
    final subtitleFontSize =
        isDesktop
            ? 14.0
            : isTablet
            ? 12.0
            : 10.0;
    final contentPadding =
        isDesktop
            ? const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0)
            : isTablet
            ? const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0)
            : const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0);

    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: horizontalPadding / 2,
        vertical: verticalPadding / 2,
      ),
      decoration: BoxDecoration(
        color:
            theme.brightness == Brightness.dark ? Colors.white.withOpacity(0.05) : Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        contentPadding: contentPadding,
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child:
              song.thumbnailUrl.isNotEmpty
                  ? song.thumbnailUrl.contains('http')
                      ? Image.network(
                        song.thumbnailUrl,
                        width: thumbnailSize,
                        height: thumbnailSize,
                        fit: BoxFit.cover,
                        errorBuilder:
                            (_, __, ___) => Container(
                              width: thumbnailSize,
                              height: thumbnailSize,
                              color: theme.colorScheme.surface,
                              child: Icon(Icons.music_note, color: theme.iconTheme.color),
                            ),
                      )
                      : File(song.thumbnailUrl).existsSync()
                      ? Image.file(
                        File(song.thumbnailUrl),
                        width: thumbnailSize,
                        height: thumbnailSize,
                        fit: BoxFit.cover,
                        errorBuilder:
                            (_, __, ___) => Container(
                              width: thumbnailSize,
                              height: thumbnailSize,
                              color: theme.colorScheme.surface,
                              child: Icon(Icons.music_note, color: theme.iconTheme.color),
                            ),
                      )
                      : Container(
                        width: thumbnailSize,
                        height: thumbnailSize,
                        color: theme.colorScheme.surface,
                        child: Icon(Icons.music_note, color: theme.iconTheme.color),
                      )
                  : Container(
                    width: thumbnailSize,
                    height: thumbnailSize,
                    color: theme.colorScheme.surface,
                    child: Icon(Icons.music_note, color: theme.iconTheme.color),
                  ),
        ),
        title: Text(
          song.title,
          style: theme.textTheme.titleMedium?.copyWith(
            color: theme.textTheme.bodyLarge?.color,
            fontWeight: FontWeight.w500,
            fontSize: titleFontSize,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          song.artist,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.textTheme.bodyLarge?.color?.withOpacity(0.7),
            fontSize: subtitleFontSize,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: IconButton(
          icon: Icon(
            Icons.favorite,
            color: theme.brightness == Brightness.dark ? Colors.pinkAccent : Colors.pink[600],
            size:
                isDesktop
                    ? 28.0
                    : isTablet
                    ? 24.0
                    : 20.0,
          ),
          onPressed: () => _removeFavorite(song),
        ),
        onTap: () => _playSong(index),
      ),
    );
  }
}
