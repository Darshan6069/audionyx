import 'dart:convert';
import 'package:audionyx/repository/bloc/fetch_song_bloc_cubit/fetch_song_bloc_cubit.dart';
import 'package:audionyx/repository/bloc/fetch_song_bloc_cubit/fetch_song_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constants/app_image.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/theme_color.dart';
import '../../../repository/bloc/auth_bloc_cubit/login_bloc_cubit/login_bloc_cubit.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch songs when the screen is initialized
    context.read<FetchSongBlocCubit>().fetchSongs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  BlocProvider(
                    create: (context) => LoginBlocCubit(),
                    child: Builder(
                      builder: (context) => IconButton(
                        onPressed: () {
                          context.read<LoginBlocCubit>().logout();
                        },
                        icon: const Icon(
                          Icons.person,
                          color: ThemeColor.white,
                          size: 30,
                        ),
                      ),
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
              BlocBuilder<FetchSongBlocCubit, FetchSongState>(
                builder: (context, state) {
                  return SizedBox(
                    height: 200,
                    child: () {
                      if (state is FetchSongInitial) {
                        return const Center(
                          child: Text(
                            'No songs yet',
                            style: TextStyle(color: ThemeColor.white),
                          ),
                        );
                      } else if (state is FetchSongLoading) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (state is FetchSongSuccess) {
                        if (state.songs.isEmpty) {
                          return const Center(
                            child: Text(
                              'No songs available',
                              style: TextStyle(color: ThemeColor.white),
                            ),
                          );
                        }
                        return ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: state.songs.length,
                          itemBuilder: (context, index) {
                            final song = state.songs[index];
                            return _buildFeaturedCard(
                              image: song.thumbnail,
                              title: song.title,
                              subtitle: song.artist,
                            );
                          },
                        );
                      } else if (state is FetchSongFailure) {
                        return Center(
                          child: Text(
                            state.error,
                            style: const TextStyle(color: ThemeColor.white),
                          ),
                        );
                      }
                      return const SizedBox(); // Fallback for unexpected states
                    }(),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeaturedCard({
    String? image,
    String? title,
    String? subtitle,
  }) {
    // Fallback values for null fields
    final safeImage = image ?? '';
    final safeTitle = title ?? 'Unknown Title';
    final safeSubtitle = subtitle ?? 'Unknown Artist';

    return Container(
      width: 300,
      margin: const EdgeInsets.only(right: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        image: DecorationImage(
          image: safeImage.isNotEmpty && safeImage.startsWith('data:image')
              ? MemoryImage(base64Decode(safeImage.split(',')[1]))
              : safeImage.isNotEmpty
              ? NetworkImage(safeImage)
              : const AssetImage('assets/images/placeholder.jpg'),
          fit: BoxFit.cover,
        ),
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
                  safeTitle,
                  style: const TextStyle(
                    color: ThemeColor.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  safeSubtitle,
                  style: const TextStyle(color: ThemeColor.grey, fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}