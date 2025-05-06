// mini_player.dart
import 'package:flutter/material.dart';
import 'package:audionyx/domain/song_model/song_model.dart';
import 'package:audionyx/repository/service/song_service/audio_service/audio_service.dart';

class MiniPlayerWidget extends StatelessWidget {
  final SongData currentSong;
  final AudioPlayerService audioPlayerService;
  final VoidCallback onTap;
  final VoidCallback? onStateChanged; // Callback to trigger setState in parent

  const MiniPlayerWidget({
    super.key,
    required this.currentSong,
    required this.audioPlayerService,
    required this.onTap,
    this.onStateChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black87,
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: 70,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  currentSong.thumbnailUrl ?? '',
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const Icon(Icons.music_note, size: 30),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  currentSong.title,
                  style: const TextStyle(color: Colors.white),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              IconButton(
                icon: Icon(
                  audioPlayerService.isPlaying ? Icons.pause : Icons.play_arrow,
                  color: Colors.white,
                ),
                onPressed: () async {
                  audioPlayerService.isPlaying
                      ? await audioPlayerService.pause
                      : await audioPlayerService.play;
                  onStateChanged?.call(); // Notify parent to refresh UI
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}