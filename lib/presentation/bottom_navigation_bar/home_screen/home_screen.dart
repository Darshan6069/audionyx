import 'package:audionyx/core/constants/app_image.dart';
import 'package:audionyx/core/constants/app_strings.dart';
import 'package:audionyx/core/constants/extension.dart';
import 'package:audionyx/core/constants/theme_color.dart';
import 'package:audionyx/presentation/download_song_screen/download_song_screen.dart';
import 'package:audionyx/presentation/playlist_management_screen/playlist_management_screen.dart';
import 'package:audionyx/presentation/widget/common_song_card.dart';
import 'package:audionyx/repository/bloc/auth_bloc_cubit/login_bloc_cubit/login_bloc_cubit.dart';
import 'package:audionyx/repository/bloc/fetch_song_bloc_cubit/fetch_song_bloc_cubit.dart';
import 'package:audionyx/repository/bloc/fetch_song_bloc_cubit/fetch_song_state.dart';
import 'package:audionyx/presentation/bottom_navigation_bar/search_screen/song_browser_screen.dart';
import 'package:audionyx/user_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/song_model/song_model.dart';
import '../../../repository/service/song_service/recently_play_song/recently_played_manager.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<SongData> featuredPlaylists = [];
  List<SongData> recentlyPlayed = [];
  bool isLoadingPlaylists = false;
  String? playlistErrorMessage;

  @override
  void initState() {
    super.initState();
    context.read<FetchSongBlocCubit>().fetchSongs();
    RecentlyPlayedManager.loadRecentlyPlayed().then((song) {
      setState(() {
        recentlyPlayed = song;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColor.darkBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset(
                    AppImage.logo,
                    height: 40,
                    color: ThemeColor.white,
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.search, color: ThemeColor.white),
                        onPressed:
                            () => context.push(
                              context,
                              target: const SongBrowserScreen(),
                            ),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.library_music_rounded,
                          color: ThemeColor.white,
                        ),
                        onPressed:
                            () => context.push(
                              context,
                              target: const DownloadedSongsScreen(),
                            ),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.queue_music,
                          color: ThemeColor.white,
                        ),
                        onPressed:
                            () => context.push(
                              context,
                              target: const PlaylistManagementScreen(),
                            ),
                      ),
                      BlocProvider(
                        create: (context) => LoginBlocCubit(),
                        child: Builder(
                          builder:
                              (context) => IconButton(
                                icon: const Icon(
                                  Icons.person,
                                  color: ThemeColor.white,
                                  size: 30,
                                ),
                                onPressed: () {
                                  final userId = AppStrings.secureStorage.read(
                                    key: 'userId',
                                  );
                                  context.push(
                                    context,
                                    target: UserProfileScreen(
                                      userId: userId.toString(),
                                    ),
                                  );
                                },
                              ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Text(
                AppStrings.goodMorning,
                style: TextStyle(
                  color: ThemeColor.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Featured Playlists',
                style: TextStyle(
                  color: ThemeColor.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 200,
                child:
                    isLoadingPlaylists
                        ? const Center(
                          child: CircularProgressIndicator(
                            color: ThemeColor.white,
                          ),
                        )
                        : playlistErrorMessage != null
                        ? Center(
                          child: Text(
                            playlistErrorMessage!,
                            style: const TextStyle(color: ThemeColor.white),
                          ),
                        )
                        : featuredPlaylists.isEmpty
                        ? const Center(
                          child: Text(
                            'No playlists found',
                            style: TextStyle(color: ThemeColor.white),
                          ),
                        )
                        : ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: featuredPlaylists.length,
                          itemBuilder:
                              (context, index) => CommonSongCard(
                                song: featuredPlaylists,
                                index: index,
                              ),
                        ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Recently Played',
                style: TextStyle(
                  color: ThemeColor.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 250,
                child:
                    recentlyPlayed.isEmpty
                        ? const Center(
                          child: Text(
                            'No recently played songs',
                            style: TextStyle(color: ThemeColor.white),
                          ),
                        )
                        : ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: 4,
                          itemBuilder:
                              (context, index) => CommonSongCard(
                                song: recentlyPlayed,
                                index: index,
                              ),
                        ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Trending Tracks',
                style: TextStyle(
                  color: ThemeColor.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              BlocBuilder<FetchSongBlocCubit, FetchSongState>(
                builder: (context, state) {
                  return SizedBox(
                    height: 250,
                    child: () {
                      if (state is FetchSongInitial) {
                        return const Center(
                          child: Text(
                            'No songs yet',
                            style: TextStyle(color: ThemeColor.white),
                          ),
                        );
                      } else if (state is FetchSongLoading) {
                        return const Center(
                          child: CircularProgressIndicator(
                            color: ThemeColor.white,
                          ),
                        );
                      } else if (state is FetchSongSuccess) {
                        if (state.songs.isEmpty) {
                          return const Center(
                            child: Text(
                              'No trending tracks available',
                              style: TextStyle(color: ThemeColor.white),
                            ),
                          );
                        }
                        return ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: state.songs.length,
                          itemBuilder: (context, index) {
                            return CommonSongCard(
                              song: state.songs,
                              index: index,
                            );
                          },
                        );
                      } else if (state is FetchSongFailure) {
                        return Center(
                          child: Text(
                            state.error,
                            style: const TextStyle(color: ThemeColor.white),
                          ),
                        );
                      }
                      return const SizedBox();
                    }(),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
