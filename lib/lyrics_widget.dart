import 'package:audionyx/lyrics_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repository/bloc/audio_player_bloc_cubit/audio_player_bloc_cubit.dart';
import '../../repository/bloc/audio_player_bloc_cubit/audio_player_state.dart';

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

class _LyricsWidgetState extends State<LyricsWidget> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.lyrics.isEmpty) {
      return const Center(
        child: Text(
          'No lyrics available',
          style: TextStyle(color: Colors.white70, fontSize: 16),
        ),
      );
    }

    return BlocBuilder<AudioPlayerBlocCubit, AudioPlayerState>(
      buildWhen: (previous, current) => previous.position != current.position,
      builder: (context, state) {
        int currentIndex = -1;
        for (int i = 0; i < widget.lyrics.length; i++) {
          if (state.position >= widget.lyrics[i].startTime &&
              state.position < widget.lyrics[i].endTime) {
            currentIndex = i;
            break;
          }
        }

        // Auto-scroll to current lyric
        if (currentIndex != -1) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (_scrollController.hasClients) {
              final offset = currentIndex * 48.0; // Approximate height per lyric
              _scrollController.animateTo(
                offset.clamp(0.0, _scrollController.position.maxScrollExtent),
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOut,
              );
            }
          });
        }

        return ListView.builder(
          controller: _scrollController,
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          itemCount: widget.lyrics.length,
          itemBuilder: (context, index) {
            final lyric = widget.lyrics[index];
            final isCurrent = index == currentIndex;
            return GestureDetector(
              onTap: () {
                print('Tapped lyric at index $index: ${lyric.text}');
                widget.onLyricTap(lyric.startTime);
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  lyric.text,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: isCurrent ? Colors.white : Colors.white70,
                    fontSize: isCurrent ? 20 : 16,
                    fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}