import 'package:audionyx/repository/service/song_service/audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

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
    // Responsive values
    final isTablet = ResponsiveBreakpoints.of(context).isTablet;
    final isDesktop = ResponsiveBreakpoints.of(context).isDesktop;
    final sliderHeight =
        isDesktop
            ? 8.0
            : isTablet
            ? 6.0
            : 3.0; // Thinner for mobile
    final fontSize =
        isDesktop
            ? 18.0
            : isTablet
            ? 15.0
            : 11.0; // Smaller for mobile
    final paddingH =
        isDesktop
            ? 24.0
            : isTablet
            ? 16.0
            : 4.0; // Minimal for mobile

    return StreamBuilder<Duration>(
      stream: widget.audioPlayerService.positionStream,
      builder: (context, snapshot) {
        final position = snapshot.data ?? widget.audioPlayerService.position;
        final duration = widget.audioPlayerService.duration;

        final maxValue = duration.inMilliseconds.toDouble();
        final currentValue =
            _isUserSeeking ? _sliderValue : position.inMilliseconds.toDouble().clamp(0.0, maxValue);

        final positionText = _formatDuration(position);
        final durationText = _formatDuration(duration);

        return Column(
          children: [
            SliderTheme(
              data: SliderTheme.of(context).copyWith(
                trackHeight: sliderHeight,
                thumbShape: RoundSliderThumbShape(enabledThumbRadius: sliderHeight * 1.5),
                overlayShape: RoundSliderOverlayShape(overlayRadius: sliderHeight * 2.5),
              ),
              child: Slider(
                value: currentValue,
                min: 0.0,
                max: maxValue > 0 ? maxValue : 1.0,
                activeColor: Colors.greenAccent,
                inactiveColor: Colors.white.withOpacity(0.3),
                onChanged: (value) {
                  setState(() {
                    _isUserSeeking = true;
                    _sliderValue = value;
                  });
                },
                onChangeEnd: (value) {
                  widget.audioPlayerService.seekTo(Duration(milliseconds: value.toInt()));
                  setState(() {
                    _isUserSeeking = false;
                  });
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: paddingH),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    positionText,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontSize: fontSize,
                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                    ),
                  ),
                  Text(
                    durationText,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontSize: fontSize,
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
