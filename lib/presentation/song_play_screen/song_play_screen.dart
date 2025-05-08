import 'package:audionyx/domain/song_model/song_model.dart';
import 'package:audionyx/presentation/song_play_screen/widget/player_app_bar.dart';
import 'package:audionyx/presentation/song_play_screen/widget/player_control_widget.dart';
import 'package:audionyx/presentation/song_play_screen/widget/song_info_widget.dart';
import 'package:audionyx/presentation/song_play_screen/widget/song_thumbnail.dart';
import 'package:audionyx/repository/service/song_service/audio_service/audio_service.dart';
import 'package:audionyx/repository/service/song_service/favorite_song_service/favorite_song_service.dart';
import 'package:flutter/material.dart';

class SongPlayerScreen extends StatefulWidget {
  final List<SongData> songList;
  final int initialIndex;

  const SongPlayerScreen({
    super.key,
    required this.songList,
    required this.initialIndex,
  });

  @override
  State<SongPlayerScreen> createState() => _SongPlayerScreenState();
}

class _SongPlayerScreenState extends State<SongPlayerScreen>
    with SingleTickerProviderStateMixin {
  late AudioPlayerService audioPlayerService;
  final FavoriteSongService _favoriteSongService = FavoriteSongService();
  bool isError = false;
  bool isLiked = false;
  late AnimationController animationController;
  int currentSongIndex = 0;

  @override
  void initState() {
    super.initState();
    audioPlayerService = AudioPlayerService();
    audioPlayerService.currentIndex = widget.initialIndex;
    currentSongIndex = widget.initialIndex;

    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _initializePlayer();
  }

  Future<void> _checkFavoriteStatus() async {
    final currentSong = widget.songList[currentSongIndex];
    final isFavorite = await _favoriteSongService.isSongFavorite(currentSong);
    if (mounted) {
      setState(() {
        isLiked = isFavorite;
      });
    }
  }

  Future<void> _initializePlayer() async {
    try {
      await audioPlayerService.initPlayer(
        widget.songList[audioPlayerService.currentIndex],
      );

      // First check the favorite status of the initial song
      await _checkFavoriteStatus();

      // Listen to position updates
      audioPlayerService.positionStream.listen((pos) {
        if (mounted) {
          setState(() {
            audioPlayerService.position = pos;
            animationController.forward();
          });
        }
      });

      // Listen to player state changes
      audioPlayerService.playerStateStream.listen((state) {
        if (mounted) {
          setState(() {
            audioPlayerService.isPlaying = state.playing;
          });
        }
      });
    } catch (e) {
      if (mounted) {
        setState(() {
          isError = true;
        });
      }
    }
  }

  @override
  void dispose() {
    animationController.dispose();
    audioPlayerService.dispose();
    super.dispose();
  }

  Future<void> _toggleLike() async {
    final currentSong = widget.songList[currentSongIndex];
    final success = await _favoriteSongService.toggleFavorite(currentSong);

    if (success && mounted) {
      setState(() => isLiked = !isLiked);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isLiked ? 'Added to favorites' : 'Removed from favorites',
          ),
          behavior: SnackBarBehavior.floating,
          backgroundColor: isLiked ? Colors.pinkAccent : Colors.blueGrey,
        ),
      );
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to update favorites'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isError) {
      return _buildErrorScreen();
    }

    final currentSong = widget.songList[audioPlayerService.currentIndex];

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.black.withOpacity(0.8), const Color(0xFF1A2A44)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              PlayerAppBar(currentSong: currentSong),
              SongThumbnail(currentSong: currentSong),
              SongInfoWidget(currentSong: currentSong),
              PlayerControlsWidget(
                audioPlayerService: audioPlayerService,
                songList: widget.songList,
                currentSong: currentSong,
                isLiked: isLiked,
                onLikePressed: _toggleLike,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildErrorScreen() {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF121212), Color(0xFF1A1A1A)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, size: 60, color: Colors.white60),
              const SizedBox(height: 16),
              const Text(
                'Failed to load audio',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              const SizedBox(height: 24),
              TextButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                label: const Text(
                  'Go Back',
                  style: TextStyle(color: Colors.white),
                ),
                style: TextButton.styleFrom(
                  backgroundColor: Colors.white.withOpacity(0.1),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
