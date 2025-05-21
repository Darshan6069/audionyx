import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final isTablet = ResponsiveBreakpoints.of(context).isTablet;
    final isDesktop = ResponsiveBreakpoints.of(context).isDesktop;

    // Responsive padding and sizes similar to home_screen.dart
    final tilePadding =
        isDesktop
            ? const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0)
            : isTablet
            ? const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0)
            : const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0);
    final avatarRadius =
        isDesktop
            ? 24.0
            : isTablet
            ? 20.0
            : 16.0;
    final titleFontSize =
        isDesktop
            ? 18.0
            : isTablet
            ? 16.0
            : 14.0;
    final dialogPadding =
        isDesktop
            ? 40.0
            : isTablet
            ? 32.0
            : 20.0;

    return Card(
      color: colorScheme.surface,
      elevation: 2,
      margin: EdgeInsets.symmetric(
        vertical:
            isDesktop
                ? 12.0
                : isTablet
                ? 10.0
                : 8.0,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: tilePadding,
        title: Text(
          title,
          style: textTheme.bodyLarge?.copyWith(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.w600,
            fontSize: titleFontSize,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        leading: CircleAvatar(
          backgroundColor: colorScheme.primary.withOpacity(0.2),
          radius: avatarRadius,
          child: Icon(Icons.queue_music, color: colorScheme.primary, size: avatarRadius * 1.2),
        ),
        trailing: IconButton(
          icon: Icon(Icons.delete_outline, color: colorScheme.error, size: avatarRadius * 1.2),
          onPressed: () {
            showDialog(
              context: context,
              builder:
                  (dialogContext) => AlertDialog(
                    backgroundColor: theme.scaffoldBackgroundColor,
                    title: Text(
                      'Delete Playlist',
                      style: textTheme.titleMedium?.copyWith(
                        color: colorScheme.onSurface,
                        fontSize: titleFontSize + 2,
                      ),
                    ),
                    content: Text(
                      'Are you sure you want to delete the playlist "$title"?',
                      style: textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurface.withOpacity(0.7),
                        fontSize: isDesktop ? 16.0 : 14.0,
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(dialogContext),
                        child: Text(
                          'Cancel',
                          style: TextStyle(
                            color: colorScheme.onSurface,
                            fontSize: isDesktop ? 16.0 : 14.0,
                          ),
                        ),
                        style: TextButton.styleFrom(padding: tilePadding),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(dialogContext);
                          onDelete();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: colorScheme.error,
                          foregroundColor: colorScheme.onError,
                          padding: tilePadding,
                        ),
                        child: Text('Delete', style: TextStyle(fontSize: isDesktop ? 16.0 : 14.0)),
                      ),
                    ],
                    contentPadding: EdgeInsets.all(dialogPadding),
                    insetPadding: EdgeInsets.symmetric(horizontal: dialogPadding, vertical: 24.0),
                  ),
            );
          },
        ),
        onTap: onTap,
      ),
    );
  }
}
