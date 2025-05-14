import 'package:audionyx/core/constants/app_strings.dart';
import 'package:audionyx/presentation/bottom_navigation_bar/library_screen/library_screen.dart';
import 'package:audionyx/presentation/bottom_navigation_bar/search_screen/song_browser_screen.dart';
import 'package:audionyx/presentation/bottom_navigation_bar/user_profile_screen/user_profile_screen.dart';
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
  String? _userId; // Store userId here
  bool _isLoadingUserId = true; // Track loading state

  // List of screens for navigation
  late List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _loadUserId();
  }

  // Load userId asynchronously
  Future<void> _loadUserId() async {
    final userId = await AppStrings.secureStorage.read(key: 'userId');
    setState(() {
      _userId = userId;
      _isLoadingUserId = false;
      // Initialize screens after userId is loaded
      _screens = [
        const HomeScreen(),
        const SongBrowserScreen(),
        const LibraryScreen(),
        UserProfileScreen(userId: _userId ?? ''), // Fallback to empty string if null
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    // Show a loading indicator while userId is being fetched
    if (_isLoadingUserId) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      body: BlocBuilder<AudioPlayerBlocCubit, AudioPlayerState>(
        builder: (context, state) {
          return Stack(children: [_screens[_currentIndex], const MiniPlayerWidget()]);
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
          BottomNavigationBarItem(
            icon: Icon(Icons.person, color: theme.iconTheme.color?.withOpacity(0.6)),
            activeIcon: Icon(Icons.person, color: theme.colorScheme.primary),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}