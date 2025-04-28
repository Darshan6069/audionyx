import 'dart:convert';
import 'package:audionyx/core/constants/extension.dart';
import 'package:audionyx/core/constants/theme_color.dart';
import 'package:audionyx/download_song_screen.dart';
import 'package:audionyx/playlist_management_screen.dart';
import 'package:audionyx/presentation/bottom_navigation_bar/home_screen/home_screen.dart';
import 'package:audionyx/repository/bloc/fetch_song_bloc_cubit/fetch_song_bloc_cubit.dart';
import 'package:audionyx/repository/bloc/fetch_song_bloc_cubit/fetch_song_state.dart';
import 'package:audionyx/repository/service/song_service/recently_play_song/recently_played_manager.dart';
import 'package:audionyx/song_play_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';

import 'domain/song_model/song_model.dart';

class SongBrowserScreen extends StatefulWidget {
  const SongBrowserScreen({super.key});

  @override
  State<SongBrowserScreen> createState() => _SongBrowserScreenState();
}

class _SongBrowserScreenState extends State<SongBrowserScreen> with SingleTickerProviderStateMixin {
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

  Future<List<dynamic>> fetchUserPlaylists() async {
    try {
      final response = await http
          .get(Uri.parse('http://192.168.0.3:4000/api/user/playlists'))
          .timeout(const Duration(seconds: 10));
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
    } catch (e) {
      print('Error fetching playlists: $e');
    }
    return [];
  }

  Future<void> addSongToPlaylist(String playlistId, SongData song) async {
    try {
      final response = await http
          .patch(
        Uri.parse('http://192.168.0.3:4000/api/playlists/$playlistId'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'action': 'add',
          'song': song.toMap(),
        }),
      )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Song added to playlist')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to add song')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error adding song: $e')),
      );
    }
  }

  void _showAddToPlaylistDialog(SongData song) async {
    final playlists = await fetchUserPlaylists();
    if (!mounted) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add to Playlist'),
        content: playlists.isEmpty
            ? const Text('No playlists found. Create a playlist first.')
            : SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: playlists.length,
            itemBuilder: (context, index) {
              final playlist = playlists[index];
              return ListTile(
                title: Text(playlist['title'] ?? 'Unknown Playlist'),
                onTap: () {
                  addSongToPlaylist(playlist['id'], song);
                  Navigator.pop(context);
                },
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          if (playlists.isEmpty)
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                context.push(context, target: const PlaylistManagementScreen());
              },
              child: const Text('Create Playlist'),
            ),
        ],
      ),
    );
  }

  void _playSong(SongData song, int index, List<SongData> songs) async {
    await RecentlyPlayedManager.addSongToRecentlyPlayed(song);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SongPlayerScreen(
          songList: songs,
          initialIndex: index,
        ),
      ),
    );
  }

  List<String> _getUniqueGenres(List<SongData> songs) {
    return songs.map((song) => song.genre).toSet().toList()..sort();
  }

  List<String> _getUniqueArtists(List<SongData> songs) {
    return songs.map((song) => song.artist).toSet().toList()..sort();
  }

  List<String> _getUniqueAlbums(List<SongData> songs) {
    return songs.map((song) => song.album).toSet().toList()..sort();
  }

  List<SongData> _filterSongs(List<SongData> songs) {
    return songs.where((song) {
      final matchesSearch = searchQuery.isEmpty ||
          song.title.toLowerCase().contains(searchQuery.toLowerCase()) ||
          song.artist.toLowerCase().contains(searchQuery.toLowerCase()) ||
          song.album.toLowerCase().contains(searchQuery.toLowerCase());

      final matchesGenre = selectedGenre == null || song.genre == selectedGenre;
      final matchesArtist = selectedArtist == null || song.artist == selectedArtist;
      final matchesAlbum = selectedAlbum == null || song.album == selectedAlbum;

      return matchesSearch && matchesGenre && matchesArtist && matchesAlbum;
    }).toList();
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
          errorWidget: (context, url, error) => const Icon(
            Icons.music_note,
            color: ThemeColor.white,
          ),
        ),
      ),
      title: Text(
        song.title,
        style: const TextStyle(color: ThemeColor.white),
      ),
      subtitle: Text(
        song.artist,
        style: const TextStyle(color: ThemeColor.grey),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.play_arrow, color: ThemeColor.white),
            onPressed: () => _playSong(song, index, songs),
          ),
          IconButton(
            icon: const Icon(Icons.add_to_queue, color: ThemeColor.white),
            onPressed: () => _showAddToPlaylistDialog(song),
          ),
        ],
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
            icon: const Icon(Icons.home, color: ThemeColor.white),
            onPressed: () => context.push(context, target: const HomeScreen()),
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
                        items: _getUniqueGenres(allSongs).map((genre) {
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
                          items: _getUniqueArtists(allSongs).map((artist) {
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
                          items: _getUniqueAlbums(allSongs).map((album) {
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
                if (state is FetchSongInitial) {
                  return const Center(
                    child: Text(
                      'No songs yet',
                      style: TextStyle(color: ThemeColor.white),
                    ),
                  );
                } else if (state is FetchSongLoading) {
                  return const Center(child: CircularProgressIndicator(color: ThemeColor.white));
                } else if (state is FetchSongSuccess) {
                  final filteredSongs = _filterSongs(state.songs);
                  if (filteredSongs.isEmpty) {
                    return const Center(
                      child: Text(
                        'No songs found',
                        style: TextStyle(color: ThemeColor.white),
                      ),
                    );
                  }
                  return ListView.builder(
                    itemCount: filteredSongs.length,
                    itemBuilder: (context, index) => _buildSongTile(
                      filteredSongs[index],
                      index,
                      filteredSongs,
                    ),
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
              },
            ),
          ),
        ],
      ),
    );
  }
}
