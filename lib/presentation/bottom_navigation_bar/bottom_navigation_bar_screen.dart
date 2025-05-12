import 'package:audionyx/core/constants/theme_color.dart';
import 'package:audionyx/presentation/bottom_navigation_bar/library_screen/library_screen.dart';
import 'package:audionyx/presentation/bottom_navigation_bar/search_screen/song_browser_screen.dart';
import 'package:audionyx/presentation/widget/mini_player_widget.dart';
import 'package:audionyx/repository/bloc/audio_player_bloc_cubit/audio_player_bloc_cubit.dart';
import 'package:audionyx/repository/bloc/audio_player_bloc_cubit/audio_player_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../upload_song_screen/add_songs_screen.dart';
import 'home_screen/home_screen.dart';

class BottomNavigationBarScreen extends StatefulWidget {
  const BottomNavigationBarScreen({super.key});

  @override
  State<BottomNavigationBarScreen> createState() =>
      _BottomNavigationBarScreenState();
}

class _BottomNavigationBarScreenState extends State<BottomNavigationBarScreen> {
  int _currentIndex = 0;

  // List of screens for navigation
  final List<Widget> _screens = [
    const HomeScreen(),
    const SongBrowserScreen(),
    const LibraryScreen(),
    const AddSongsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<AudioPlayerBlocCubit, AudioPlayerState>(
        builder: (context, state) {
          return Stack(children: [_screens[_currentIndex], MiniPlayerWidget()]);
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: ThemeColor.white,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.library_music_rounded),
            label: 'Library',
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.add_to_drive_sharp),
            label: 'Add Song',
          ),
        ],
      ),
    );
  }
}
