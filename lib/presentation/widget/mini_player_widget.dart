import 'dart:io';
import 'package:audionyx/presentation/song_play_screen/song_play_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:miniplayer/miniplayer.dart';

import '../../core/constants/extension.dart';
import '../../repository/bloc/audio_player_bloc_cubit/audio_player_bloc_cubit.dart';
import '../../repository/bloc/audio_player_bloc_cubit/audio_player_state.dart';

class MiniPlayerWidget extends StatelessWidget {
  const MiniPlayerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AudioPlayerBlocCubit, AudioPlayerState>(
      builder: (context, state) {
        if (state.currentSong == null) {
          return const SizedBox.shrink();
        }

        final progress = state.duration.inMilliseconds > 0
            ? state.position.inMilliseconds / state.duration.inMilliseconds
            : 0.0;

        return Miniplayer(
          minHeight: context.height(context) * 0.08,
          maxHeight: context.height(context) * 0.6,
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
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.black87, Colors.grey.shade900],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 12,
                      offset: Offset(0, -4),
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
                          backgroundColor: Colors.grey.shade700,
                          valueColor: const AlwaysStoppedAnimation<Color>(
                              Colors.blueAccent),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Row(
                        children: [
                          _buildAlbumArt(state, height),
                          _buildTrackInfo(state),
                          _buildControlButtons(context, state, percentage),
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
  }

  /// Builds the album art container with a shadow and rounded corners.
  Widget _buildAlbumArt(AudioPlayerState state, double height) {
    return Container(
      width: height * 0.8,
      height: height * 0.8,
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [
          BoxShadow(
            color: Colors.black45,
            blurRadius: 6,
            offset: Offset(2, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: state.currentSong!.thumbnailUrl.contains('http')
            ? Image.network(
          state.currentSong!.thumbnailUrl,
          width: height * 0.8,
          height: height * 0.8,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => Container(
            color: Colors.grey[300],
            child: const Icon(Icons.music_note, size: 30, color: Colors.grey),
          ),
        )
            : File(state.currentSong!.thumbnailUrl).existsSync()
            ? Image.file(
          File(state.currentSong!.thumbnailUrl),
          width: height * 0.8,
          height: height * 0.8,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => Container(
            color: Colors.grey[300],
            child: const Icon(Icons.music_note, size: 30, color: Colors.grey),
          ),
        )
            : Container(
          color: Colors.grey[300],
          child: const Icon(Icons.music_note, size: 30, color: Colors.grey),
        ),
      ),
    );
  }

  /// Builds the track title and artist information.
  Widget _buildTrackInfo(AudioPlayerState state) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              state.currentSong!.title,
              style: const TextStyle(
                color: Colors.white,
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
                color: Colors.grey.shade400,
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

  /// Builds the control buttons (play/pause, next, and more options).
  Widget _buildControlButtons(
      BuildContext context, AudioPlayerState state, double percentage) {
    return Padding(
      padding:  EdgeInsets.all(context.width(context) * 0.04),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _AnimatedIconButton(
            icon: Icon(
              state.isPlaying ? Icons.pause : Icons.play_arrow,
              color: Colors.white,
              size: 28,
            ),
            onPressed: () {
              context.read<AudioPlayerBlocCubit>().togglePlayPause();
            },
          ),
          _AnimatedIconButton(
            icon: const Icon(
              Icons.skip_next,
              color: Colors.white,
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

/// A custom icon button with a scale animation on tap.
class _AnimatedIconButton extends StatefulWidget {
  final Icon icon;
  final VoidCallback onPressed;

  const _AnimatedIconButton({
    required this.icon,
    required this.onPressed,
  });

  @override
  State<_AnimatedIconButton> createState() => _AnimatedIconButtonState();
}

class _AnimatedIconButtonState extends State<_AnimatedIconButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.8).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) => _controller.reverse(),
      onTapCancel: () => _controller.reverse(),
      onTap: widget.onPressed,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: widget.icon,
        ),
      ),
    );
  }
}