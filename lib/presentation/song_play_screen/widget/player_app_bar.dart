import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/song_model/song_model.dart';
import '../../../repository/bloc/download_song_bloc_cubit/download_song_bloc_cubit.dart';
import '../../../repository/bloc/download_song_bloc_cubit/download_song_state.dart';
import '../../../repository/bloc/theme_cubit/theme_cubit.dart';

class PlayerAppBar extends StatelessWidget {
  final SongData currentSong;

  const PlayerAppBar({super.key, required this.currentSong});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          const Text(
            'Now Playing',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Row(
            children: [
              BlocProvider(
                create: (context) => DownloadSongBlocCubit(),
                child: BlocConsumer<DownloadSongBlocCubit, DownloadSongState>(
                  listener: (context, state) {
                    if (state is DownloadSongSuccess) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Song downloaded successfully!'),
                          behavior: SnackBarBehavior.floating,
                          backgroundColor: Colors.green,
                        ),
                      );
                    } else if (state is DownloadSongFailure) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Download failed: ${state.error}'),
                          behavior: SnackBarBehavior.floating,
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  builder: (context, state) {
                    if (state is DownloadSongDownloading) {
                      return const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        ),
                      );
                    }
                    return IconButton(
                      icon: const Icon(Icons.download, color: Colors.white70),
                      onPressed: () {
                        final url = currentSong.mp3Url;
                        if (url.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Download URL is not available'),
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
                ),
                onPressed: () {
                  context.read<ThemeCubit>().toggleTheme();
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
