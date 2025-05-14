import 'package:audionyx/core/constants/extension.dart';
import 'package:audionyx/presentation/auth_screen/email_auth/login_screen.dart';
import 'package:audionyx/presentation/bottom_navigation_bar/library_screen/tabs/download_song_screen.dart';
import 'package:audionyx/presentation/bottom_navigation_bar/user_profile_screen/profile_picture.dart';
import 'package:audionyx/presentation/bottom_navigation_bar/user_profile_screen/upload_song_screen/add_songs_screen.dart';
import 'package:audionyx/repository/bloc/auth_bloc_cubit/login_bloc_cubit/login_bloc_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../repository/bloc/theme_cubit/theme_cubit.dart';

class UserProfileScreen extends StatefulWidget {
  final String userId;

  const UserProfileScreen({super.key, required this.userId});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  late Map<String, dynamic> _userData;

  @override
  void initState() {
    super.initState();
    _userData = {
      'name': 'John Doe',
      'profilePicture': 'https://via.placeholder.com/150',
    };
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = context.width(context);
    final fontScale = screenWidth < 360 ? 0.9 : 1.0;
    final verticalSpacing = context.height(context) * 0.04;
    final horizontalPadding = screenWidth * 0.06;

    return BlocBuilder<ThemeCubit, bool>(
      builder: (context, isDarkMode) {
        return Scaffold(
          appBar: AppBar(
            elevation: 0,
            title: Text(
              'Profile',
              style: TextStyle(
                fontSize: 20 * fontScale,
                fontWeight: FontWeight.bold,
              ),
            ),
            centerTitle: true,
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: context.height(context)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: verticalSpacing),
                    ProfilePicture(
                      imageUrl: _userData['profilePicture'],
                      size: screenWidth * 0.35 > 150 ? 150 : screenWidth * 0.35,
                    ),
                    SizedBox(height: verticalSpacing * 0.5),
                    TweenAnimationBuilder(
                      tween: Tween<double>(begin: 0, end: 1),
                      duration: const Duration(milliseconds: 500),
                      builder: (context, opacity, child) {
                        return Opacity(
                          opacity: opacity,
                          child: Text(
                            _userData['name'],
                            style: TextStyle(
                              fontSize: 28 * fontScale,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.2,
                            ),
                          ),
                        );
                      },
                    ),
                    SizedBox(height: verticalSpacing),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                      child: Column(
                        children: [
                          _buildActionButton(
                            icon: isDarkMode ? Icons.dark_mode : Icons.light_mode,
                            label: 'Toggle ${isDarkMode ? "Light" : "Dark"} Mode',
                            onPressed: () => context.read<ThemeCubit>().toggleTheme(),
                            fontScale: fontScale,
                          ),
                          SizedBox(height: verticalSpacing * 0.5),
                          _buildActionButton(
                            icon: Icons.download,
                            label: 'Downloads',
                            onPressed: () => context.push(context, target: const DownloadedSongsScreen()),
                            fontScale: fontScale,
                          ),
                          SizedBox(height: verticalSpacing * 0.5),
                          _buildActionButton(
                            icon: Icons.add,
                            label: 'Add Song',
                            onPressed: () => context.push(context, target: const AddSongsScreen()),
                            fontScale: fontScale,
                          ),
                          SizedBox(height: verticalSpacing * 0.5),
                          _buildActionButton(
                            icon: Icons.logout,
                            label: 'Logout',
                            onPressed: () {
                              context.read<LoginBlocCubit>().logout();
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Logged out')),
                              );
                              context.pushAndRemoveUntil(context, target: const LoginScreen());
                            },
                            fontScale: fontScale,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: verticalSpacing),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
    required double fontScale,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 24 * fontScale),
            const SizedBox(width: 12),
            Text(
              label,
              style: TextStyle(
                fontSize: 16 * fontScale,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}