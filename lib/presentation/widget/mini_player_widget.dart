import 'dart:io';
import 'package:audionyx/core/constants/extension.dart';
import 'package:audionyx/presentation/widget/animated_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:miniplayer/miniplayer.dart';
import 'package:responsive_framework/responsive_framework.dart';
import '../../repository/bloc/audio_player_bloc_cubit/audio_player_bloc_cubit.dart';
import '../../repository/bloc/audio_player_bloc_cubit/audio_player_state.dart';
import '../song_play_screen/song_play_screen.dart';

class MiniPlayerWidget extends StatelessWidget {
  const MiniPlayerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isTablet = ResponsiveBreakpoints.of(context).isTablet;
    final isDesktop = ResponsiveBreakpoints.of(context).isDesktop;

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
            // Responsive sizes
            final minHeight =
                isDesktop
                    ? 80.0
                    : isTablet
                    ? 70.0
                    : 60.0;
            final maxHeight =
                isDesktop
                    ? 500.0
                    : isTablet
                    ? 450.0
                    : 400.0;
            final albumArtSize =
                isDesktop
                    ? 80.0
                    : isTablet
                    ? 70.0
                    : 60.0;
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
            final buttonSize =
                isDesktop
                    ? 32.0
                    : isTablet
                    ? 28.0
                    : 24.0;
            final horizontalPadding =
                isDesktop
                    ? 16.0
                    : isTablet
                    ? 12.0
                    : 8.0;

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
                    width: constraints.maxWidth,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          theme.colorScheme.surface.withOpacity(0.95),
                          theme.colorScheme.surfaceContainerHighest.withOpacity(0.95),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
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
                          margin: EdgeInsets.symmetric(horizontal: horizontalPadding),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(2),
                            child: LinearProgressIndicator(
                              value: progress,
                              backgroundColor: theme.colorScheme.surfaceContainerHighest,
                              valueColor: AlwaysStoppedAnimation<Color>(theme.colorScheme.primary),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Row(
                            children: [
                              // Album art
                              _buildAlbumArt(state, albumArtSize, theme, horizontalPadding),
                              // Track info
                              Expanded(
                                flex: 3,
                                child: _buildTrackInfo(
                                  state,
                                  theme,
                                  titleFontSize,
                                  subtitleFontSize,
                                  horizontalPadding,
                                ),
                              ),
                              // Control buttons
                              SizedBox(
                                width:
                                    isDesktop
                                        ? 140.0
                                        : isTablet
                                        ? 130.0
                                        : 120.0,
                                child: _buildControlButtons(
                                  context,
                                  state,
                                  percentage,
                                  theme,
                                  buttonSize,
                                ),
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
    double albumArtSize,
    ThemeData theme,
    double horizontalPadding,
  ) {
    return Container(
      width: albumArtSize,
      height: albumArtSize,
      margin: EdgeInsets.all(horizontalPadding),
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
                  width: albumArtSize,
                  height: albumArtSize,
                  fit: BoxFit.cover,
                  errorBuilder:
                      (context, error, stackTrace) => Container(
                        color: theme.colorScheme.surfaceContainerHighest,
                        child: Icon(
                          Icons.music_note,
                          size: albumArtSize / 2,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                )
                : File(state.currentSong!.thumbnailUrl).existsSync()
                ? Image.file(
                  File(state.currentSong!.thumbnailUrl),
                  width: albumArtSize,
                  height: albumArtSize,
                  fit: BoxFit.cover,
                  errorBuilder:
                      (context, error, stackTrace) => Container(
                        color: theme.colorScheme.surfaceContainerHighest,
                        child: Icon(
                          Icons.music_note,
                          size: albumArtSize / 2,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                )
                : Container(
                  color: theme.colorScheme.surfaceContainerHighest,
                  child: Icon(
                    Icons.music_note,
                    size: albumArtSize / 2,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
      ),
    );
  }

  Widget _buildTrackInfo(
    AudioPlayerState state,
    ThemeData theme,
    double titleFontSize,
    double subtitleFontSize,
    double horizontalPadding,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            state.currentSong!.title,
            style: TextStyle(
              color: theme.colorScheme.onSurface,
              fontWeight: FontWeight.w600,
              fontSize: titleFontSize,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: horizontalPadding / 2),
          Text(
            state.currentSong!.artist.isNotEmpty ? state.currentSong!.artist : 'Unknown Artist',
            style: TextStyle(color: theme.colorScheme.onSurfaceVariant, fontSize: subtitleFontSize),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildControlButtons(
    BuildContext context,
    AudioPlayerState state,
    double percentage,
    ThemeData theme,
    double buttonSize,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AnimatedIconButton(
          icon: Icon(
            state.isPlaying ? Icons.pause : Icons.play_arrow,
            color: theme.colorScheme.onSurface,
            size: buttonSize,
          ),
          onPressed: () {
            context.read<AudioPlayerBlocCubit>().togglePlayPause();
          },
        ),
        SizedBox(width: buttonSize / 3),
        AnimatedIconButton(
          icon: Icon(Icons.skip_next, color: theme.colorScheme.onSurface, size: buttonSize),
          onPressed: () {
            context.read<AudioPlayerBlocCubit>().playNext(state.songList!);
          },
        ),
      ],
    );
  }
}
