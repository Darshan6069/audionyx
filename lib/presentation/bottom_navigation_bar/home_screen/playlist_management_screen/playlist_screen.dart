import 'package:audionyx/core/constants/extension.dart';
import 'package:audionyx/presentation/song_play_screen/song_play_screen.dart';
import 'package:audionyx/repository/bloc/playlist_bloc_cubit/playlist_bloc_cubit.dart';
import 'package:audionyx/repository/bloc/playlist_bloc_cubit/playlist_state.dart';
import 'package:audionyx/repository/service/song_service/playlist_service/playlist_service.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_framework/responsive_framework.dart';
import '../../../../../../domain/song_model/song_model.dart';
import '../../../widget/song_selection_screen.dart';

class PlaylistSongsScreen extends StatefulWidget {
  final String playlistId, playlistName;

  const PlaylistSongsScreen({super.key, required this.playlistId, required this.playlistName});

  @override
  State<PlaylistSongsScreen> createState() => _PlaylistSongsScreenState();
}

class _PlaylistSongsScreenState extends State<PlaylistSongsScreen> {
  late final PlaylistBlocCubit _playlistCubit;
  List<SongData> _songs = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _playlistCubit = PlaylistBlocCubit(PlaylistService());
    _loadSongs();
  }

  void _loadSongs() {
    setState(() => _isLoading = true);
    _playlistCubit.fetchSongsFromPlaylist(widget.playlistId);
  }

  @override
  void dispose() {
    context.read<PlaylistBlocCubit>().fetchPlaylists();
    _playlistCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    // Responsive breakpoints
    final isTablet = ResponsiveBreakpoints.of(context).isTablet;
    final isDesktop = ResponsiveBreakpoints.of(context).largerThan(TABLET);
    final isMobile = ResponsiveBreakpoints.of(context).equals(MOBILE);

    // Responsive padding
    final horizontalPadding =
        isDesktop
            ? 32.0
            : isTablet
            ? 24.0
            : 16.0;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          widget.playlistName,
          style: textTheme.titleLarge?.copyWith(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(icon: Icon(Icons.refresh, color: colorScheme.primary), onPressed: _loadSongs),
        ],
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [colorScheme.surface.withOpacity(0.8), theme.scaffoldBackgroundColor],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (_) => SongSelectionScreen(
                    playlistId: widget.playlistId,
                    playlistName: widget.playlistName,
                    playlistCubit: _playlistCubit,
                  ),
            ),
          );
          if (result == true && mounted) _loadSongs();
        },
        backgroundColor: colorScheme.primary,
        child: Icon(Icons.add, color: colorScheme.onPrimary),
      ),
      body: BlocProvider.value(
        value: _playlistCubit,
        child: BlocListener<PlaylistBlocCubit, PlaylistState>(
          listener: (context, state) {
            setState(() {
              if (state is PlaylistSongsFetched) {
                _songs = state.songs;
                _isLoading = false;
                _error = null;
              } else if (state is PlaylistFailure) {
                _isLoading = false;
                _error = state.error;
              } else if (state is PlaylistLoading) {
                _isLoading = true;
              }
            });
          },
          child: _buildContent(context, horizontalPadding),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, double horizontalPadding) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    // Responsive breakpoints
    final isDesktop = ResponsiveBreakpoints.of(context).largerThan(TABLET);
    final isTablet = ResponsiveBreakpoints.of(context).isTablet;
    final isMobile = ResponsiveBreakpoints.of(context).equals(MOBILE);

    // Responsive sizes
    final iconSize =
        isDesktop
            ? 64.0
            : isTablet
            ? 56.0
            : 48.0;
    final leadingWidth =
        isDesktop
            ? 60.0
            : isTablet
            ? 55.0
            : 50.0;
    final contentSpacing =
        isDesktop
            ? 24.0
            : isTablet
            ? 20.0
            : 16.0;

    if (_isLoading) {
      return Center(child: CircularProgressIndicator(color: colorScheme.primary));
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, color: colorScheme.error, size: iconSize),
            SizedBox(height: contentSpacing),
            Text(
              _error!,
              textAlign: TextAlign.center,
              style: textTheme.bodyLarge?.copyWith(color: colorScheme.onSurface),
            ),
            SizedBox(height: contentSpacing),
            ElevatedButton.icon(
              onPressed: _loadSongs,
              icon: Icon(Icons.refresh, color: colorScheme.onPrimary),
              label: Text('Retry', style: TextStyle(color: colorScheme.onPrimary)),
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.primary,
                padding: EdgeInsets.symmetric(
                  horizontal: isMobile ? 20 : 24,
                  vertical: isMobile ? 12 : 14,
                ),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
              ),
            ),
          ],
        ),
      );
    }

    if (_songs.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.music_note, color: colorScheme.secondary, size: iconSize),
            SizedBox(height: contentSpacing),
            Text(
              'No songs in this playlist',
              style: textTheme.headlineSmall?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Tap + to add songs to your playlist',
              style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurface.withOpacity(0.7)),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    // Grid view for desktop and tablet layouts
    if (isDesktop || isTablet) {
      final crossAxisCount = isDesktop ? 2 : 1;

      return Padding(
        padding: EdgeInsets.all(horizontalPadding),
        child: RefreshIndicator(
          onRefresh: () async => _loadSongs(),
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              childAspectRatio: 4.0,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: _songs.length,
            itemBuilder: (context, index) {
              final song = _songs[index];
              return _buildSongCard(context, song, index, leadingWidth);
            },
          ),
        ),
      );
    }

    // List view for mobile layout
    return RefreshIndicator(
      onRefresh: () async => _loadSongs(),
      child: ListView.builder(
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: horizontalPadding),
        itemCount: _songs.length,
        itemBuilder: (context, index) {
          final song = _songs[index];
          return _buildSongTile(context, song, index, leadingWidth);
        },
      ),
    );
  }

  Widget _buildSongCard(BuildContext context, SongData song, int index, double leadingWidth) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Card(
      color: colorScheme.surface,
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap:
            () => context.push(
              context,
              target: SongPlayerScreen(songList: _songs, initialIndex: index),
            ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: CachedNetworkImage(
                  imageUrl: song.thumbnailUrl,
                  width: leadingWidth,
                  height: leadingWidth,
                  fit: BoxFit.cover,
                  placeholder: (_, __) => Container(color: colorScheme.surface),
                  errorWidget: (_, __, ___) => Icon(Icons.music_note, color: colorScheme.primary),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      song.title,
                      style: textTheme.titleMedium?.copyWith(
                        color: colorScheme.onSurface,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      song.artist ?? 'Unknown Artist',
                      style: textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurface.withOpacity(0.7),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(Icons.remove_circle, color: colorScheme.error),
                onPressed: () => _confirmSongRemoval(context, song),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSongTile(BuildContext context, SongData song, int index, double leadingWidth) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Dismissible(
      key: Key(song.id),
      background: Container(
        color: colorScheme.error,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: Icon(Icons.delete, color: colorScheme.onError),
      ),
      direction: DismissDirection.endToStart,
      confirmDismiss: (_) => _confirmSongRemoval(context, song),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CachedNetworkImage(
          imageUrl: song.thumbnailUrl,
          width: leadingWidth,
          height: leadingWidth,
          fit: BoxFit.cover,
          placeholder: (_, __) => Container(color: colorScheme.surface),
          errorWidget: (_, __, ___) => Icon(Icons.music_note, color: colorScheme.primary),
        ),
        title: Text(
          song.title,
          style: textTheme.titleMedium?.copyWith(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          song.artist ?? 'Unknown Artist',
          style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurface.withOpacity(0.7)),
          overflow: TextOverflow.ellipsis,
        ),
        trailing: IconButton(
          icon: Icon(Icons.remove_circle, color: colorScheme.error),
          onPressed: () => _confirmSongRemoval(context, song),
        ),
        onTap:
            () => context.push(
              context,
              target: SongPlayerScreen(songList: _songs, initialIndex: index),
            ),
      ),
    );
  }

  Future<bool> _confirmSongRemoval(BuildContext context, SongData song) async {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    await showDialog<bool>(
      context: context,
      builder:
          (dialogContext) => AlertDialog(
            backgroundColor: theme.scaffoldBackgroundColor,
            title: Text(
              'Remove Song',
              style: textTheme.titleMedium?.copyWith(color: colorScheme.onSurface),
            ),
            content: Text(
              'Are you sure you want to remove "${song.title}" from "${widget.playlistName}"?',
              style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurface.withOpacity(0.7)),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext, false),
                child: Text('Cancel', style: TextStyle(color: colorScheme.onSurface)),
              ),
              TextButton(
                onPressed: () {
                  _playlistCubit.removeSongFromPlaylist(widget.playlistId, song.id);
                  _playlistCubit.fetchSongsFromPlaylist(widget.playlistId);
                  Navigator.pop(dialogContext, true);
                },
                child: Text('Remove', style: TextStyle(color: colorScheme.error)),
              ),
            ],
          ),
    );

    return false;
  }
}
