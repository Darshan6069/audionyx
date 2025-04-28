import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../core/constants/theme_color.dart';
import '../../domain/song_model/song_model.dart';
import '../../playlist_screen.dart';
import '../../repository/service/song_service/download_song/download_song.dart';
import '../../repository/service/song_service/recently_play_song/recently_played_manager.dart';
import '../../song_play_screen.dart';

class CommonSongCard extends StatefulWidget {
  final List<SongData> song;
  final int index;

  const CommonSongCard({
    required this.song,
    super.key, required this.index,
  });

  @override
  State<CommonSongCard> createState() => _CommonSongCardState();
}


class _CommonSongCardState extends State<CommonSongCard> {
  List<SongData> recentlyPlayed = [];



  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: CachedNetworkImage(
              imageUrl: widget.song[widget.index].thumbnailUrl,
              width: 150,
              height: 150,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                color: ThemeColor.grey,
                width: 150,
                height: 150,
                child: const Center(child: CircularProgressIndicator()),
              ),
              errorWidget: (context, url, error) => Container(
                width: 150,
                height: 150,
                color: ThemeColor.grey,
                child: const Icon(Icons.music_note, color: ThemeColor.white),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            widget.song[widget.index].title,
            style: const TextStyle(
              color: ThemeColor.white,
              fontWeight: FontWeight.bold,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            widget.song[widget.index].artist,
            style: const TextStyle(color: ThemeColor.grey, fontSize: 12),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.play_arrow, color: ThemeColor.white),
                  onPressed: () async {
                    await RecentlyPlayedManager.addSongToRecentlyPlayed(widget.song[widget.index]);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SongPlayerScreen(
                          songList: widget.song,
                          initialIndex: widget.index,
                        ),
                      ),
                    );
                  },
              ),
              IconButton(
                icon: const Icon(Icons.download, color: ThemeColor.white),
                onPressed: () async {
                  final safeFileName = '${widget.song[widget.index].title.replaceAll(RegExp(r'[^\w\s-]'), '_')}.mp3';
                  await DownloadSong().downloadSong(
                    widget.song[widget.index].path,
                    safeFileName,
                    widget.song[widget.index].thumbnailUrl,
                    widget.song[widget.index],
                    context,
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.add_to_queue, color: ThemeColor.white),
                onPressed: () => PlaylistsScreen(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
