import 'package:audionyx/presentation/bottom_navigation_bar/library_screen/library_screen.dart';
import 'package:audionyx/presentation/bottom_navigation_bar/search_screen/song_browser_screen.dart';
import 'package:audionyx/presentation/widget/mini_player_widget.dart';
import 'package:audionyx/repository/bloc/audio_player_bloc_cubit/audio_player_bloc_cubit.dart';
import 'package:audionyx/repository/bloc/audio_player_bloc_cubit/audio_player_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
  ];

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

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
        backgroundColor: theme.brightness == Brightness.dark
            ? theme.scaffoldBackgroundColor
            : Colors.white,
        selectedItemColor: theme.colorScheme.primary,
        unselectedItemColor: theme.iconTheme.color?.withOpacity(0.6),
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: theme.iconTheme.color?.withOpacity(0.6)),
            activeIcon: Icon(Icons.home, color: theme.colorScheme.primary),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.search, color: theme.iconTheme.color?.withOpacity(0.6)),
            activeIcon: Icon(CupertinoIcons.search, color: theme.colorScheme.primary),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.library_music_rounded, color: theme.iconTheme.color?.withOpacity(0.6)),
            activeIcon: Icon(Icons.library_music_rounded, color: theme.colorScheme.primary),
            label: 'Library',
          ),
        ],
      ),
    );
  }
}