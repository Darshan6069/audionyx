import 'package:audionyx/core/constants/extension.dart';
import 'package:audionyx/presentation/bottom_navigation_bar/search_screen/widget/filter_chip.dart';
import 'package:audionyx/presentation/bottom_navigation_bar/search_screen/widget/filter_dialog.dart';
import 'package:audionyx/presentation/bottom_navigation_bar/search_screen/widget/search_bar.dart';
import 'package:audionyx/presentation/bottom_navigation_bar/search_screen/widget/song_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_framework/responsive_framework.dart';
import '../../../domain/song_model/song_model.dart';
import '../../../repository/bloc/fetch_song_bloc_cubit/fetch_song_bloc_cubit.dart';
import '../../../repository/bloc/fetch_song_bloc_cubit/fetch_song_state.dart';
import '../../../repository/service/song_service/song_browser_service/song_browser_service.dart';
import '../library_screen/tabs/download_song_screen.dart';

class SongBrowserScreen extends StatefulWidget {
  const SongBrowserScreen({super.key});

  @override
  State<SongBrowserScreen> createState() => _SongBrowserScreenState();
}

class _SongBrowserScreenState extends State<SongBrowserScreen> with SingleTickerProviderStateMixin {
  final SongBrowserService _service = SongBrowserService();
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  String searchQuery = '';
  String? selectedGenre;
  String? selectedArtist;
  String? selectedAlbum;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(_handleTabChange);
    context.read<FetchSongBlocCubit>().fetchSongs();
  }

  void _handleTabChange() {
    if (_tabController.indexIsChanging) {
      setState(() {
        selectedGenre = null;
        selectedArtist = null;
        selectedAlbum = null;
      });
    }
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabChange);
    _tabController.dispose();
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _clearSearch() {
    setState(() {
      _searchController.clear();
      searchQuery = '';
    });
  }

  void _clearFilters() {
    setState(() {
      selectedGenre = null;
      selectedArtist = null;
      selectedAlbum = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isTablet = ResponsiveBreakpoints.of(context).isTablet;
    final isDesktop = ResponsiveBreakpoints.of(context).isDesktop;
    final horizontalPadding =
        isDesktop
            ? 80.0
            : isTablet
            ? 40.0
            : 20.0;
    final titleFontSize =
        isDesktop
            ? 24.0
            : isTablet
            ? 20.0
            : 18.0;
    final tabFontSize =
        isDesktop
            ? 16.0
            : isTablet
            ? 14.0
            : 12.0;
    final iconSize =
        isDesktop
            ? 28.0
            : isTablet
            ? 24.0
            : 20.0;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Browse Music',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: titleFontSize,
          ),
        ),
        backgroundColor: theme.appBarTheme.backgroundColor,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.download_rounded, color: theme.iconTheme.color, size: iconSize),
            onPressed: () => context.push(context, target: const DownloadedSongsScreen()),
          ),
        ],
      ),
      body: BlocBuilder<FetchSongBlocCubit, FetchSongState>(
        builder: (context, state) {
          if (state is FetchSongLoading) {
            return Center(child: CircularProgressIndicator(color: theme.colorScheme.primary));
          } else if (state is FetchSongFailure) {
            return _buildErrorView(state.error, theme, isDesktop, isTablet);
          } else if (state is FetchSongSuccess) {
            final allSongs = state.songs;
            final filteredSongs = _service.filterSongs(
              allSongs,
              searchQuery,
              selectedGenre,
              selectedArtist,
              selectedAlbum,
            );

            return Column(
              children: [
                SearchBarWidget(
                  controller: _searchController,
                  focusNode: _searchFocusNode,
                  searchQuery: searchQuery,
                  onClear: _clearSearch,
                  onChanged: (value) {
                    setState(() {
                      searchQuery = value;
                    });
                  },
                ),
                _buildTabBar(
                  allSongs,
                  theme,
                  isDesktop,
                  isTablet,
                  horizontalPadding,
                  tabFontSize,
                  iconSize,
                ),
                FilterChipsWidget(
                  selectedGenre: selectedGenre,
                  selectedArtist: selectedArtist,
                  selectedAlbum: selectedAlbum,
                  onGenreDeleted: () => setState(() => selectedGenre = null),
                  onArtistDeleted: () => setState(() => selectedArtist = null),
                  onAlbumDeleted: () => setState(() => selectedAlbum = null),
                  onClearAll: _clearFilters,
                ),
                Expanded(
                  child: SongListWidget(
                    filteredSongs: filteredSongs,
                    searchQuery: searchQuery,
                    hasFilters:
                        selectedGenre != null || selectedArtist != null || selectedAlbum != null,
                    service: _service,
                    onClearFilters: () {
                      setState(() {
                        _searchController.clear();
                        searchQuery = '';
                        selectedGenre = null;
                        selectedArtist = null;
                        selectedAlbum = null;
                      });
                    },
                  ),
                ),
              ],
            );
          }
          return Center(
            child: Text(
              'No songs yet',
              style: theme.textTheme.bodyLarge?.copyWith(
                fontSize:
                    isDesktop
                        ? 18.0
                        : isTablet
                        ? 16.0
                        : 14.0,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTabBar(
    List<SongData> allSongs,
    ThemeData theme,
    bool isDesktop,
    bool isTablet,
    double horizontalPadding,
    double tabFontSize,
    double iconSize,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: Row(
        children: [
          Expanded(
            child: TabBar(
              controller: _tabController,
              labelColor: theme.textTheme.bodyLarge?.color,
              unselectedLabelColor: theme.textTheme.bodyMedium?.color,
              indicatorColor: theme.colorScheme.primary,
              indicatorSize: TabBarIndicatorSize.label,
              tabs: [
                Tab(child: Text('All', style: TextStyle(fontSize: tabFontSize))),
                Tab(child: Text('Artists', style: TextStyle(fontSize: tabFontSize))),
                Tab(child: Text('Albums', style: TextStyle(fontSize: tabFontSize))),
              ],
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.filter_list,
              color:
                  selectedGenre != null || selectedArtist != null || selectedAlbum != null
                      ? theme.colorScheme.primary
                      : theme.iconTheme.color,
              size: iconSize,
            ),
            onPressed: () {
              showDialog(
                context: context,
                builder:
                    (context) => FilterDialog(
                      allSongs: allSongs,
                      selectedGenre: selectedGenre,
                      selectedArtist: selectedArtist,
                      selectedAlbum: selectedAlbum,
                      service: _service,
                      onApply: (genre, artist, album) {
                        setState(() {
                          selectedGenre = genre;
                          selectedArtist = artist;
                          selectedAlbum = album;
                        });
                      },
                    ),
              );
            },
          ),
          SizedBox(width: horizontalPadding / 2),
        ],
      ),
    );
  }

  Widget _buildErrorView(String error, ThemeData theme, bool isDesktop, bool isTablet) {
    final iconSize =
        isDesktop
            ? 56.0
            : isTablet
            ? 52.0
            : 48.0;
    final fontSize =
        isDesktop
            ? 18.0
            : isTablet
            ? 16.0
            : 14.0;
    final verticalSpacing = isDesktop || isTablet ? 20.0 : 16.0;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, color: theme.iconTheme.color, size: iconSize),
          SizedBox(height: verticalSpacing),
          Text(
            error,
            style: theme.textTheme.bodyLarge?.copyWith(fontSize: fontSize),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: verticalSpacing + 8),
          ElevatedButton(
            onPressed: () => context.read<FetchSongBlocCubit>().fetchSongs(),
            style: theme.elevatedButtonTheme.style,
            child: Text(
              'Retry',
              style: TextStyle(color: theme.colorScheme.onPrimary, fontSize: fontSize),
            ),
          ),
        ],
      ),
    );
  }
}
