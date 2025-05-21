import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_framework/responsive_framework.dart';
import '../../../repository/bloc/audio_player_bloc_cubit/audio_player_bloc_cubit.dart';
import '../../../repository/bloc/audio_player_bloc_cubit/audio_player_state.dart';
import 'lyrics_widget.dart';

void showLyricsModal({
  required BuildContext context,
  required AudioPlayerState state,
  DraggableScrollableController? controller,
  required VoidCallback onClosed,
}) {
  final isTablet = ResponsiveBreakpoints.of(context).isTablet;
  final isDesktop = ResponsiveBreakpoints.of(context).isDesktop;
  final initialChildSize =
      isDesktop
          ? 0.8
          : isTablet
          ? 0.75
          : 0.7;
  final minChildSize =
      isDesktop
          ? 0.4
          : isTablet
          ? 0.35
          : 0.3;
  final maxChildSize =
      isDesktop
          ? 0.95
          : isTablet
          ? 0.92
          : 0.9;
  final paddingH =
      isDesktop
          ? 40.0
          : isTablet
          ? 24.0
          : 16.0;
  final paddingV =
      isDesktop
          ? 20.0
          : isTablet
          ? 16.0
          : 12.0;
  final thumbnailSize =
      isDesktop
          ? 48.0
          : isTablet
          ? 44.0
          : 40.0;
  final titleFontSize =
      isDesktop
          ? 18.0
          : isTablet
          ? 17.0
          : 16.0;
  final artistFontSize =
      isDesktop
          ? 16.0
          : isTablet
          ? 15.0
          : 14.0;

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    enableDrag: true,
    elevation: 20,
    isDismissible: true,
    builder:
        (modalContext) => BlocProvider.value(
          value: context.read<AudioPlayerBlocCubit>(),
          child: DraggableScrollableSheet(
            initialChildSize: initialChildSize,
            minChildSize: minChildSize,
            maxChildSize: maxChildSize,
            controller: controller,
            builder:
                (context, scrollController) => Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.95),
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                  ),
                  child: Column(
                    children: [
                      // Handle bar and close button
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: paddingV, horizontal: paddingH),
                        child: Row(
                          children: [
                            Container(
                              width: thumbnailSize,
                              height: 5,
                              decoration: BoxDecoration(
                                color: Colors.grey[400],
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            const Spacer(),
                            IconButton(
                              icon: Icon(
                                Icons.close,
                                color: Colors.white70,
                                size: thumbnailSize * 0.6,
                              ),
                              onPressed: () => Navigator.of(context).pop(),
                            ),
                          ],
                        ),
                      ),
                      // Song info
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: paddingH),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(6),
                              child: Image.network(
                                state.currentSong?.thumbnailUrl ?? '',
                                width: thumbnailSize,
                                height: thumbnailSize,
                                fit: BoxFit.cover,
                                errorBuilder:
                                    (context, error, stackTrace) => Container(
                                      width: thumbnailSize,
                                      height: thumbnailSize,
                                      color: Colors.grey[800],
                                      child: Icon(
                                        Icons.music_note,
                                        color: Colors.white70,
                                        size: thumbnailSize * 0.6,
                                      ),
                                    ),
                              ),
                            ),
                            SizedBox(width: paddingH * 0.5),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    state.currentSong?.title ?? 'Unknown Title',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: titleFontSize,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    state.currentSong?.artist ?? 'Unknown Artist',
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: artistFontSize,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: paddingV * 0.5),
                      // Lyrics List
                      Expanded(
                        child: LyricsWidget(
                          lyrics: state.lyrics,
                          onLyricTap: (duration) {
                            context.read<AudioPlayerBlocCubit>().seekTo(duration);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
          ),
        ),
  ).whenComplete(onClosed);
}
