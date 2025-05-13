import 'package:audionyx/core/constants/extension.dart';
import 'package:audionyx/domain/song_model/song_model.dart';
import 'package:audionyx/presentation/song_play_screen/widget/player_app_bar.dart';
import 'package:audionyx/presentation/song_play_screen/widget/player_control_widget.dart';
import 'package:audionyx/presentation/song_play_screen/widget/song_info_widget.dart';
import 'package:audionyx/presentation/song_play_screen/widget/song_thumbnail.dart';
import 'package:audionyx/repository/service/song_service/favorite_song_service/favorite_song_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repository/bloc/audio_player_bloc_cubit/audio_player_bloc_cubit.dart';
import '../../repository/bloc/audio_player_bloc_cubit/audio_player_state.dart';

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
  final FavoriteSongService _favoriteSongService = FavoriteSongService();
  bool isLiked = false;
  late AnimationController animationController;
  SongData? _lastCheckedSong;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    // Initialize player via cubit
    print('Initializing player with song index: ${widget.initialIndex}');
    context.read<AudioPlayerBlocCubit>().loadAndPlay(
      widget.songList[widget.initialIndex],
      widget.songList,
      widget.initialIndex,
    );
  }

  Future<void> _checkFavoriteStatus(SongData? currentSong) async {
    if (currentSong == null || !mounted) {
      print('Skipping favorite check: song is null or widget unmounted');
      return;
    }

    if (_lastCheckedSong == currentSong) {
      print('Favorite status already checked for song: ${currentSong.id}');
      return;
    }

    print('Checking favorite status for song: ${currentSong.id}');
    final isFavorite = await _favoriteSongService.isSongFavorite(currentSong);
    if (mounted) {
      setState(() {
        isLiked = isFavorite;
        _lastCheckedSong = currentSong;
      });
    }
  }

  Future<void> _toggleLike() async {
    final cubit = context.read<AudioPlayerBlocCubit>();
    final currentSong = cubit.state.currentSong;
    if (currentSong == null) {
      print('Cannot toggle favorite: no current song');
      return;
    }

    print('Toggling favorite for song: ${currentSong.id}');
    final success = await _favoriteSongService.toggleFavorite(currentSong);
    if (success && mounted) {
      setState(() {
        isLiked = !isLiked;
        _lastCheckedSong = currentSong;
      });
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
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AudioPlayerBlocCubit, AudioPlayerState>(
      listener: (context, state) {
        print(
          'AudioPlayerState: isLoading=${state.isLoading}, currentSong=${state.currentSong?.id}, '
          'hasError=${state.hasError}, isPlaying=${state.isPlaying}, position=${state.position}',
        );
        if (state.position != Duration.zero && state.isPlaying) {
          animationController.forward();
        } else {
          animationController.reverse();
        }
        if (state.currentSong != _lastCheckedSong) {
          _checkFavoriteStatus(state.currentSong);
        }
      },
      builder: (context, state) {
        if (state.isLoading) {
          return Scaffold(
            body: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withOpacity(0.8),
                    const Color(0xFF1A2A44),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: const Center(child: CircularProgressIndicator()),
            ),
          );
        }

        if (state.hasError || state.currentSong == null) {
          return _buildErrorScreen(state);
        }

        final currentSong = state.currentSong!;

        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor, // Use theme background
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).colorScheme.primary.withOpacity(0.8), // Use primary color
                  Theme.of(context).colorScheme.surface, // Use background color
                ],
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
                    audioPlayerService: context.read<AudioPlayerBlocCubit>().service,
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
      },
    );
  }

  Widget _buildErrorScreen(AudioPlayerState state) {
    final errorMessage =
        state.hasError
            ? 'Failed to load audio. Please try again.'
            : 'No song selected.';
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
              Text(
                errorMessage,
                style: const TextStyle(color: Colors.white, fontSize: 18),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              TextButton.icon(
                onPressed: () {
                  print('Retrying playback for index: ${widget.initialIndex}');
                  context.read<AudioPlayerBlocCubit>().loadAndPlay(
                    widget.songList[widget.initialIndex],
                    widget.songList,
                    widget.initialIndex,
                  );
                },
                icon: const Icon(Icons.refresh, color: Colors.white),
                label: const Text(
                  'Retry',
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
              const SizedBox(height: 8),
              TextButton.icon(
                onPressed: () {
                  print('Navigating back from error screen');
                  context.pop(context);
                },
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
