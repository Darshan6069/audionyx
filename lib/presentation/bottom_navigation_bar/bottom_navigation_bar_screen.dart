
import 'package:audionyx/core/constants/theme_color.dart';
import 'package:audionyx/presentation/bottom_navigation_bar/favourite_songs_screen/favourite_songs_screen.dart';
import 'package:audionyx/presentation/bottom_navigation_bar/library_screen/library_screen.dart';
import 'package:audionyx/presentation/bottom_navigation_bar/search_screen/search_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../add_songs_screen.dart';
import 'home_screen/home_screen.dart';

class BottomNavigationBarScreen extends StatefulWidget {
  const BottomNavigationBarScreen({super.key});

  @override
  State<BottomNavigationBarScreen> createState() => _BottomNavigationBarScreenState();
}

class _BottomNavigationBarScreenState extends State<BottomNavigationBarScreen> {
  int _currentIndex = 0;

  // List of screens for navigation
  final List<Widget> _screens = [
    const HomeScreen(),
    const SearchScreen(),
    const LibraryScreen(),
    const FavouriteSongsScreen(),
    const AddSongsScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor:  ThemeColor.white,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.library_music_rounded),
            label: 'Library',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.heart_fill),
            label: 'Favourite',
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
