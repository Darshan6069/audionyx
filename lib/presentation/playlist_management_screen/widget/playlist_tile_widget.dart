import 'package:audionyx/core/constants/theme_color.dart';
import 'package:flutter/material.dart';

class PlaylistTileWidget extends StatelessWidget {
  final String title;
  final String playlistId;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const PlaylistTileWidget({
    super.key,
    required this.title,
    required this.playlistId,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        color: ThemeColor.darGreyColor,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: ThemeColor.grey.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.queue_music,
                    size: 30,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      color: ThemeColor.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: ThemeColor.grey),
                  onPressed: onDelete,
                  tooltip: 'Delete Playlist',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}