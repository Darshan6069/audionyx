import 'package:audionyx/repository/service/song_service/audio_service/audio_service.dart';
import 'package:flutter/material.dart';

class ProgressSliderWidget extends StatefulWidget {
  final AudioPlayerService audioPlayerService;

  const ProgressSliderWidget({super.key, required this.audioPlayerService});

  @override
  State<ProgressSliderWidget> createState() => _ProgressSliderWidgetState();
}

class _ProgressSliderWidgetState extends State<ProgressSliderWidget> {
  double _sliderValue = 0.0;
  bool _isUserSeeking = false;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Duration>(
      stream: widget.audioPlayerService.positionStream,
      builder: (context, snapshot) {
        // Get current position and duration
        final position = snapshot.data ?? widget.audioPlayerService.position;
        final duration = widget.audioPlayerService.duration;

        // Calculate slider value (0.0 to 1.0)
        final maxValue = duration.inMilliseconds.toDouble();
        final currentValue =
            _isUserSeeking ? _sliderValue : position.inMilliseconds.toDouble().clamp(0.0, maxValue);

        // Format duration and position for display
        final positionText = _formatDuration(position);
        final durationText = _formatDuration(duration);

        return Column(
          children: [
            Slider(
              value: currentValue,
              min: 0.0,
              max: maxValue > 0 ? maxValue : 1.0, // Avoid division by zero
              activeColor: Colors.greenAccent,
              inactiveColor: Colors.white.withOpacity(0.3),
              onChanged: (value) {
                setState(() {
                  _isUserSeeking = true;
                  _sliderValue = value;
                });
              },
              onChangeEnd: (value) {
                // Seek to the new position when the user releases the slider
                widget.audioPlayerService.seekTo(Duration(milliseconds: value.toInt()));
                setState(() {
                  _isUserSeeking = false;
                });
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    positionText,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                    ),
                  ),
                  Text(
                    durationText,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes.toString().padLeft(2, '0');
    final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }
}
