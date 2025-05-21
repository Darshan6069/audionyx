import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_framework/responsive_framework.dart';
import '../../../domain/song_model/song_model.dart';
import '../../../repository/bloc/download_song_bloc_cubit/download_song_bloc_cubit.dart';
import '../../../repository/bloc/download_song_bloc_cubit/download_song_state.dart';
import '../../../repository/bloc/theme_cubit/theme_cubit.dart';

class PlayerAppBar extends StatelessWidget {
  final SongData currentSong;

  const PlayerAppBar({super.key, required this.currentSong});

  @override
  Widget build(BuildContext context) {
    // Responsive values
    final isTablet = ResponsiveBreakpoints.of(context).isTablet;
    final isDesktop = ResponsiveBreakpoints.of(context).isDesktop;
    final iconSize =
        isDesktop
            ? 36.0
            : isTablet
            ? 30.0
            : 22.0; // Smaller for mobile
    final fontSize =
        isDesktop
            ? 28.0
            : isTablet
            ? 24.0
            : 16.0; // Smaller for mobile
    final paddingH =
        isDesktop
            ? 32.0
            : isTablet
            ? 20.0
            : 10.0;
    final paddingV =
        isDesktop
            ? 16.0
            : isTablet
            ? 12.0
            : 6.0;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: paddingH, vertical: paddingV),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back_ios, color: Colors.white, size: iconSize),
            onPressed: () => Navigator.pop(context),
            splashRadius: iconSize * 0.8,
            padding: EdgeInsets.zero, // Remove default padding
          ),
          Expanded(
            child: Text(
              'Now Playing',
              style: TextStyle(
                color: Colors.white,
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              BlocProvider(
                create: (context) => DownloadSongBlocCubit(),
                child: BlocConsumer<DownloadSongBlocCubit, DownloadSongState>(
                  listener: (context, state) {
                    if (state is DownloadSongSuccess) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Song downloaded successfully!'),
                          behavior: SnackBarBehavior.floating,
                          backgroundColor: Colors.green,
                          margin: EdgeInsets.all(paddingH),
                          padding: EdgeInsets.symmetric(horizontal: paddingH, vertical: 8.0),
                        ),
                      );
                    } else if (state is DownloadSongFailure) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Download failed: ${state.error}'),
                          behavior: SnackBarBehavior.floating,
                          backgroundColor: Colors.red,
                          margin: EdgeInsets.all(paddingH),
                          padding: EdgeInsets.symmetric(horizontal: paddingH, vertical: 8.0),
                        ),
                      );
                    }
                  },
                  builder: (context, state) {
                    if (state is DownloadSongDownloading) {
                      return SizedBox(
                        width: iconSize,
                        height: iconSize,
                        child: CircularProgressIndicator(
                          strokeWidth:
                              isDesktop
                                  ? 3.0
                                  : isTablet
                                  ? 2.5
                                  : 2.0,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      );
                    }
                    return IconButton(
                      icon: Icon(Icons.download, color: Colors.white70, size: iconSize),
                      onPressed: () {
                        final url = currentSong.mp3Url;
                        if (url.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Download URL is not available'),
                              margin: EdgeInsets.all(paddingH),
                              padding: EdgeInsets.symmetric(horizontal: paddingH, vertical: 8.0),
                            ),
                          );
                          return;
                        }
                        context.read<DownloadSongBlocCubit>().downloadSong(
                          url: url,
                          fileName: '${currentSong.title}.mp3',
                          thumbnailUrl: currentSong.thumbnailUrl,
                          songData: currentSong,
                          context: context,
                        );
                      },
                      splashRadius: iconSize * 0.8,
                      padding: EdgeInsets.zero,
                    );
                  },
                ),
              ),
              IconButton(
                icon: Icon(
                  Theme.of(context).brightness == Brightness.dark
                      ? Icons.light_mode
                      : Icons.dark_mode,
                  color: Colors.white70,
                  size: iconSize,
                ),
                onPressed: () => context.read<ThemeCubit>().toggleTheme(),
                splashRadius: iconSize * 0.8,
                padding: EdgeInsets.zero,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
