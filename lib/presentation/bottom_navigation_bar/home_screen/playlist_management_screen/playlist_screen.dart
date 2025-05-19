import 'package:audionyx/core/constants/extension.dart';
import 'package:audionyx/presentation/song_play_screen/song_play_screen.dart';
import 'package:audionyx/repository/bloc/playlist_bloc_cubit/playlist_bloc_cubit.dart';
import 'package:audionyx/repository/bloc/playlist_bloc_cubit/playlist_state.dart';
import 'package:audionyx/repository/service/song_service/playlist_service/playlist_service.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../domain/song_model/song_model.dart';
import '../../../widget/song_selection_screen.dart';

class PlaylistSongsScreen extends StatefulWidget {
  final String playlistId, playlistName;

  const PlaylistSongsScreen({
    super.key,
    required this.playlistId,
    required this.playlistName,
  });

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

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(widget.playlistName),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _loadSongs),
        ],
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
        child: const Icon(Icons.add),
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
          child: _buildContent(context),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, color: colorScheme.error, size: 48),
            const SizedBox(height: 16),
            Text(_error!, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _loadSongs,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (_songs.isEmpty) {
      return const Center(
        child: Text('No songs in this playlist.\nTap + to add songs.'),
      );
    }

    return RefreshIndicator(
      onRefresh: () async => _loadSongs(),
      child: ListView.builder(
        itemCount: _songs.length,
        itemBuilder: (context, index) {
          final song = _songs[index];
          return Dismissible(
            key: Key(song.id),
            background: Container(
              color: colorScheme.error,
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 20),
              child: const Icon(Icons.delete),
            ),
            direction: DismissDirection.endToStart,
            confirmDismiss: (_) => _confirmSongRemoval(context, song),
            child: ListTile(
              leading: CachedNetworkImage(
                imageUrl: song.thumbnailUrl,
                width: 50,
                height: 50,
                fit: BoxFit.cover,
                placeholder: (_, __) => Container(color: colorScheme.surface),
                errorWidget: (_, __, ___) => const Icon(Icons.music_note),
              ),
              title: Text(song.title, overflow: TextOverflow.ellipsis),
              subtitle: Text(
                song.artist ?? 'Unknown Artist',
                overflow: TextOverflow.ellipsis,
              ),
              trailing: IconButton(
                icon: Icon(Icons.remove_circle, color: colorScheme.error),
                onPressed: () => _confirmSongRemoval(context, song),
              ),
              onTap:
                  () => context.push(
                    context,
                    target: SongPlayerScreen(
                      songList: _songs,
                      initialIndex: index,
                    ),
                  ),
            ),
          );
        },
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
            title: Text(
              'Remove Song',
              style: textTheme.titleMedium?.copyWith(
                color: colorScheme.onSurface,
              ),
            ),
            content: Text(
              'Are you sure you want to remove "${song.title}" from "${widget.playlistName}"?',
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext, false),
                child: Text(
                  'Cancel',
                  style: TextStyle(color: colorScheme.onSurface),
                ),
              ),
              TextButton(
                onPressed: () {
                  _playlistCubit.removeSongFromPlaylist(
                    widget.playlistId,
                    song.id,
                  );
                  _playlistCubit.fetchSongsFromPlaylist(widget.playlistId);
                  Navigator.pop(dialogContext, true);
                },
                child: Text(
                  'Remove',
                  style: TextStyle(color: colorScheme.error),
                ),
              ),
            ],
          ),
    );

    return false;
  }
}
