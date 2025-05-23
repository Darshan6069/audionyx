import 'package:audionyx/repository/bloc/fetch_song_bloc_cubit/fetch_song_bloc_cubit.dart';
import 'package:audionyx/repository/bloc/playlist_bloc_cubit/playlist_bloc_cubit.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_framework/responsive_framework.dart';
import '../../repository/bloc/fetch_song_bloc_cubit/fetch_song_state.dart';
import '../../repository/bloc/playlist_bloc_cubit/playlist_state.dart';

class SongSelectionScreen extends StatefulWidget {
  final String playlistId;
  final String playlistName;
  final PlaylistBlocCubit playlistCubit;

  const SongSelectionScreen({
    super.key,
    required this.playlistId,
    required this.playlistName,
    required this.playlistCubit,
  });

  @override
  State<SongSelectionScreen> createState() => _SongSelectionScreenState();
}

class _SongSelectionScreenState extends State<SongSelectionScreen> {
  final List<String> _selectedSongIds = [];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
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
    final titleFontSize =
        isDesktop
            ? 24.0
            : isTablet
            ? 20.0
            : 18.0;
    final bodyFontSize =
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
    final thumbnailSize =
        isDesktop
            ? 64.0
            : isTablet
            ? 60.0
            : 50.0;
    final contentPadding =
        isDesktop
            ? const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0)
            : isTablet
            ? const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0)
            : const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0);

    return BlocProvider(
      create: (context) => FetchSongBlocCubit()..fetchSongs(),
      child: BlocListener<PlaylistBlocCubit, PlaylistState>(
        bloc: widget.playlistCubit,
        listener: (context, state) {
          print('SongSelectionScreen PlaylistBlocCubit state: $state');
          if (state is PlaylistFailure && mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error), backgroundColor: theme.colorScheme.error),
            );
          }
        },
        child: Scaffold(
          backgroundColor: theme.scaffoldBackgroundColor,
          appBar: AppBar(
            backgroundColor: theme.scaffoldBackgroundColor,
            title: Text(
              'Add Songs to ${widget.playlistName}',
              style: textTheme.titleLarge?.copyWith(
                color: colorScheme.onSurface,
                fontSize: titleFontSize,
              ),
            ),
            iconTheme: IconThemeData(
              color: colorScheme.onSurface,
              size:
                  isDesktop
                      ? 28.0
                      : isTablet
                      ? 24.0
                      : 20.0,
            ),
            actions: [
              TextButton(
                onPressed:
                    _selectedSongIds.isEmpty
                        ? null
                        : () async {
                          print('Adding songs to playlist ${widget.playlistId}: $_selectedSongIds');
                          await widget.playlistCubit.addSongToPlaylist(
                            widget.playlistId,
                            _selectedSongIds,
                          );
                          if (!mounted) return;
                          print('Popping SongSelectionScreen');
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Songs added to ${widget.playlistName}'),
                              backgroundColor: colorScheme.primary,
                            ),
                          );
                        },
                child: Text(
                  'Add',
                  style: TextStyle(
                    color:
                        _selectedSongIds.isEmpty
                            ? colorScheme.onSurface.withOpacity(0.5)
                            : colorScheme.primary,
                    fontSize:
                        isDesktop
                            ? 16.0
                            : isTablet
                            ? 14.0
                            : 12.0,
                  ),
                ),
              ),
            ],
          ),
          body: BlocBuilder<FetchSongBlocCubit, FetchSongState>(
            builder: (context, state) {
              print('SongSelectionScreen FetchSongBlocCubit state: $state');
              if (state is FetchSongLoading) {
                return Center(child: CircularProgressIndicator(color: colorScheme.primary));
              } else if (state is FetchSongFailure) {
                return Center(
                  child: Text(
                    state.error,
                    style: textTheme.bodyLarge?.copyWith(
                      color: colorScheme.error,
                      fontSize: bodyFontSize,
                    ),
                    textAlign: TextAlign.center,
                  ),
                );
              } else if (state is FetchSongSuccess) {
                if (state.songs.isEmpty) {
                  return Center(
                    child: Text(
                      'No songs available to add.',
                      style: textTheme.bodyLarge?.copyWith(
                        color: colorScheme.onSurface,
                        fontSize: bodyFontSize,
                      ),
                    ),
                  );
                }
                return ListView.builder(
                  padding: EdgeInsets.symmetric(
                    horizontal: horizontalPadding,
                    vertical: verticalPadding,
                  ),
                  itemCount: state.songs.length,
                  itemBuilder: (context, index) {
                    final song = state.songs[index];
                    final isSelected = _selectedSongIds.contains(song.id);
                    return ListTile(
                      contentPadding: contentPadding,
                      leading: CachedNetworkImage(
                        imageUrl: song.thumbnailUrl,
                        width: thumbnailSize,
                        height: thumbnailSize,
                        fit: BoxFit.cover,
                        placeholder: (_, __) => Container(color: colorScheme.surface),
                        errorWidget:
                            (_, __, ___) => Icon(
                              Icons.music_note,
                              color: colorScheme.onSurface,
                              size:
                                  isDesktop
                                      ? 28.0
                                      : isTablet
                                      ? 24.0
                                      : 20.0,
                            ),
                      ),
                      title: Text(
                        song.title,
                        style: textTheme.bodyLarge?.copyWith(
                          color: colorScheme.onSurface,
                          fontSize: bodyFontSize,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Text(
                        song.artist ?? 'Unknown Artist',
                        style: textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurface.withOpacity(0.6),
                          fontSize: subtitleFontSize,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: Checkbox(
                        value: isSelected,
                        onChanged: (bool? value) {
                          setState(() {
                            if (value == true) {
                              _selectedSongIds.add(song.id);
                            } else {
                              _selectedSongIds.remove(song.id);
                            }
                          });
                        },
                        activeColor: colorScheme.primary,
                      ),
                      onTap: () {
                        setState(() {
                          if (isSelected) {
                            _selectedSongIds.remove(song.id);
                          } else {
                            _selectedSongIds.add(song.id);
                          }
                        });
                      },
                    );
                  },
                );
              }
              return Center(
                child: Text(
                  'No songs available.',
                  style: textTheme.bodyLarge?.copyWith(
                    color: colorScheme.onSurface,
                    fontSize: bodyFontSize,
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
