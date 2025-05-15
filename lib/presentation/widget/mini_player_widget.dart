import 'dart:io';

import 'package:audionyx/core/constants/extension.dart';
import 'package:audionyx/presentation/widget/animated_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:miniplayer/miniplayer.dart';

import '../../repository/bloc/audio_player_bloc_cubit/audio_player_bloc_cubit.dart';
import '../../repository/bloc/audio_player_bloc_cubit/audio_player_state.dart';
import '../song_play_screen/song_play_screen.dart';

class MiniPlayerWidget extends StatelessWidget {
  const MiniPlayerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocBuilder<AudioPlayerBlocCubit, AudioPlayerState>(
      builder: (context, state) {
        if (state.currentSong == null) {
          return const SizedBox.shrink();
        }

        final progress =
            state.duration.inMilliseconds > 0
                ? state.position.inMilliseconds / state.duration.inMilliseconds
                : 0.0;

        return LayoutBuilder(
          builder: (context, constraints) {
            final minHeight =
                constraints.maxHeight * 0.08 > 60
                    ? 60.0
                    : constraints.maxHeight * 0.08;
            final maxHeight =
                constraints.maxHeight * 0.6 > 400
                    ? 400.0
                    : constraints.maxHeight * 0.6;

            return Miniplayer(
              minHeight: minHeight,
              maxHeight: maxHeight,
              elevation: 8,
              backgroundColor: Colors.transparent,
              builder: (height, percentage) {
                return GestureDetector(
                  onTap: () {
                    context.push(
                      context,
                      target: SongPlayerScreen(
                        initialIndex: state.currentIndex,
                        songList: state.songList!,
                      ),
                    );
                  },
                  child: Container(
                    width: constraints.maxWidth, // Explicitly take full width
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          theme.colorScheme.surface.withOpacity(0.95),
                          theme.colorScheme.surfaceContainerHighest.withOpacity(
                            0.95,
                          ),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(16),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: theme.shadowColor.withOpacity(0.3),
                          blurRadius: 12,
                          offset: const Offset(0, -4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Container(
                          height: 4,
                          margin: const EdgeInsets.symmetric(horizontal: 8),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(2),
                            child: LinearProgressIndicator(
                              value: progress,
                              backgroundColor:
                                  theme.colorScheme.surfaceContainerHighest,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                theme.colorScheme.primary,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Row(
                            children: [
                              _buildAlbumArt(state, height, theme),
                              Flexible(child: _buildTrackInfo(state, theme)),
                              _buildControlButtons(
                                context,
                                state,
                                percentage,
                                theme,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _buildAlbumArt(
    AudioPlayerState state,
    double height,
    ThemeData theme,
  ) {
    final constrainedSize = height * 0.8 > 60 ? 60.0 : height * 0.8;
    return Container(
      width: constrainedSize,
      height: constrainedSize,
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withOpacity(0.5),
            blurRadius: 6,
            offset: const Offset(2, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child:
            state.currentSong!.thumbnailUrl.contains('http')
                ? Image.network(
                  state.currentSong!.thumbnailUrl,
                  width: constrainedSize,
                  height: constrainedSize,
                  fit: BoxFit.cover,
                  errorBuilder:
                      (context, error, stackTrace) => Container(
                        color: theme.colorScheme.surfaceContainerHighest,
                        child: Icon(
                          Icons.music_note,
                          size: 30,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                )
                : File(state.currentSong!.thumbnailUrl).existsSync()
                ? Image.file(
                  File(state.currentSong!.thumbnailUrl),
                  width: constrainedSize,
                  height: constrainedSize,
                  fit: BoxFit.cover,
                  errorBuilder:
                      (context, error, stackTrace) => Container(
                        color: theme.colorScheme.surfaceContainerHighest,
                        child: Icon(
                          Icons.music_note,
                          size: 30,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                )
                : Container(
                  color: theme.colorScheme.surfaceContainerHighest,
                  child: Icon(
                    Icons.music_note,
                    size: 30,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
      ),
    );
  }

  Widget _buildTrackInfo(AudioPlayerState state, ThemeData theme) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              state.currentSong!.title,
              style: TextStyle(
                color: theme.colorScheme.onSurface,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              state.currentSong!.artist.isNotEmpty
                  ? state.currentSong!.artist
                  : 'Unknown Artist',
              style: TextStyle(
                color: theme.colorScheme.onSurfaceVariant,
                fontSize: 14,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildControlButtons(
    BuildContext context,
    AudioPlayerState state,
    double percentage,
    ThemeData theme,
  ) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          AnimatedIconButton(
            icon: Icon(
              state.isPlaying ? Icons.pause : Icons.play_arrow,
              color: theme.colorScheme.onSurface,
              size: 28,
            ),
            onPressed: () {
              context.read<AudioPlayerBlocCubit>().togglePlayPause();
            },
          ),
          AnimatedIconButton(
            icon: Icon(
              Icons.skip_next,
              color: theme.colorScheme.onSurface,
              size: 28,
            ),
            onPressed: () {
              context.read<AudioPlayerBlocCubit>().playNext(state.songList!);
            },
          ),
        ],
      ),
    );
  }
}
