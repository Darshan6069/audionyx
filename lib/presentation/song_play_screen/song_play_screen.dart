import 'package:audionyx/presentation/song_play_screen/widget/player_error_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'lyircs_widget/lyrics_modal_sheet.dart';
import 'package:audionyx/domain/song_model/song_model.dart';
import 'package:audionyx/presentation/song_play_screen/widget/player_app_bar.dart';
import 'package:audionyx/presentation/song_play_screen/widget/player_control_widget.dart';
import 'package:audionyx/presentation/song_play_screen/widget/song_info_widget.dart';
import 'package:audionyx/presentation/song_play_screen/widget/song_thumbnail.dart';
import 'package:audionyx/repository/service/song_service/favorite_song_service/favorite_song_service.dart';
import '../../repository/bloc/audio_player_bloc_cubit/audio_player_bloc_cubit.dart';
import '../../repository/bloc/audio_player_bloc_cubit/audio_player_state.dart';

class SongPlayerScreen extends StatefulWidget {
  final List<SongData> songList;
  final int initialIndex;

  const SongPlayerScreen({super.key, required this.songList, required this.initialIndex});

  @override
  State<SongPlayerScreen> createState() => _SongPlayerScreenState();
}

class _SongPlayerScreenState extends State<SongPlayerScreen> with SingleTickerProviderStateMixin {
  final FavoriteSongService _favoriteSongService = FavoriteSongService();
  bool isLiked = false;
  late AnimationController animationController;
  SongData? _lastCheckedSong;
  bool _isLyricsModalOpen = false;
  DraggableScrollableController? _draggableScrollableController;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _draggableScrollableController = DraggableScrollableController();

    context.read<AudioPlayerBlocCubit>().loadAndPlay(
      widget.songList[widget.initialIndex],
      widget.songList,
      widget.initialIndex,
    );
  }

  Future<void> _checkFavoriteStatus(SongData? currentSong) async {
    if (currentSong == null || !mounted) return;
    if (_lastCheckedSong == currentSong) return;

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
    if (currentSong == null) return;

    final success = await _favoriteSongService.toggleFavorite(currentSong);
    if (success && mounted) {
      setState(() {
        isLiked = !isLiked;
        _lastCheckedSong = currentSong;
      });
      _showSnackbar(
        isLiked ? 'Added to favorites' : 'Removed from favorites',
        color: isLiked ? Colors.pinkAccent : Colors.blueGrey,
      );
    } else if (mounted) {
      _showSnackbar('Failed to update favorites', color: Colors.redAccent);
    }
  }

  void _showSnackbar(String message, {required Color color}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), behavior: SnackBarBehavior.floating, backgroundColor: color),
    );
  }

  @override
  void dispose() {
    animationController.dispose();
    _draggableScrollableController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AudioPlayerBlocCubit, AudioPlayerState>(
      listener: (context, state) {
        if (state.position != Duration.zero && state.isPlaying) {
          animationController.forward();
        } else {
          animationController.reverse();
        }
        if (state.currentSong != _lastCheckedSong) {
          _checkFavoriteStatus(state.currentSong);
        }
        if (state.showLyrics && !_isLyricsModalOpen && state.lyrics.isNotEmpty) {
          setState(() => _isLyricsModalOpen = true);
          showLyricsModal(
            context: context,
            state: state,
            controller: _draggableScrollableController,
            onClosed: () {
              if (mounted) {
                context.read<AudioPlayerBlocCubit>().toggleLyrics();
                setState(() => _isLyricsModalOpen = false);
              }
            },
          );
        } else if (state.showLyrics && state.lyrics.isEmpty) {
          context.read<AudioPlayerBlocCubit>().toggleLyrics();
          _showSnackbar('No lyrics available for this song', color: Colors.redAccent);
        }
      },
      builder: (context, state) {
        if (state.isLoading) {
          return _buildLoadingScreen(context);
        }
        if (state.hasError || state.currentSong == null) {
          return PlayerErrorScreen(
            onRetry:
                () => context.read<AudioPlayerBlocCubit>().loadAndPlay(
                  widget.songList[widget.initialIndex],
                  widget.songList,
                  widget.initialIndex,
                ),
            onGoBack: () => Navigator.of(context).pop(),
            errorMessage:
                state.hasError ? 'Failed to load audio. Please try again.' : 'No song selected.',
          );
        }
        final currentSong = state.currentSong!;
        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).colorScheme.primary.withOpacity(0.8),
                  Theme.of(context).colorScheme.surface,
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

  Widget _buildLoadingScreen(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.black.withOpacity(0.8), const Color(0xFF1A2A44)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
