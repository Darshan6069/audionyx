import 'package:audionyx/core/constants/app_strings.dart';
import 'package:audionyx/presentation/bottom_navigation_bar/home_screen/widget/header.dart';
import 'package:audionyx/presentation/bottom_navigation_bar/home_screen/widget/horizontal_list_view.dart';
import 'package:audionyx/presentation/bottom_navigation_bar/home_screen/widget/section_tile.dart';
import 'package:audionyx/presentation/widget/common_song_card.dart';
import 'package:audionyx/presentation/widget/playlist_card.dart';
import 'package:audionyx/repository/bloc/fetch_song_bloc_cubit/fetch_song_bloc_cubit.dart';
import 'package:audionyx/repository/bloc/fetch_song_bloc_cubit/fetch_song_state.dart';
import 'package:audionyx/repository/bloc/playlist_bloc_cubit/playlist_bloc_cubit.dart';
import 'package:audionyx/repository/bloc/playlist_bloc_cubit/playlist_state.dart';
import 'package:audionyx/repository/service/song_service/recently_play_song/recently_played_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_framework/responsive_framework.dart';
import '../../../domain/song_model/song_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with AutomaticKeepAliveClientMixin {
  List<SongData> recentlyPlayed = [];

  @override
  bool get wantKeepAlive => true; // Keep the state alive when navigating

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Refresh data when returning to this screen
    _loadData();
  }

  // Extract the data loading into a separate method for reuse
  void _loadData() {
    // Fetch songs and playlists
    context.read<FetchSongBlocCubit>().fetchSongs();
    context.read<PlaylistBlocCubit>().fetchPlaylists();

    // Load recently played songs
    RecentlyPlayedManager.loadRecentlyPlayed().then((songs) {
      if (mounted) {
        setState(() {
          recentlyPlayed = songs;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final isTablet = ResponsiveBreakpoints.of(context).isTablet;
    final isDesktop = ResponsiveBreakpoints.of(context).isDesktop;
    final horizontalPadding =
        isDesktop
            ? 80.0
            : isTablet
            ? 40.0
            : 20.0;
    final sectionSpacing = isTablet || isDesktop ? 30.0 : 20.0;
    final playlistHeight = isTablet || isDesktop ? 250.0 : 200.0;
    final songListHeight = isTablet || isDesktop ? 300.0 : 250.0;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async => _loadData(),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: sectionSpacing),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Header(),
                SizedBox(height: sectionSpacing),
                const SectionTitle(AppStrings.goodMorning, fontSize: 24),
                SizedBox(height: sectionSpacing),
                const SectionTitle('Featured Playlists'),
                const SizedBox(height: 10),
                SizedBox(
                  height: playlistHeight,
                  child: BlocBuilder<PlaylistBlocCubit, PlaylistState>(
                    builder: (context, state) {
                      return HorizontalListView(
                        isLoading: state is PlaylistLoading,
                        isFailed: state is PlaylistFailure,
                        errorMessage: state is PlaylistFailure ? state.error : null,
                        items: state is PlaylistSuccess ? state.playlists : [],
                        emptyMessage: 'No playlists found',
                        itemBuilder: (context, item, index) => PlaylistCard(playlist: item),
                        onRetry: () => context.read<PlaylistBlocCubit>().fetchPlaylists(),
                      );
                    },
                  ),
                ),
                const SectionTitle('Recently Played'),
                const SizedBox(height: 10),
                SizedBox(
                  height: songListHeight,
                  child: HorizontalListView(
                    isLoading: false,
                    isFailed: false,
                    items: recentlyPlayed,
                    emptyMessage: 'No recently played songs',
                    itemBuilder:
                        (context, item, index) =>
                            CommonSongCard(song: recentlyPlayed, index: index),
                  ),
                ),
                const SectionTitle('Trending Tracks'),
                const SizedBox(height: 10),
                SizedBox(
                  height: songListHeight,
                  child: BlocBuilder<FetchSongBlocCubit, FetchSongState>(
                    builder: (context, state) {
                      return HorizontalListView(
                        isLoading: state is FetchSongLoading,
                        isFailed: state is FetchSongFailure,
                        errorMessage: state is FetchSongFailure ? state.error : null,
                        items: state is FetchSongSuccess ? state.songs : [],
                        emptyMessage: 'No trending tracks available',
                        itemBuilder:
                            (context, item, index) => CommonSongCard(
                              song: state is FetchSongSuccess ? state.songs : [],
                              index: index,
                            ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
