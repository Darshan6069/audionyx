import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../repository/bloc/audio_player_bloc_cubit/audio_player_bloc_cubit.dart';
import '../../../repository/bloc/audio_player_bloc_cubit/audio_player_state.dart';
import 'lyrics_widget.dart';

void showLyricsModal({
  required BuildContext context,
  required AudioPlayerState state,
  DraggableScrollableController? controller,
  required VoidCallback onClosed,
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    enableDrag: true,
    elevation: 20,
    isDismissible: true,
    builder: (modalContext) => BlocProvider.value(
      value: context.read<AudioPlayerBlocCubit>(),
      child: DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.3,
        maxChildSize: 0.9,
        controller: controller,
        builder: (context, scrollController) => Container(
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.95),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              // Handle bar and close button
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 18),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Colors.grey[400],
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white70),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
              ),
              // Song info
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: Image.network(
                        state.currentSong?.thumbnailUrl ?? '',
                        width: 40,
                        height: 40,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            Container(
                              width: 40,
                              height: 40,
                              color: Colors.grey[800],
                              child: const Icon(Icons.music_note, color: Colors.white70),
                            ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            state.currentSong?.title ?? 'Unknown Title',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            state.currentSong?.artist ?? 'Unknown Artist',
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
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
              const SizedBox(height: 10),
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