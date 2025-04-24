import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/constants/app_image.dart';
import '../../core/constants/app_strings.dart';
import '../../core/constants/theme_color.dart';
import '../../repository/bloc/auth_bloc_cubit/login_bloc_cubit/login_bloc_cubit.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    }); // Add navigation logic here for other tabs (Search, Library, Profile) }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginBlocCubit(),
      child: Scaffold(
        backgroundColor: ThemeColor.darkBackground,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image.asset(
                      AppImage.logo,
                      height: 40,
                      color: ThemeColor.white,
                    ),
                    IconButton(
                      onPressed: () {
                        context.read<LoginBlocCubit>().logout();
                      },
                      icon: const Icon(
                        Icons.person,
                        color: ThemeColor.white,
                        size: 30,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Text(
                  AppStrings.goodMorning,
                  style: TextStyle(
                    color: ThemeColor.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildCategoryChip(AppStrings.newest),
                      _buildCategoryChip(AppStrings.hot),
                      _buildCategoryChip(AppStrings.radio),
                      _buildCategoryChip(AppStrings.artists),
                      _buildCategoryChip(AppStrings.podcasts),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  height: 200,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      _buildFeaturedCard(
                        image: AppImage.featuredAlbum,
                        title: AppStrings.newAlbum,
                        subtitle: AppStrings.albumSubtitle,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  AppStrings.madeForYou,
                  style: TextStyle(
                    color: ThemeColor.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 0.8,
                  children: [
                    _buildPlaylistCard(AppImage.playlist1, AppStrings.playlist1),
                    _buildPlaylistCard(AppImage.playlist2, AppStrings.playlist2),
                    _buildPlaylistCard(AppImage.playlist3, AppStrings.playlist3),
                  ],
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: ThemeColor.darkBackground,
          selectedItemColor: ThemeColor.greenAccent,
          unselectedItemColor: ThemeColor.grey,
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
            BottomNavigationBarItem(icon: Icon(Icons.search), label: ''),
            BottomNavigationBarItem(icon: Icon(Icons.library_music), label: ''),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: ''),
          ],
        ),
      ),
    );
  }
}

Widget _buildCategoryChip(String label) {
  return Padding(
    padding: const EdgeInsets.only(right: 10),
    child: Chip(
      label: Text(
        label,
        style: const TextStyle(color: ThemeColor.white, fontSize: 14),
      ),
      backgroundColor: ThemeColor.grey.withOpacity(0.3),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
    ),
  );
}

Widget _buildPlaylistCard(String image, String title) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Container(
        height: 120,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          image: DecorationImage(image: AssetImage(image), fit: BoxFit.cover),
        ),
      ),
      const SizedBox(height: 5),
      Text(
        title,
        style: const TextStyle(color: ThemeColor.white, fontSize: 14),
      ),
    ],
  );
}

Widget _buildFeaturedCard({
  required String image,
  required String title,
  required String subtitle,
}) {
  return Container(
    width: 300,
    margin: const EdgeInsets.only(right: 10),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      image: DecorationImage(image: AssetImage(image), fit: BoxFit.cover),
    ),
    child: Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            gradient: LinearGradient(
              colors: [Colors.black.withOpacity(0.7), Colors.transparent],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: ThemeColor.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                subtitle,
                style: const TextStyle(color: ThemeColor.grey, fontSize: 14),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
