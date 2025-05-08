import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:audionyx/core/constants/theme_color.dart';
import 'package:audionyx/domain/song_model/song_model.dart';
import 'package:audionyx/repository/service/song_service/song_browser_service/song_browser_service.dart';

class SongTile extends StatelessWidget {
  final SongData song;
  final int index;
  final List<SongData> songs;
  final SongBrowserService service;

  const SongTile({
    super.key,
    required this.song,
    required this.index,
    required this.songs,
    required this.service,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => service.playSong(context, song, index, songs),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: CachedNetworkImage(
                imageUrl: song.thumbnailUrl,
                width: 60,
                height: 60,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  width: 60,
                  height: 60,
                  color: ThemeColor.darGreyColor,
                  child: const Center(
                    child: CircularProgressIndicator(
                      color: ThemeColor.greenAccent,
                      strokeWidth: 2,
                    ),
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  width: 60,
                  height: 60,
                  color: ThemeColor.darGreyColor,
                  child: const Icon(
                    Icons.music_note,
                    color: ThemeColor.white,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    song.title,
                    style: const TextStyle(
                      color: ThemeColor.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${song.artist} • ${song.album}',
                    style: const TextStyle(
                      color: ThemeColor.grey,
                      fontSize: 14,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            _buildPopupMenu(context),
          ],
        ),
      ),
    );
  }

  Widget _buildPopupMenu(BuildContext context) {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.more_vert, color: ThemeColor.white),
      color: ThemeColor.darGreyColor,
      onSelected: (value) {
        switch (value) {
          case 'play':
            service.playSong(context, song, index, songs);
            break;
          case 'add_to_playlist':
          // TODO: Implement add to playlist
            break;
          case 'download':
          // TODO: Implement download
            break;
        }
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        const PopupMenuItem<String>(
          value: 'play',
          child: Row(
            children: [
              Icon(Icons.play_arrow, color: ThemeColor.white, size: 20),
              SizedBox(width: 8),
              Text('Play', style: TextStyle(color: ThemeColor.white)),
            ],
          ),
        ),
        const PopupMenuItem<String>(
          value: 'add_to_playlist',
          child: Row(
            children: [
              Icon(Icons.playlist_add, color: ThemeColor.white, size: 20),
              SizedBox(width: 8),
              Text('Add to Playlist', style: TextStyle(color: ThemeColor.white)),
            ],
          ),
        ),
        const PopupMenuItem<String>(
          value: 'download',
          child: Row(
            children: [
              Icon(Icons.download, color: ThemeColor.white, size: 20),
              SizedBox(width: 8),
              Text('Download', style: TextStyle(color: ThemeColor.white)),
            ],
          ),
        ),
      ],
    );
  }
}