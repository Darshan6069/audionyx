import 'package:audionyx/core/constants/extension.dart';
import 'package:audionyx/domain/song_model/song_model.dart';
import 'package:audionyx/presentation/widget/playlist_selection_popup.dart';
import 'package:audionyx/presentation/song_play_screen/widget/progress_slider_widget.dart';
import 'package:audionyx/repository/service/song_service/audio_service/audio_service.dart';
import 'package:audionyx/repository/service/song_service/share_song_service/share_song_service.dart'; // Import the new service
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class PlayerControlsWidget extends StatefulWidget {
  final AudioPlayerService audioPlayerService;
  final List<SongData> songList;
  final SongData currentSong;
  final bool isLiked;
  final VoidCallback onLikePressed;

  const PlayerControlsWidget({
    super.key,
    required this.audioPlayerService,
    required this.songList,
    required this.currentSong,
    required this.isLiked,
    required this.onLikePressed,
  });

  @override
  State<PlayerControlsWidget> createState() => _PlayerControlsWidgetState();
}

class _PlayerControlsWidgetState extends State<PlayerControlsWidget> {
  // Create an instance of the share service
  final ShareSongService _shareSongService = ShareSongService();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 20,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          ProgressSliderWidget(audioPlayerService: widget.audioPlayerService),
          _buildMediaControls(),
          _buildActionButtons(),
        ],
      ),
    );
  }

  Widget _buildMediaControls() {
    return StreamBuilder<PlayerState>(
      stream: widget.audioPlayerService.playerStateStream,
      builder: (context, snapshot) {
        final playerState = snapshot.data;
        final isPlaying = playerState?.playing ?? widget.audioPlayerService.isPlaying;

        final currentIndex = widget.audioPlayerService.currentIndex ?? 0;
        final canPlayPrevious = currentIndex > 0;
        final canPlayNext = currentIndex < widget.songList.length - 1;

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              icon: Icon(
                widget.audioPlayerService.isShuffling ? Icons.shuffle_on : Icons.shuffle,
                color: widget.audioPlayerService.isShuffling ? Colors.greenAccent : Colors.white,
              ),
              onPressed: () {
                setState(() {
                  widget.audioPlayerService.toggleShuffle();
                });
              },
              splashRadius: 24,
            ),
            IconButton(
              icon: const Icon(Icons.skip_previous, color: Colors.white, size: 32),
              onPressed: canPlayPrevious
                  ? () {
                print('Playing previous song, currentIndex: $currentIndex');
                widget.audioPlayerService.playPrevious(widget.songList);
              }
                  : null,
              splashRadius: 24,
            ),
            _buildPlayPauseButton(isPlaying),
            IconButton(
              icon: const Icon(Icons.skip_next, color: Colors.white, size: 32),
              onPressed: canPlayNext
                  ? () {
                print('Playing next song, currentIndex: $currentIndex');
                widget.audioPlayerService.playNext(widget.songList);
              }
                  : null,
              splashRadius: 24,
            ),
            IconButton(
              icon: Icon(
                widget.audioPlayerService.loopMode == LoopMode.one ? Icons.repeat_one : Icons.repeat,
                color: widget.audioPlayerService.loopMode != LoopMode.off ? Colors.greenAccent : Colors.white,
              ),
              onPressed: () {
                setState(() {
                  widget.audioPlayerService.toggleRepeatMode();
                });
              },
              splashRadius: 24,
            ),
          ],
        );
      },
    );
  }

  Widget _buildPlayPauseButton(bool isPlaying) {
    return Material(
      color: Colors.greenAccent,
      borderRadius: BorderRadius.circular(32),
      elevation: 4,
      child: InkWell(
        borderRadius: BorderRadius.circular(32),
        onTap: widget.audioPlayerService.togglePlayPause,
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Icon(
            isPlaying ? Icons.pause : Icons.play_arrow,
            color: Colors.black,
            size: 32,
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildActionButton(
            icon: widget.isLiked ? Icons.favorite : Icons.favorite_border,
            label: 'Like',
            color: widget.isLiked ? Colors.pinkAccent : Colors.white70,
            onPressed: widget.onLikePressed,
          ),
          _buildActionButton(
            icon: Icons.playlist_add,
            label: 'Add to Playlist',
            color: Colors.orangeAccent,
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (context) => PlaylistSelectionPopup(song: widget.currentSong),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                backgroundColor: Colors.grey[900], // Match your app's theme
              );            },
          ),
          _buildActionButton(
            icon: Icons.share,
            label: 'Share',
            color: Colors.blueAccent,
            onPressed: () {
              // Use the share service instead of inline code
              _shareSongService.shareSong(widget.currentSong, context: context);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          child: InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: onPressed,
            child: Container(
              padding: const EdgeInsets.all(8),
              child: Icon(icon, color: color, size: 26),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 12),
        ),
      ],
    );
  }
}