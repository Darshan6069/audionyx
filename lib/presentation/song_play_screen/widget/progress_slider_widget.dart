import 'package:audionyx/repository/service/song_service/audio_service/audio_service.dart';
import 'package:flutter/material.dart';

class ProgressSliderWidget extends StatelessWidget {
  final AudioPlayerService audioPlayerService;

  const ProgressSliderWidget({
    super.key,
    required this.audioPlayerService,
  });

  String _formatDuration(Duration d) =>
      d.toString().split('.').first.padLeft(8, "0");

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          _formatDuration(audioPlayerService.position),
          style: TextStyle(
            color: Colors.white.withOpacity(0.7),
            fontSize: 12,
          ),
        ),
        Expanded(
          child: SliderTheme(
            data: SliderThemeData(
              trackHeight: 4,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 12),
              activeTrackColor: Colors.greenAccent,
              inactiveTrackColor: Colors.white.withOpacity(0.2),
              thumbColor: Colors.white,
              overlayColor: Colors.greenAccent.withOpacity(0.2),
            ),
            child: Slider(
              value: audioPlayerService.position.inSeconds.toDouble(),
              max: audioPlayerService.duration.inSeconds.clamp(1, 100000).toDouble(),
              onChanged: (value) {
                audioPlayerService.seekTo(Duration(seconds: value.toInt()));
              },
            ),
          ),
        ),
        Text(
          _formatDuration(audioPlayerService.duration),
          style: TextStyle(
            color: Colors.white.withOpacity(0.7),
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}