import 'package:audionyx/domain/song_model/song_model.dart';
import 'package:audionyx/presentation/song_play_screen/widget/progress_slider_widget.dart';
import 'package:audionyx/repository/service/song_service/audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:share_plus/share_plus.dart';

import '../../../repository/service/song_service/favorite_song_service/favorite_song_service.dart';

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
  final FavoriteSongService _favoriteSongService = FavoriteSongService();

  void _shareSong(SongData song) {
    Share.share(
      'Check out this song: ${song.title} by ${song.artist} and song is${song.mp3Url}',
    );
  }

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
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        IconButton(
          icon: Icon(
            widget.audioPlayerService.isShuffling ? Icons.shuffle_on : Icons.shuffle,
            color: widget.audioPlayerService.isShuffling ? Colors.greenAccent : Colors.white,
          ),
          onPressed: () => setState(() => widget.audioPlayerService.toggleShuffle()),
          splashRadius: 24,
        ),
        IconButton(
          icon: const Icon(Icons.skip_previous, color: Colors.white, size: 32),
          onPressed: () => widget.audioPlayerService.playPrevious(widget.songList),
          splashRadius: 24,
        ),
        _buildPlayPauseButton(),
        IconButton(
          icon: const Icon(Icons.skip_next, color: Colors.white, size: 32),
          onPressed: () => widget.audioPlayerService.playNext(widget.songList),
          splashRadius: 24,
        ),
        IconButton(
          icon: Icon(
            widget.audioPlayerService.loopMode == LoopMode.one ? Icons.repeat_one : Icons.repeat,
            color: widget.audioPlayerService.loopMode != LoopMode.off ? Colors.greenAccent : Colors.white,
          ),
          onPressed: () => setState(() => widget.audioPlayerService.toggleRepeatMode()),
          splashRadius: 24,
        ),
      ],
    );
  }

  Widget _buildPlayPauseButton() {
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
            widget.audioPlayerService.isPlaying ? Icons.pause : Icons.play_arrow,
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
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Added to playlist'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
          ),
          _buildActionButton(
            icon: Icons.share,
            label: 'Share',
            color: Colors.blueAccent,
            onPressed: () => _shareSong(widget.currentSong),
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