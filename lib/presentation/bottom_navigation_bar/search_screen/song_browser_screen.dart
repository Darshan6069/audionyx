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

  String searchQuery = '';
  String? selectedGenre;
  String? selectedArtist;
  String? selectedAlbum;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    context.read<FetchSongBlocCubit>().fetchSongs();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Widget _buildSongTile(SongData song, int index, List<SongData> songs) {
    return ListTile(
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: CachedNetworkImage(
          imageUrl: song.thumbnailUrl,
          width: 50,
          height: 50,
          fit: BoxFit.cover,
          placeholder: (context, url) => const CircularProgressIndicator(),
          errorWidget: (context, url, error) => const Icon(Icons.music_note, color: ThemeColor.white),
        ),
      ),
      title: Text(song.title, style: const TextStyle(color: ThemeColor.white)),
      subtitle: Text(song.artist, style: const TextStyle(color: ThemeColor.grey)),
      trailing: IconButton(
        icon: const Icon(Icons.play_arrow, color: ThemeColor.white),
        onPressed: () => _service.playSong(context, song, index, songs),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColor.darkBackground,
      appBar: AppBar(
        title: TextField(
          style: const TextStyle(color: ThemeColor.white),
          decoration: const InputDecoration(
            hintText: 'Search songs...',
            hintStyle: TextStyle(color: ThemeColor.grey),
            border: InputBorder.none,
          ),
          onChanged: (value) {
            setState(() {
              searchQuery = value;
            });
          },
        ),
        backgroundColor: ThemeColor.darkBackground,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.library_music_rounded, color: ThemeColor.white),
            onPressed: () => context.push(context, target: const DownloadedSongsScreen()),
          ),
          IconButton(
            icon: const Icon(Icons.queue_music, color: ThemeColor.white),
            onPressed: () => context.push(context, target: const PlaylistManagementScreen()),
          ),
        ],
      ),
      body: Column(
        children: [
          TabBar(
            controller: _tabController,
            labelColor: ThemeColor.white,
            unselectedLabelColor: ThemeColor.grey,
            indicatorColor: ThemeColor.white,
            tabs: const [
              Tab(text: 'Genre'),
              Tab(text: 'Artist'),
              Tab(text: 'Album'),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: BlocBuilder<FetchSongBlocCubit, FetchSongState>(
              builder: (context, state) {
                List<SongData> allSongs = state is FetchSongSuccess ? state.songs : [];
                return Row(
                  children: [
                    Expanded(
                      child: DropdownButton<String>(
                        hint: const Text('Select Genre', style: TextStyle(color: ThemeColor.white)),
                        value: selectedGenre,
                        isExpanded: true,
                        dropdownColor: ThemeColor.grey,
                        items: _service.getUniqueGenres(allSongs).map((genre) {
                          return DropdownMenuItem(
                            value: genre,
                            child: Text(genre, style: const TextStyle(color: ThemeColor.white)),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedGenre = value;
                          });
                        },
                      ),
                    ),
                    if (_tabController.index == 1) ...[
                      const SizedBox(width: 8),
                      Expanded(
                        child: DropdownButton<String>(
                          hint: const Text('Select Artist', style: TextStyle(color: ThemeColor.white)),
                          value: selectedArtist,
                          isExpanded: true,
                          dropdownColor: ThemeColor.grey,
                          items: _service.getUniqueArtists(allSongs).map((artist) {
                            return DropdownMenuItem(
                              value: artist,
                              child: Text(artist, style: const TextStyle(color: ThemeColor.white)),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedArtist = value;
                            });
                          },
                        ),
                      ),
                    ],
                    if (_tabController.index == 2) ...[
                      const SizedBox(width: 8),
                      Expanded(
                        child: DropdownButton<String>(
                          hint: const Text('Select Album', style: TextStyle(color: ThemeColor.white)),
                          value: selectedAlbum,
                          isExpanded: true,
                          dropdownColor: ThemeColor.grey,
                          items: _service.getUniqueAlbums(allSongs).map((album) {
                            return DropdownMenuItem(
                              value: album,
                              child: Text(album, style: const TextStyle(color: ThemeColor.white)),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedAlbum = value;
                            });
                          },
                        ),
                      ),
                    ],
                  ],
                );
              },
            ),
          ),
          Expanded(
            child: BlocBuilder<FetchSongBlocCubit, FetchSongState>(
              builder: (context, state) {
                if (state is FetchSongSuccess) {
                  final filteredSongs = _service.filterSongs(
                    state.songs,
                    searchQuery,
                    selectedGenre,
                    selectedArtist,
                    selectedAlbum,
                  );
                  if (filteredSongs.isEmpty) {
                    return const Center(child: Text('No songs found', style: TextStyle(color: ThemeColor.white)));
                  }
                  return ListView.builder(
                    itemCount: filteredSongs.length,
                    itemBuilder: (context, index) => _buildSongTile(
                      filteredSongs[index],
                      index,
                      filteredSongs,
                    ),
                  );
                } else if (state is FetchSongLoading) {
                  return const Center(child: CircularProgressIndicator(color: ThemeColor.white));
                } else if (state is FetchSongFailure) {
                  return Center(child: Text(state.error, style: const TextStyle(color: ThemeColor.white)));
                }
                return const Center(child: Text('No songs yet', style: TextStyle(color: ThemeColor.white)));
              },
            ),
          ),
        ],
      ),
    );
  }
}
