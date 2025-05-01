import 'package:flutter/material.dart';

class Song {
  final String title;
  final String artist;
  Song({required this.title, required this.artist});
}

class MiniPlayerWidget extends StatelessWidget {
  final Song? currentSong = Song(title: 'Sample Song', artist: 'Sample Artist'); // Placeholder
  final bool isPlaying = false; // Placeholder

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isLargeScreen = screenWidth > 600;

    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      height: currentSong != null ? (isLargeScreen ? 80 : 60) : 0,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: currentSong != null
          ? InkWell(
        onTap: () {
          Navigator.pushNamed(context, '/player'); // Assumes PlayerScreen route
        },
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: isLargeScreen ? 24 : 16),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      currentSong!.title,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: isLargeScreen ? 16 : 14,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4),
                    Text(
                      currentSong!.artist,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontSize: isLargeScreen ? 14 : 12,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(
                  isPlaying ? Icons.pause : Icons.play_arrow,
                  size: isLargeScreen ? 32 : 24,
                  color: Colors.blue,
                ),
                onPressed: () {}, // Placeholder for play/pause action
              ),
            ],
          ),
        ),
      )
          : SizedBox.shrink(),
    );
  }
}