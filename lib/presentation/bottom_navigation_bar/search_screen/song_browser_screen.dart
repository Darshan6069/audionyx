import 'package:audionyx/core/constants/extension.dart';
import 'package:audionyx/core/constants/theme_color.dart';
import 'package:audionyx/presentation/download_song_screen/download_song_screen.dart';
import 'package:audionyx/presentation/playlist_management_screen/playlist_management_screen.dart';
import 'package:audionyx/repository/bloc/fetch_song_bloc_cubit/fetch_song_bloc_cubit.dart';
import 'package:audionyx/repository/bloc/fetch_song_bloc_cubit/fetch_song_state.dart';
import 'package:audionyx/repository/service/song_service/song_browser_service/song_browser_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../../../../domain/song_model/song_model.dart';
import '../home_screen/home_screen.dart';

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
  bool _showFilterPanel = false;

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

  Widget _buildChip(String label, VoidCallback onDelete) {
    return Chip(
      label: Text(
        label,
        style: const TextStyle(
          color: ThemeColor.white,
          fontSize: 12,
        ),
      ),
      backgroundColor: ThemeColor.darGreyColor,
      deleteIconColor: ThemeColor.white,
      onDeleted: onDelete,
    );
  }

  Widget _buildFilterChips() {
    List<Widget> chips = [];

    if (selectedGenre != null) {
      chips.add(_buildChip(
        "Genre: $selectedGenre",
            () => setState(() => selectedGenre = null),
      ));
    }

    if (selectedArtist != null) {
      chips.add(_buildChip(
        "Artist: $selectedArtist",
            () => setState(() => selectedArtist = null),
      ));
    }

    if (selectedAlbum != null) {
      chips.add(_buildChip(
        "Album: $selectedAlbum",
            () => setState(() => selectedAlbum = null),
      ));
    }

    return chips.isEmpty
        ? const SizedBox.shrink()
        : Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Wrap(
        spacing: 8.0,
        runSpacing: 4.0,
        children: [
          ...chips,
          if (chips.length > 1)
            TextButton.icon(
              icon: const Icon(Icons.clear_all, color: ThemeColor.greenAccent),
              label: const Text('Clear All', style: TextStyle(color: ThemeColor.greenAccent)),
              onPressed: _clearFilters,
            ),
        ],
      ),
    );
  }

  Widget _buildFilterDialog(BuildContext context, List<SongData> allSongs) {
    List<String> genres = _service.getUniqueGenres(allSongs);
    List<String> artists = _service.getUniqueArtists(allSongs);
    List<String> albums = _service.getUniqueAlbums(allSongs);

    String? tempGenre = selectedGenre;
    String? tempArtist = selectedArtist;
    String? tempAlbum = selectedAlbum;

    return StatefulBuilder(
      builder: (context, setState) {
        return AlertDialog(
          backgroundColor: ThemeColor.darkBackground,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Filter Songs', style: TextStyle(color: ThemeColor.white)),
              IconButton(
                icon: const Icon(Icons.close, color: ThemeColor.white),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Genre', style: TextStyle(color: ThemeColor.greenAccent)),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: ThemeColor.darGreyColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: DropdownButton<String>(
                    hint: const Text('Select Genre', style: TextStyle(color: ThemeColor.grey)),
                    value: tempGenre,
                    isExpanded: true,
                    dropdownColor: ThemeColor.darGreyColor,
                    underline: const SizedBox(),
                    items: [
                      const DropdownMenuItem<String>(
                        value: null,
                        child: Text('Any Genre', style: TextStyle(color: ThemeColor.grey)),
                      ),
                      ...genres.map((genre) {
                        return DropdownMenuItem(
                          value: genre,
                          child: Text(genre, style: const TextStyle(color: ThemeColor.white)),
                        );
                      }),
                    ],
                    onChanged: (value) {
                      setState(() {
                        tempGenre = value;
                      });
                    },
                  ),
                ),
                const SizedBox(height: 16),

                const Text('Artist', style: TextStyle(color: ThemeColor.greenAccent)),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: ThemeColor.darGreyColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: DropdownButton<String>(
                    hint: const Text('Select Artist', style: TextStyle(color: ThemeColor.grey)),
                    value: tempArtist,
                    isExpanded: true,
                    dropdownColor: ThemeColor.darGreyColor,
                    underline: const SizedBox(),
                    items: [
                      const DropdownMenuItem<String>(
                        value: null,
                        child: Text('Any Artist', style: TextStyle(color: ThemeColor.grey)),
                      ),
                      ...artists.map((artist) {
                        return DropdownMenuItem(
                          value: artist,
                          child: Text(artist, style: const TextStyle(color: ThemeColor.white)),
                        );
                      }),
                    ],
                    onChanged: (value) {
                      setState(() {
                        tempArtist = value;
                      });
                    },
                  ),
                ),
                const SizedBox(height: 16),

                const Text('Album', style: TextStyle(color: ThemeColor.greenAccent)),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: ThemeColor.darGreyColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: DropdownButton<String>(
                    hint: const Text('Select Album', style: TextStyle(color: ThemeColor.grey)),
                    value: tempAlbum,
                    isExpanded: true,
                    dropdownColor: ThemeColor.darGreyColor,
                    underline: const SizedBox(),
                    items: [
                      const DropdownMenuItem<String>(
                        value: null,
                        child: Text('Any Album', style: TextStyle(color: ThemeColor.grey)),
                      ),
                      ...albums.map((album) {
                        return DropdownMenuItem(
                          value: album,
                          child: Text(album, style: const TextStyle(color: ThemeColor.white)),
                        );
                      }),
                    ],
                    onChanged: (value) {
                      setState(() {
                        tempAlbum = value;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: const Text('Reset', style: TextStyle(color: ThemeColor.greenAccent)),
              onPressed: () {
                setState(() {
                  tempGenre = null;
                  tempArtist = null;
                  tempAlbum = null;
                });
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: ThemeColor.greenAccent,
              ),
              child: const Text('Apply', style: TextStyle(color: ThemeColor.white)),
              onPressed: () {
                this.setState(() {
                  selectedGenre = tempGenre;
                  selectedArtist = tempArtist;
                  selectedAlbum = tempAlbum;
                });
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildSongTile(SongData song, int index, List<SongData> songs) {
    return InkWell(
      onTap: () => _service.playSong(context, song, index, songs),
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
                  child: const Center(child: CircularProgressIndicator(color: ThemeColor.greenAccent, strokeWidth: 2)),
                ),
                errorWidget: (context, url, error) => Container(
                  width: 60,
                  height: 60,
                  color: ThemeColor.darGreyColor,
                  child: const Icon(Icons.music_note, color: ThemeColor.white),
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
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert, color: ThemeColor.white),
              color: ThemeColor.darGreyColor,
              onSelected: (value) {
                switch (value) {
                  case 'play':
                    _service.playSong(context, song, index, songs);
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
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      height: 48,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: ThemeColor.darGreyColor,
        borderRadius: BorderRadius.circular(24),
      ),
      child: TextField(
        controller: _searchController,
        focusNode: _searchFocusNode,
        style: const TextStyle(color: ThemeColor.white),
        decoration: InputDecoration(
          hintText: 'Search songs, artists, albums...',
          hintStyle: const TextStyle(color: ThemeColor.grey),
          prefixIcon: const Icon(Icons.search, color: ThemeColor.grey),
          suffixIcon: searchQuery.isNotEmpty
              ? IconButton(
            icon: const Icon(Icons.clear, color: ThemeColor.grey),
            onPressed: _clearSearch,
          )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
        ),
        onChanged: (value) {
          setState(() {
            searchQuery = value;
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColor.darkBackground,
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
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, color: ThemeColor.white, size: 48),
                  const SizedBox(height: 16),
                  Text(
                    state.error,
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
                _buildSearchBar(),
                Row(
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
                        color: _showFilterPanel || selectedGenre != null || selectedArtist != null || selectedAlbum != null
                            ? ThemeColor.greenAccent
                            : ThemeColor.white,
                      ),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => _buildFilterDialog(context, allSongs),
                        );
                      },
                    ),
                    const SizedBox(width: 8),
                  ],
                ),
                _buildFilterChips(),
                Expanded(
                  child: filteredSongs.isEmpty
                      ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.music_off, color: ThemeColor.grey, size: 64),
                        const SizedBox(height: 16),
                        Text(
                          searchQuery.isNotEmpty
                              ? 'No songs matched "$searchQuery"'
                              : 'No songs found with selected filters',
                          style: const TextStyle(color: ThemeColor.grey),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        if (searchQuery.isNotEmpty || selectedGenre != null || selectedArtist != null || selectedAlbum != null)
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _searchController.clear();
                                searchQuery = '';
                                selectedGenre = null;
                                selectedArtist = null;
                                selectedAlbum = null;
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: ThemeColor.greenAccent,
                              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                            ),
                            child: const Text('Clear Filters', style: TextStyle(color: ThemeColor.white)),
                          ),
                      ],
                    ),
                  )
                      : ListView.separated(
                    padding: const EdgeInsets.only(bottom: 16),
                    itemCount: filteredSongs.length,
                    separatorBuilder: (context, index) => const Divider(
                      height: 1,
                      color: ThemeColor.darGreyColor,
                      indent: 76,
                      endIndent: 16,
                    ),
                    itemBuilder: (context, index) => _buildSongTile(
                      filteredSongs[index],
                      index,
                      filteredSongs,
                    ),
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
}