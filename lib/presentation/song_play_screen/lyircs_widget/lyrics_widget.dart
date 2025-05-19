import 'package:audionyx/domain/lyrics_model/lyrics_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../repository/bloc/audio_player_bloc_cubit/audio_player_bloc_cubit.dart';
import '../../../../../repository/bloc/audio_player_bloc_cubit/audio_player_state.dart';
import 'lyrcs_focused_view.dart';
import 'lyrics_all_view.dart';
import 'lyrics_empty_view.dart';


class LyricsWidget extends StatefulWidget {
  final List<Lyric> lyrics;
  final Function(Duration) onLyricTap;

  const LyricsWidget({
    super.key,
    required this.lyrics,
    required this.onLyricTap,
  });

  @override
  State<LyricsWidget> createState() => _LyricsWidgetState();
}

class _LyricsWidgetState extends State<LyricsWidget>
    with SingleTickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  int _previousIndex = -1;
  bool _showAllLyrics = false;

  late AnimationController _animationController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.08).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  int _getCurrentLyricIndex(Duration position) {
    for (int i = 0; i < widget.lyrics.length; i++) {
      if (position >= widget.lyrics[i].startTime &&
          (i == widget.lyrics.length - 1 ||
              position < widget.lyrics[i + 1].startTime)) {
        return i;
      }
    }
    return -1;
  }

  void _scrollToCurrentLyric(int currentIndex) {
    if (currentIndex != -1 &&
        currentIndex != _previousIndex &&
        !_showAllLyrics) {
      _previousIndex = currentIndex;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scrollController.hasClients) {
          final viewportHeight = _scrollController.position.viewportDimension;
          final itemHeight = 60.0;
          final offset =
              (currentIndex * itemHeight) -
                  (viewportHeight / 2) +
                  (itemHeight / 2);

          _scrollController.animateTo(
            offset.clamp(0.0, _scrollController.position.maxScrollExtent),
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeOutCubic,
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.lyrics.isEmpty) {
      return const LyricsEmptyView();
    }

    return BlocBuilder<AudioPlayerBlocCubit, AudioPlayerState>(
      buildWhen: (previous, current) => previous.position != current.position,
      builder: (context, state) {
        final currentIndex = _getCurrentLyricIndex(state.position);
        _scrollToCurrentLyric(currentIndex);

        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.black.withOpacity(0.8), Colors.black],
            ),
          ),
          child: NotificationListener<OverscrollIndicatorNotification>(
            onNotification: (overscroll) {
              overscroll.disallowIndicator();
              return true;
            },
            child: currentIndex != -1 && !_showAllLyrics
                ? LyricsFocusedView(
              lyrics: widget.lyrics,
              currentIndex: currentIndex,
              position: state.position,
              pulseAnimation: _pulseAnimation,
              animationController: _animationController,
              formatDuration: _formatDuration,
              onLyricTap: widget.onLyricTap,
              showAllLyricsCallback: () =>
                  setState(() => _showAllLyrics = true),
            )
                : LyricsAllView(
              lyrics: widget.lyrics,
              currentIndex: currentIndex,
              scrollController: _scrollController,
              onLyricTap: (duration, index) {
                widget.onLyricTap(duration);
                setState(() {
                  _previousIndex = index;
                  _showAllLyrics = false;
                });
              },
              backToFocusedView: () =>
                  setState(() => _showAllLyrics = false),
            ),
          ),
        );
      },
    );
  }
}