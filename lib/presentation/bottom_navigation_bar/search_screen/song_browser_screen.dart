import 'package:audionyx/core/constants/theme_color.dart';
import 'package:audionyx/domain/song_model/song_model.dart';
import 'package:audionyx/presentation/bottom_navigation_bar/search_screen/widget/filter_chip.dart';
import 'package:audionyx/presentation/bottom_navigation_bar/search_screen/widget/filter_dialog.dart';
import 'package:audionyx/presentation/bottom_navigation_bar/search_screen/widget/search_bar.dart';
import 'package:audionyx/presentation/bottom_navigation_bar/search_screen/widget/song_list.dart';
import 'package:audionyx/presentation/download_song_screen/download_song_screen.dart';
import 'package:audionyx/presentation/playlist_management_screen/playlist_management_screen.dart';
import 'package:audionyx/repository/bloc/fetch_song_bloc_cubit/fetch_song_bloc_cubit.dart';
import 'package:audionyx/repository/bloc/fetch_song_bloc_cubit/fetch_song_state.dart';
import 'package:audionyx/repository/service/song_service/song_browser_service/song_browser_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:audionyx/core/constants/extension.dart';

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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Browse Music', style: TextStyle(color: ThemeColor.white, fontWeight: FontWeight.bold)),
        backgroundColor: ThemeColor.darkBackground,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.download_rounded, color: ThemeColor.white),
            onPressed: () => context.push(context, target: const DownloadedSongsScreen()),
          ),
          IconButton(
            icon: const Icon(Icons.queue_music, color: ThemeColor.white),
            onPressed: () => context.push(context, target: const PlaylistManagementScreen()),
          ),
        ],
      ),
      body: BlocBuilder<FetchSongBlocCubit, FetchSongState>(
        builder: (context, state) {
          if (state is FetchSongLoading) {
            return const Center(child: CircularProgressIndicator(color: ThemeColor.greenAccent));
          } else if (state is FetchSongFailure) {
            return _buildErrorView(state.error);
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
                _buildTabBar(allSongs),
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
                    hasFilters: selectedGenre != null || selectedArtist != null || selectedAlbum != null,
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
          return const Center(child: Text('No songs yet', style: TextStyle(color: ThemeColor.white)));
        },
      ),
    );
  }

  Widget _buildTabBar(List<SongData> allSongs) {
    return Row(
      children: [
        Expanded(
          child: TabBar(
            controller: _tabController,
            labelColor: ThemeColor.white,
            unselectedLabelColor: ThemeColor.grey,
            indicatorColor: ThemeColor.greenAccent,
            indicatorSize: TabBarIndicatorSize.label,
            tabs: const [
              Tab(text: 'All'),
              Tab(text: 'Artists'),
              Tab(text: 'Albums'),
            ],
          ),
        ),
        IconButton(
          icon: Icon(
            Icons.filter_list,
            color: selectedGenre != null || selectedArtist != null || selectedAlbum != null
                ? ThemeColor.greenAccent
                : ThemeColor.white,
          ),
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => FilterDialog(
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
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildErrorView(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, color: ThemeColor.white, size: 48),
          const SizedBox(height: 16),
          Text(
            error,
            style: const TextStyle(color: ThemeColor.white),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => context.read<FetchSongBlocCubit>().fetchSongs(),
            style: ElevatedButton.styleFrom(
              backgroundColor: ThemeColor.greenAccent,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: const Text('Retry', style: TextStyle(color: ThemeColor.white)),
          ),
        ],
      ),
    );
  }
}