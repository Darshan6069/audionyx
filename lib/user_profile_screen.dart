import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../core/constants/theme_color.dart';
import '../../domain/song_model/song_model.dart';
import '../song_play_screen.dart';

class UserProfileScreen extends StatefulWidget {
  final String userId;
  const UserProfileScreen({super.key, required this.userId});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  late String _selectedTab = 'Playlists';

  final Map<String, dynamic> _userData = {
    'name': 'John Doe',
    'profilePicture': 'https://via.placeholder.com/150',
    'followers': 123,
    'following': 456,
  };

  final List<Map<String, dynamic>> _playlists = [
    {'_id': '1', 'name': 'Chill Hits', 'thumbnailUrl': 'https://via.placeholder.com/150', 'songs': []},
    {'_id': '2', 'name': 'Workout Mix', 'thumbnailUrl': 'https://via.placeholder.com/150', 'songs': []},
  ];

  final List<Map<String, dynamic>> _darkSongsPlaylists = [
    {'_id': '3', 'name': 'Dark Vibes', 'thumbnailUrl': 'https://via.placeholder.com/150', 'songs': []},
  ];

  final List<SongData> _recentlyPlayed = [
    SongData(
      mp3Url: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3',
      title: 'Test Song',
      thumbnailUrl: 'https://via.placeholder.com/150',
      genre: '',
      artist: 'Test Artist',
      album: '',
      id: '1',
    ),
  ];

  Future<void> _createPlaylist() async {
    final controller = TextEditingController();
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: ThemeColor.darkBackground,
        title: const Text('Create Playlist', style: TextStyle(color: ThemeColor.white)),
        content: TextField(
          controller: controller,
          style: const TextStyle(color: ThemeColor.white),
          decoration: InputDecoration(
            hintText: 'Playlist Name',
            hintStyle: const TextStyle(color: ThemeColor.grey),
            filled: true,
            fillColor: ThemeColor.grey.withOpacity(0.3),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: ThemeColor.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Playlist "${controller.text}" created')),
                );
                Navigator.pop(context);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: ThemeColor.greenColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            ),
            child: const Text('Create', style: TextStyle(color: ThemeColor.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColor.darkBackground,
      body: SafeArea(
        child: Column(
          children: [
            _buildProfileHeader(),
            _buildTabBar(),
            Expanded(
              child: SingleChildScrollView(
                child: _buildTabContent(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [ThemeColor.greenColor, ThemeColor.darkBackground],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          ClipOval(
            child: CachedNetworkImage(
              imageUrl: _userData['profilePicture'],
              width: 100,
              height: 100,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                color: ThemeColor.grey,
                child: const Center(child: CircularProgressIndicator()),
              ),
              errorWidget: (context, url, error) => Container(
                color: ThemeColor.grey,
                child: const Icon(Icons.person, color: ThemeColor.white, size: 50),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            _userData['name'],
            style: const TextStyle(color: ThemeColor.white, fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            '${_userData['followers']} Followers • ${_userData['following']} Following',
            style: const TextStyle(color: ThemeColor.grey, fontSize: 14),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Edit Profile clicked')),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: ThemeColor.greenColor,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                ),
                child: const Text('Edit Profile', style: TextStyle(color: ThemeColor.white)),
              ),
              const SizedBox(width: 8),
              OutlinedButton(
                onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Logged out')),
                ),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: ThemeColor.grey),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                ),
                child: const Text('Logout', style: TextStyle(color: ThemeColor.white)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: () => Navigator.pushNamed(context, '/add_song'),
            icon: const Icon(Icons.add, color: ThemeColor.white),
            label: const Text('Add Song', style: TextStyle(color: ThemeColor.white)),
            style: ElevatedButton.styleFrom(
              backgroundColor: ThemeColor.greenColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    final tabs = ['Playlists', 'Dark Songs', 'Recently Played', 'Following'];
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: tabs.map((tab) => GestureDetector(
          onTap: () => setState(() => _selectedTab = tab),
          child: Text(
            tab,
            style: TextStyle(
              color: _selectedTab == tab ? ThemeColor.white : ThemeColor.grey,
              fontSize: 16,
              fontWeight: _selectedTab == tab ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        )).toList(),
      ),
    );
  }

  Widget _buildTabContent() {
    switch (_selectedTab) {
      case 'Playlists':
        return _buildPlaylistGrid('Your Playlists', _playlists, _createPlaylist);
      case 'Dark Songs':
        return _buildPlaylistGrid('Dark Songs Playlists', _darkSongsPlaylists, null);
      case 'Recently Played':
        return _buildRecentlyPlayedList();
      case 'Following':
        return _buildFollowingList();
      default:
        return Container();
    }
  }

  Widget _buildPlaylistGrid(String title, List<Map<String, dynamic>> playlists, VoidCallback? onAdd) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: const TextStyle(color: ThemeColor.white, fontSize: 18, fontWeight: FontWeight.bold)),
              if (onAdd != null)
                IconButton(icon: const Icon(Icons.add, color: ThemeColor.greenColor), onPressed: onAdd),
            ],
          ),
          const SizedBox(height: 8),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.8,
            ),
            itemCount: playlists.length,
            itemBuilder: (context, index) {
              final playlist = playlists[index];
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: CachedNetworkImage(
                      imageUrl: playlist['thumbnailUrl'],
                      width: double.infinity,
                      height: 120,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        color: ThemeColor.grey,
                        child: const Center(child: CircularProgressIndicator()),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: ThemeColor.grey,
                        child: const Icon(Icons.music_note, color: ThemeColor.white),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    playlist['name'],
                    style: const TextStyle(color: ThemeColor.white, fontSize: 14, fontWeight: FontWeight.bold),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const Text('0 songs', style: TextStyle(color: ThemeColor.grey, fontSize: 12)),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildRecentlyPlayedList() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Recently Played', style: TextStyle(color: ThemeColor.white, fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _recentlyPlayed.length,
            itemBuilder: (context, index) {
              final song = _recentlyPlayed[index];
              return ListTile(
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: CachedNetworkImage(
                    imageUrl: song.thumbnailUrl,
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(color: ThemeColor.grey),
                    errorWidget: (context, url, error) => Container(
                      color: ThemeColor.grey,
                      child: const Icon(Icons.music_note, color: ThemeColor.white),
                    ),
                  ),
                ),
                title: Text(
                  song.title,
                  style: const TextStyle(color: ThemeColor.white),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Text(
                  song.artist ?? 'Unknown Artist',
                  style: const TextStyle(color: ThemeColor.grey, fontSize: 12),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SongPlayerScreen(
                        songList: _recentlyPlayed,
                        initialIndex: index,
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFollowingList() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Following', style: TextStyle(color: ThemeColor.white, fontSize: 18, fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          Text('Following 456 users (mock data)', style: TextStyle(color: ThemeColor.white)),
        ],
      ),
    );
  }
}